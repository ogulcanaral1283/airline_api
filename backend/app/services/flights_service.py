from sqlalchemy.orm import Session
from app.models.flights import Flight
from app.schemas.flight_schemas import FlightCreate

def get_all_flights(db: Session):
    return db.query(Flight).all()

def get_flight_by_id(flight_id: int, db: Session):
    return db.query(Flight).filter(Flight.flight_id == flight_id).first()

def get_flight_by_number(flight_number: str, db: Session):
    flight = db.query(Flight).filter(Flight.flight_number == flight_number).first()
    return flight

def create_flight(flight_data: FlightCreate, db: Session):
    new_flight = Flight(**flight_data.dict())
    db.add(new_flight)
    db.commit()
    db.refresh(new_flight)
    return new_flight

def update_flight(flight_id: int, flight_data: FlightCreate, db: Session):
    flight = get_flight_by_id(flight_id, db)
    if not flight:
        return None
    for key, value in flight_data.dict().items():
        setattr(flight, key, value)
    db.commit()
    db.refresh(flight)
    return flight

def delete_flight(flight_id: int, db: Session):
    flight = get_flight_by_id(flight_id, db)
    if not flight:
        return None
    db.delete(flight)
    db.commit()
    return True