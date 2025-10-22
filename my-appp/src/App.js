import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Home from "./pages/Home";
import FlightSearch from "./pages/FlightSearch";

import FlightDetail from "./components/FlightDetail";
import SeatSelection from "./components/SeatSelection";
import AdminDashboard from "./pages/AdminDashboard";
import PassengerInfo from "./components/PassengerInfo";

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />               {/* 🏠 Karşılama sayfası */}
        <Route path="/flights" element={<FlightSearch />} /> {/* ✈️ Uçuş arama sayfası */}
        <Route path="/flight/:flightNumber" element={<FlightDetail />} /> {/* ✈️ yeni rota */}
        <Route path="/flights/:flightNumber/seats" element={<SeatSelection />} />
        <Route path="/flights/:flightNumber/passenger" element={<PassengerInfo />} />
        <Route path="/admin/*" element={<AdminDashboard />} /> {/* 🧑‍✈️ Admin paneli */}
      </Routes>
    </Router>
  );
}

export default App;