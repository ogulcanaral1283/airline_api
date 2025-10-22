from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.schemas.flight_schemas import FlightCreate, FlightResponse
from app.services import flights_service

router = APIRouter(prefix="/flights", tags=["Flights"])

@router.get("/", response_model=list[FlightResponse])
def get_all_flights(db: Session = Depends(get_db)):
    return flights_service.get_all_flights(db)

@router.get("/id/{flight_id}", response_model=FlightResponse)
def get_flight(flight_id: int, db: Session = Depends(get_db)):
    flight = flights_service.get_flight_by_id(flight_id, db)
    if not flight:
        raise HTTPException(status_code=404, detail="Flight not found")
    return flight

@router.get("/{flight_number}")
def get_flight(flight_number: str, db: Session = Depends(get_db)):
    flight = flights_service.get_flight_by_number(flight_number, db)
    if not flight:
        raise HTTPException(status_code=404, detail="Flight not found")
    return flight

@router.post("/", response_model=FlightResponse)
def create_flight(flight: FlightCreate, db: Session = Depends(get_db)):
    return flights_service.create_flight(flight, db)

@router.put("/{flight_id}", response_model=FlightResponse)
def update_flight(flight_id: int, flight_data: FlightCreate, db: Session = Depends(get_db)):
    flight = flights_service.update_flight(flight_id, flight_data, db)
    if not flight:
        raise HTTPException(status_code=404, detail="Flight not found")
    return flight

@router.delete("/{flight_id}")
def delete_flight(flight_id: int, db: Session = Depends(get_db)):
    result = flights_service.delete_flight(flight_id, db)
    if not result:
        raise HTTPException(status_code=404, detail="Flight not found")
    return {"detail": "Flight deleted successfully"}