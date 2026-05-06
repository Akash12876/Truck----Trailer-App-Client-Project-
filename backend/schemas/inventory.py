from datetime import datetime

from pydantic import BaseModel

from ..models.inventory.vehicle import VehicleType


class VehicleIntakeRequest(BaseModel):
    type: VehicleType
    registration_number: str | None = None
    chassis_number: str | None = None
    serial_number: str | None = None
    vin: str | None = None
    client_name: str
    client_contact: str | None = None
    initial_inspection: str | None = None
    admitted_by_id: int | None = None


class VehicleResponse(BaseModel):
    id: int
    type: VehicleType
    registration_number: str | None = None
    chassis_number: str | None = None
    serial_number: str | None = None
    vin: str | None = None
    client_name: str
    client_contact: str | None = None
    intake_time: datetime
    initial_inspection: str | None = None
    admitted_by_id: int | None = None

    class Config:
        from_attributes = True
