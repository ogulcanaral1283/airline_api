import React, { useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import "./SeatSelection.css";

export default function SeatSelection() {
  const { flightNumber } = useParams();
  const navigate = useNavigate();
  const [selectedSeat, setSelectedSeat] = useState(null);

  const rows = 30;
  const cols = ["A", "B", "C", "D", "E", "F"];
  const bookedSeats = ["2B", "3E", "10A", "14C", "17D", "19F"];

  const handleSelectSeat = (seat) => {
    if (bookedSeats.includes(seat)) return;
    setSelectedSeat(seat === selectedSeat ? null : seat);
  };

  const handleConfirm = () => {
    // 👇 Koltuk bilgisini query param olarak gönderiyoruz
    navigate(`/flights/${flightNumber}/passenger?seat=${selectedSeat}`);
  };

  return (
    <div className="seat-selection">
      <h2>🪑 Uçuş {flightNumber} Koltuk Seçimi</h2>

      <div className="seatmap-container">
        {Array.from({ length: 30 }).map((_, rowIndex) => (
          <div key={rowIndex} className="row">
            {cols.map((col) => {
              const seatId = `${rowIndex + 1}${col}`;
              const isBooked = bookedSeats.includes(seatId);
              const isSelected = selectedSeat === seatId;
              const addAisle = col === "C" ? <div className="aisle-space" /> : null;

              return (
                <React.Fragment key={seatId}>
                  <button
                    className={`seat ${isBooked ? "booked" : ""} ${isSelected ? "selected" : ""}`}
                    onClick={() => handleSelectSeat(seatId)}
                    disabled={isBooked}
                  >
                    {seatId}
                  </button>
                  {addAisle}
                </React.Fragment>
              );
            })}
          </div>
        ))}
      </div>

      <div className="actions">
        <p>
          Seçilen Koltuk:{" "}
          <strong>{selectedSeat ? selectedSeat : "Henüz seçilmedi"}</strong>
        </p>
        <button
          className="confirm-btn"
          onClick={handleConfirm}
          disabled={!selectedSeat}
        >
          Devam Et →
        </button>
      </div>
    </div>
  );
}
