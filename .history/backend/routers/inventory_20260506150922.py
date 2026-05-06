from datetime import datetime

from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from dependencies import get_db
from models.inventory.vehicle import Vehicle
from schemas.inventory import VehicleIntakeRequest, VehicleResponse

router = APIRouter(prefix="/inventory", tags=["inventory"])


@router.post("/intake")
async def vehicle_intake(
    payload: VehicleIntakeRequest,
    db: AsyncSession = Depends(get_db),
):
    vehicle = Vehicle(
        type=payload.type,
        registration_number=payload.registration_number,
        chassis_number=payload.chassis_number,
        serial_number=payload.serial_number,
        vin=payload.vin,
        client_name=payload.client_name,
        client_contact=payload.client_contact,
        initial_inspection=payload.initial_inspection,
        admitted_by_id=payload.admitted_by_id,
        intake_time=datetime.utcnow(),
    )
    db.add(vehicle)
    await db.commit()
    await db.refresh(vehicle)
    return {"msg": "Vehicle admitted", "vehicle_id": vehicle.id}


@router.get("/pending", response_model=list[VehicleResponse])
async def get_pending_vehicles(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Vehicle))
    return result.scalars().all()
