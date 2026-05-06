from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from ..database import SessionLocal
from ..models.jobs.job import Job, JobStatus
from ..models.inventory.vehicle import Vehicle
from ..models.user import User
from typing import Optional
from datetime import datetime

router = APIRouter(prefix="/jobs", tags=["jobs"])

async def get_db():
    async with SessionLocal() as session:
        yield session

@router.post("/assign")
async def assign_job(vehicle_id: int, assigned_to_id: int, db: AsyncSession = Depends(get_db)):
    job = Job(vehicle_id=vehicle_id, assigned_to_id=assigned_to_id, status=JobStatus.pending)
    db.add(job)
    await db.commit()
    await db.refresh(job)
    return {"msg": "Job assigned", "job_id": job.id}

@router.get("/pending")
async def get_pending_jobs(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Job).where(Job.status == JobStatus.pending))
    jobs = result.scalars().all()
    return jobs

@router.post("/update_status")
async def update_job_status(job_id: int, status: JobStatus, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Job).where(Job.id == job_id))
    job = result.scalar_one_or_none()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")
    job.status = status
    if status == JobStatus.in_progress:
        job.start_time = datetime.utcnow()
    elif status == JobStatus.paused:
        job.pause_time = datetime.utcnow()
    elif status == JobStatus.finished:
        job.finish_time = datetime.utcnow()
    await db.commit()
    await db.refresh(job)
    return {"msg": "Job status updated", "job_id": job.id, "status": job.status.value}
