from sqlalchemy import Column, Integer, ForeignKey
from app.database import Base

class FlightPilot(Base):
    __tablename__ = "flight_pilot"

    id = Column(Integer, primary_key=True)
    flight_id = Column(Integer, ForeignKey("flights.flight_id"))
    pilot_id = Column(Integer, ForeignKey("pilots.pilot_id"))