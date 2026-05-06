from sqlalchemy import Column, Integer, ForeignKey, DateTime, Text
from sqlalchemy.orm import relationship
from database import Base
from models.inventory.vehicle import Vehicle
from models.user import User
from models.jobs.job import Job
from datetime import datetime

class VehicleHistory(Base):
    __tablename__ = "vehicle_history"

    id = Column(Integer, primary_key=True, index=True)
    vehicle_id = Column(Integer, ForeignKey("vehicles.id"), nullable=False)
    job_id = Column(Integer, ForeignKey("jobs.id"), nullable=False)
    action = Column(Text, nullable=False)
    performed_by_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    timestamp = Column(DateTime, default=datetime.utcnow)

    vehicle = relationship("Vehicle")
    job = relationship("Job")
    performed_by = relationship("User")
