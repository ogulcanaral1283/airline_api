import React from "react";
import { useNavigate, useParams } from "react-router-dom";
import { useEffect, useState } from "react";
import "./FlightDetail.css";


export default function FlightDetail() {
  const { flightNumber } = useParams();
  const navigate = useNavigate();
  const [flight, setFlight] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    async function fetchFlight() {
      try {
        const res = await fetch(`http://127.0.0.1:8000/flights/${flightNumber}`);
        if (!res.ok) throw new Error("Uçuş bulunamadı");
        const data = await res.json();
        setFlight(data);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    }
    fetchFlight();
  }, [flightNumber]);

  if (loading) return <p className="text-center mt-10 text-gray-600">Yükleniyor...</p>;
  if (error) return <p className="text-center mt-10 text-red-500">Hata: {error}</p>;
  if (!flight) return <p className="text-center mt-10">Uçuş bulunamadı.</p>;

  const formatDate = (d) => new Date(d).toLocaleString("tr-TR", { dateStyle: "short", timeStyle: "medium" });

  return (
    <div className="flex flex-col items-center mt-10">
      <div className="bg-gradient-to-b from-blue-50 to-white shadow-xl rounded-2xl p-6 w-[420px] border border-gray-200 relative overflow-hidden">
        {/* Arka plan ikonu */}
        <div className="absolute right-4 top-4 text-blue-100 text-6xl">✈️</div>

        <h2 className="text-2xl font-bold text-blue-700 mb-5 text-center flex items-center justify-center gap-2">
          <span>✈️</span> Uçuş Detayları
        </h2>

        <div className="text-gray-800 space-y-3 text-center">
          <p><strong>Uçuş Kodu:</strong> {flight.flight_number}</p>
          <p><strong>Kalkış:</strong> {flight.origin_airport}</p>
          <p><strong>Varış:</strong> {flight.destination_airport}</p>

          <div className="border-t border-gray-200 my-3"></div>

          <p><strong>Kalkış Saati:</strong> {formatDate(flight.departure_time)}</p>
          <p><strong>Varış Saati:</strong> {formatDate(flight.arrival_time)}</p>

          <div className="flex justify-center gap-2 mt-4">
            <button
              onClick={() => navigate("/flights")}
              className="bg-gray-400 hover:bg-gray-500 text-white px-4 py-2 rounded transition"
            >
              ← Uçuşlara Geri Dön
            </button>
            <button
              onClick={() => navigate(`/flights/${flightNumber}/seats`)}
              className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded transition"
            >
              Devam →
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}