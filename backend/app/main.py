from fastapi import FastAPI
from app.routers import flights_router, pilots_router, cabin_router, passenger_router
from fastapi.middleware.cors import CORSMiddleware
from app.database import Base, engine


Base.metadata.create_all(bind=engine)


app = FastAPI(title="Airline Management API")


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # geliştirme için tüm origin'lere izin
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(flights_router.router)
app.include_router(pilots_router.router)
app.include_router(cabin_router.router)
app.include_router(passenger_router.router)

@app.get("/")
def root():
    return {"message": "✈️ Airline Management API is running!"}