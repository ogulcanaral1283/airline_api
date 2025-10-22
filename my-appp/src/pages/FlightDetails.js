import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import "./FlightDetails.css";

export default function FlightDetails() {
  const { flightNumber } = useParams();
  const navigate = useNavigate();
  const [flight, setFlight] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // API'den tek uçuşu getir
    fetch(`http://localhost:8000/flights/${flightNumber}`)
      .then((res) => res.json())
      .then((data) => {
        setFlight(data);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, [flightNumber]);

  if (loading) {
    return <p className="loading">Uçuş bilgileri yükleniyor...</p>;
  }

  if (!flight) {
    return (
      <div className="flight-details-page">
        <p>Uçuş bulunamadı.</p>
        <button onClick={() => navigate("/flights")}>← Geri Dön</button>
      </div>
    );
  }

  return (
    <div className="flight-details-page">
      <h2>✈️ Uçuş Detayları</h2>

      <div className="details-card">
        <div className="info">
          <strong>Uçuş Kodu:</strong> {flight.flight_number}
        </div>
        <div className="info">
          <strong>Kalkış:</strong> {flight.origin_airport}
        </div>
        <div className="info">
          <strong>Varış:</strong> {flight.destination_airport}
        </div>
        <div className="info">
          <strong>Kalkış Saati:</strong>{" "}
          {new Date(flight.departure_time).toLocaleString("tr-TR")}
        </div>
        <div className="info">
          <strong>Varış Saati:</strong>{" "}
          {new Date(flight.arrival_time).toLocaleString("tr-TR")}
        </div>

        {flight.price && (
          <div className="info">
            <strong>Fiyat:</strong> {flight.price.toLocaleString("tr-TR")} TRY
          </div>
        )}

        <button className="back-btn" onClick={() => navigate("/flights")}>
          ← Uçuşlara Geri Dön
        </button>
      </div>
    </div>
  );
}
