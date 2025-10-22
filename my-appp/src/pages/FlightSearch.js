import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom"; // 👈 buraya ekliyoruz
import "./FlightSearch.css";

export default function FlightSearch() {
  const [flights, setFlights] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate(); // 👈 burada tanımlıyoruz

  useEffect(() => {
    fetch("http://localhost:8000/flights")
      .then((res) => res.json())
      .then((data) => {
        setFlights(data);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, []);

  return (
    <div className="flight-page">
      <h2 className="page-title">✈️ Gidiş Uçuşları</h2>

      {loading ? (
        <p className="loading">Veriler yükleniyor...</p>
      ) : (
        <div className="flight-list">
          {flights.map((f, index) => (
            <div className="flight-card" key={index}>
              <div className="airline-info">
                <img
                  src="/plane-icon.png"
                  alt="airline"
                  className="airline-logo"
                />
                <div>
                  <strong>{f.flight_number}</strong>
                  <div className="flight-code">
                    {f.origin_airport} → {f.destination_airport}
                  </div>
                </div>
              </div>

              <div className="flight-details">
                <div>
                  <div className="time">
                    {new Date(f.departure_time).toLocaleTimeString("tr-TR", {
                      hour: "2-digit",
                      minute: "2-digit",
                    })}
                  </div>
                  <div className="city">{f.origin_airport}</div>
                </div>

                <div className="duration">
                  <div>2sa 45dk</div>
                  <div className="direct">Direkt</div>
                </div>

                <div>
                  <div className="time arrival">
                    {new Date(f.arrival_time).toLocaleTimeString("tr-TR", {
                      hour: "2-digit",
                      minute: "2-digit",
                    })}
                  </div>
                  <div className="city">{f.destination_airport}</div>
                </div>
              </div>

              <div className="price-section">
                <div className="price">
                  {f.price ? `${f.price.toLocaleString("tr-TR")} TRY` : "BEDAVA"}
                </div>

                {/* 👇 burada yönlendirmeyi yapıyoruz */}
                <button
                  className="select-btn"
                  onClick={() => navigate(`/flight/${f.flight_number}`)}
                >
                  SEÇ
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}