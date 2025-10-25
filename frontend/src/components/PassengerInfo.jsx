import React, { useState } from "react";
import { useNavigate, useParams, useSearchParams } from "react-router-dom";
import "./PassengerInfo.css";


const API_URL = process.env.REACT_APP_API_URL;


export default function PassengerInfo() {
  const { flightNumber } = useParams();
  const [searchParams] = useSearchParams();
  const selectedSeat = searchParams.get("seat");
  const navigate = useNavigate();

  const [form, setForm] = useState({
    name: "",
    age: "",
    gender: "",
    nationality: "",
  });

  const [success, setSuccess] = useState(false); // ✅ başarı durumu
  const [loading, setLoading] = useState(false);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm({ ...form, [name]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    const payload = {
      flight_number: flightNumber,
      full_name: form.name,
      age: parseInt(form.age),
      gender: form.gender,
      nationality: form.nationality,
      seat_type: "Economy",
      seat_number: selectedSeat,
    };

    try {
      const res = await fetch(`${API_URL}/passengers/`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });

      if (res.ok) {
        setSuccess(true); // ✅ bilet başarıyla alındı
      } else {
        const err = await res.json();
        alert("Bir hata oluştu: " + err.detail);
      }
    } catch (error) {
      alert("Sunucuya ulaşılamadı: " + error.message);
    } finally {
      setLoading(false);
    }
  };

  // ✅ Eğer bilet başarıyla alındıysa mesaj ve ana sayfaya dön butonu
  if (success) {
    return (
      <div className="success-container">
        <h2>🎉 Biletiniz başarıyla alındı!</h2>
        <p>
          <strong>{form.name}</strong> adlı yolcu için {flightNumber} uçuşunda{" "}
          koltuk <strong>{selectedSeat}</strong> rezerve edilmiştir.
        </p>
        <button className="home-btn" onClick={() => navigate("/flights")}>
          🏠 Ana Sayfaya Dön
        </button>
      </div>
    );
  }

  return (
    <div className="passenger-form">
      <h2>✈️ Yolcu Bilgileri</h2>
      <p>
        Uçuş: <strong>{flightNumber}</strong> | Koltuk:{" "}
        <strong>{selectedSeat}</strong>
      </p>

      <form onSubmit={handleSubmit}>
        <label>
          Ad Soyad:
          <input
            type="text"
            name="name"
            value={form.name}
            onChange={handleChange}
            required
          />
        </label>

        <label>
          Yaş:
          <input
            type="number"
            name="age"
            min="1"
            value={form.age}
            onChange={handleChange}
            required
          />
        </label>

        <label>
          Cinsiyet:
          <select
            name="gender"
            value={form.gender}
            onChange={handleChange}
            required
          >
            <option value="">Seçiniz</option>
            <option value="Male">Erkek</option>
            <option value="Female">Kadın</option>
          </select>
        </label>

        <label>
          Uyruk:
          <input
            type="text"
            name="nationality"
            value={form.nationality}
            onChange={handleChange}
            required
          />
        </label>

        <button type="submit" className="submit-btn" disabled={loading}>
          {loading ? "Kaydediliyor..." : "Kaydet"}
        </button>
      </form>
    </div>
  );
}
