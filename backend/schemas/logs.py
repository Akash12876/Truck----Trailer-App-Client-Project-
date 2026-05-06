from datetime import datetime

from pydantic import BaseModel


class SystemLogResponse(BaseModel):
    id: int
    action: str
    user_id: int | None = None
    details: str | None = None
    timestamp: datetime

    class Config:
        from_attributes = True
