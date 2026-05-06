from sqlalchemy import Column, Integer, String, ForeignKey, Enum, DateTime, Text
from sqlalchemy.orm import relationship
from ..user import User
from ...database import Base
import enum
from datetime import datetime

class VehicleType(enum.Enum):
    truck = "truck"
    trailer = "trailer"

class Vehicle(Base):
    __tablename__ = "vehicles"

    id = Column(Integer, primary_key=True, index=True)
    type = Column(Enum(VehicleType), nullable=False)
    registration_number = Column(String, index=True, nullable=True)
    chassis_number = Column(String, index=True, nullable=True)
    serial_number = Column(String, index=True, nullable=True)
    vin = Column(String, index=True, nullable=True)
    client_name = Column(String, nullable=False)
    client_contact = Column(String, nullable=True)
    intake_time = Column(DateTime, default=datetime.utcnow)
    initial_inspection = Column(Text, nullable=True)
    admitted_by_id = Column(Integer, ForeignKey("users.id"))
    admitted_by = relationship("User")
