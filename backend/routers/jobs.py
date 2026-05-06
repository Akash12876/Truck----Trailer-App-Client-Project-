from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from ..dependencies import get_db
from ..models.jobs.job import Job, JobStatus
from ..schemas.jobs import AssignJobRequest, JobResponse, UpdateJobStatusRequest

router = APIRouter(prefix="/jobs", tags=["jobs"])


@router.post("/assign")
async def assign_job(payload: AssignJobRequest, db: AsyncSession = Depends(get_db)):
    job = Job(
        vehicle_id=payload.vehicle_id,
        assigned_to_id=payload.assigned_to_id,
        issue_log=payload.issue_log,
        status=JobStatus.pending,
    )
    db.add(job)
    await db.commit()
    await db.refresh(job)
    return {"msg": "Job assigned", "job_id": job.id}


@router.get("/pending", response_model=list[JobResponse])
async def get_pending_jobs(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Job).where(Job.status == JobStatus.pending))
    return result.scalars().all()


@router.post("/update_status")
async def update_job_status(
    payload: UpdateJobStatusRequest,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(Job).where(Job.id == payload.job_id))
    job = result.scalar_one_or_none()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")

    job.status = payload.status
    if payload.status == JobStatus.in_progress:
        job.start_time = datetime.utcnow()
        job.resume_time = datetime.utcnow()
    elif payload.status == JobStatus.paused:
        job.pause_time = datetime.utcnow()
    elif payload.status == JobStatus.finished:
        job.finish_time = datetime.utcnow()
    elif payload.status == JobStatus.transferred:
        job.transfer_reason = payload.transfer_reason

    await db.commit()
    await db.refresh(job)
    return {"msg": "Job status updated", "job_id": job.id, "status": job.status.value}
