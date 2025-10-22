from pydantic import BaseModel
from datetime import datetime

class FlightBase(BaseModel):
    airline_id: int
    flight_number: str
    origin_airport: str
    destination_airport: str
    departure_time: datetime
    arrival_time: datetime
    aircraft_id: int
    status: str
    distance_km: float | None = None

class FlightCreate(FlightBase):
    pass

class FlightResponse(FlightBase):
    flight_id: int

    class Config:
        from_attributes = True