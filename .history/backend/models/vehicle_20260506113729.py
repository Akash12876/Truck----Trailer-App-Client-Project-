from sqlalchemy import Column, Integer, String, Enum, ForeignKey, DateTime, Text
from sqlalchemy.orm import relationship
from ..database import Base
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
    client_id = Column(Integer, ForeignKey("clients.id"))
    intake_time = Column(DateTime, default=datetime.utcnow)
    initial_inspection = Column(Text, nullable=True)
    client = relationship("Client", back_populates="vehicles")
