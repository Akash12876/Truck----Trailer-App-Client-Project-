from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from ..database import SessionLocal
from ..models.vehicle import Vehicle, VehicleType
from ..models.client import Client

router = APIRouter(prefix="/inventory", tags=["inventory"])

async def get_db():
    async with SessionLocal() as session:
        yield session

@router.post("/intake")
async def vehicle_intake(
    type: VehicleType,
    registration_number: str = None,
    chassis_number: str = None,
    serial_number: str = None,
    vin: str = None,
    client_name: str = None,
    client_contact: str = None,
    client_email: str = None,
    initial_inspection: str = None,
    db: AsyncSession = Depends(get_db)
):
    # Find or create client
    client = None
    if client_name:
        result = await db.execute(select(Client).where(Client.name == client_name))
        client = result.scalar_one_or_none()
        if not client:
            client = Client(name=client_name, contact=client_contact, email=client_email)
            db.add(client)
            await db.commit()
            await db.refresh(client)
    vehicle = Vehicle(
        type=type,
        registration_number=registration_number,
        chassis_number=chassis_number,
        serial_number=serial_number,
        vin=vin,
        client_id=client.id if client else None,
        initial_inspection=initial_inspection
    )
    db.add(vehicle)
    await db.commit()
    await db.refresh(vehicle)
    return {"msg": "Vehicle intake recorded", "vehicle_id": vehicle.id}
