from sqlalchemy import Column, Integer, String, ARRAY
from app.database import Base

class CabinCrew(Base):
    __tablename__ = "cabin_crews"

    attendant_id = Column(Integer, primary_key=True)
    full_name = Column(String)
    age = Column(Integer)
    gender = Column(String)
    nationality = Column(String)
    known_languages = Column(ARRAY(String))
    attendant_type = Column(String)  # chief, regular, chef
    vehicle_restrictions = Column(ARRAY(String))