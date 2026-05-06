from sqlalchemy import Column, Integer, Float, DateTime
from ...database import Base
from datetime import datetime

class CompanyAnalytics(Base):
    __tablename__ = "company_analytics"

    id = Column(Integer, primary_key=True, index=True)
    total_revenue = Column(Float, default=0.0)
    avg_repair_time = Column(Float, default=0.0)
    branch_count = Column(Integer, default=1)
    updated_at = Column(DateTime, default=datetime.utcnow)
