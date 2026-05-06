from datetime import datetime

from pydantic import BaseModel

from ..models.jobs.job import JobStatus


class AssignJobRequest(BaseModel):
    vehicle_id: int
    assigned_to_id: int | None = None
    issue_log: str | None = None


class UpdateJobStatusRequest(BaseModel):
    job_id: int
    status: JobStatus
    transfer_reason: str | None = None


class JobResponse(BaseModel):
    id: int
    vehicle_id: int
    assigned_to_id: int | None = None
    status: JobStatus
    issue_log: str | None = None
    start_time: datetime | None = None
    pause_time: datetime | None = None
    resume_time: datetime | None = None
    finish_time: datetime | None = None
    transfer_reason: str | None = None
    created_at: datetime

    class Config:
        from_attributes = True
