from sqlalchemy import Column, Integer, ForeignKey
from app.database import Base

class FlightCrew(Base):
    __tablename__ = "flight_crews"

    id = Column(Integer, primary_key=True)
    flight_id = Column(Integer, ForeignKey("flights.flight_id"))
    attendant_id = Column(Integer, ForeignKey("cabin_crews.attendant_id"))