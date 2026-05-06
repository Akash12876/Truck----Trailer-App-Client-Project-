from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from ..database import SessionLocal
from ..models.inventory.vehicle import Vehicle, VehicleType
from ..models.user import User
from typing import Optional
from datetime import datetime

router = APIRouter(prefix="/inventory", tags=["inventory"])

async def get_db():
    async with SessionLocal() as session:
        yield session

@router.post("/intake")
async def vehicle_intake(
    type: VehicleType,
    registration_number: Optional[str] = None,
    chassis_number: Optional[str] = None,
    serial_number: Optional[str] = None,
    vin: Optional[str] = None,
    client_name: str = None,
    client_contact: Optional[str] = None,
    initial_inspection: Optional[str] = None,
    admitted_by_id: int = None,
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
        initial_inspection=initial_inspection,
        admitted_by_id=admitted_by_id,
        intake_time=datetime.utcnow()
    )
    db.add(vehicle)
    await db.commit()
    await db.refresh(vehicle)
    return {"msg": "Vehicle admitted", "vehicle_id": vehicle.id}

@router.get("/pending")
async def get_pending_vehicles(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Vehicle))
    vehicles = result.scalars().all()
    return vehicles
