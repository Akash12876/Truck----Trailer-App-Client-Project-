from datetime import datetime

from pydantic import BaseModel


class VehicleActionRequest(BaseModel):
    vehicle_id: int
    job_id: int
    action: str
    performed_by_id: int


class VehicleHistoryResponse(BaseModel):
    id: int
    vehicle_id: int
    job_id: int
    action: str
    performed_by_id: int
    timestamp: datetime

    class Config:
        from_attributes = True
