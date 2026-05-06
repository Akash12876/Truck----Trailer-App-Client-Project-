from datetime import datetime

from pydantic import BaseModel


class CompanyAnalyticsResponse(BaseModel):
    id: int
    total_revenue: float
    avg_repair_time: float
    branch_count: int
    updated_at: datetime

    class Config:
        from_attributes = True
