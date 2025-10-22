from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

# .env dosyasındaki değişkenleri yükle (örn. DB_USER, DB_PASS vs.)
load_dotenv()

# 🔐 PostgreSQL bağlantı URL'si
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:123@localhost:5432/airline_db"
)

# 🧱 Engine oluştur
engine = create_engine(DATABASE_URL)

# 🧩 Session yapılandırması
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# 🧬 Base sınıfı (model mirası için)
Base = declarative_base()

# 💡 FastAPI dependency (her request için yeni bir session)
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
