from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from ..database import SessionLocal
from ..models.user import User
from sqlalchemy import Column, Integer, String, ForeignKey, Enum
from sqlalchemy.orm import relationship
from ..database import Base

router = APIRouter(prefix="/inventory", tags=["inventory"])

class VehicleType(str, Enum):
    truck = "truck"
    trailer = "trailer"

class Vehicle(Base):
    __tablename__ = "vehicles"
    id = Column(Integer, primary_key=True, index=True)
    type = Column(Enum(VehicleType), nullable=False)
    registration_number = Column(String, index=True, nullable=True)
    chassis_number = Column(String, nullable=True)
    serial_number = Column(String, nullable=True)
    vin = Column(String, nullable=True)
    client_name = Column(String, nullable=False)
    client_contact = Column(String, nullable=True)
    initial_inspection = Column(String, nullable=True)  # Could be JSON or text

async def get_db():
    async with SessionLocal() as session:
        yield session

@router.post("/intake")
async def intake_vehicle(
    type: VehicleType,
    registration_number: str = None,
    chassis_number: str = None,
    serial_number: str = None,
    vin: str = None,
    client_name: str = None,
    client_contact: str = None,
    initial_inspection: str = None,
    db: AsyncSession = Depends(get_db)
):
    vehicle = Vehicle(
        type=type,
        registration_number=registration_number,
        chassis_number=chassis_number,
        serial_number=serial_number,
        vin=vin,
        client_name=client_name,
        client_contact=client_contact,
        initial_inspection=initial_inspection
    )
    db.add(vehicle)
    await db.commit()
    await db.refresh(vehicle)
    return {"msg": "Vehicle intake recorded", "vehicle_id": vehicle.id}
