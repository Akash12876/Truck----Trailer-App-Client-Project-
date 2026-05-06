from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from ..database import Base

class Client(Base):
    __tablename__ = "clients"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    contact = Column(String, nullable=True)
    email = Column(String, nullable=True)
    vehicles = relationship("Vehicle", back_populates="client")
