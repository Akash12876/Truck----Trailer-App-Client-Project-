from sqlalchemy import Column, Integer, String, ForeignKey, Enum, DateTime, Text
from sqlalchemy.orm import relationship
from database import Base
from models.user import User
from models.inventory.vehicle import Vehicle
import enum
from datetime import datetime

class JobStatus(enum.Enum):
    pending = "pending"
    in_progress = "in_progress"
    paused = "paused"
    awaiting_parts = "awaiting_parts"
    finished = "finished"
    transferred = "transferred"

class Job(Base):
    __tablename__ = "jobs"

    id = Column(Integer, primary_key=True, index=True)
    vehicle_id = Column(Integer, ForeignKey("vehicles.id"), nullable=False)
    assigned_to_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    status = Column(Enum(JobStatus), default=JobStatus.pending)
    issue_log = Column(Text, nullable=True)
    start_time = Column(DateTime, nullable=True)
    pause_time = Column(DateTime, nullable=True)
    resume_time = Column(DateTime, nullable=True)
    finish_time = Column(DateTime, nullable=True)
    transfer_reason = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    vehicle = relationship("Vehicle")
    assigned_to = relationship("User")
