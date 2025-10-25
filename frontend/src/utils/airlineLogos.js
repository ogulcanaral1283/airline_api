import TK from "../assets/logos/TK.png";
import PC from "../assets/logos/PC.png";
import BA from "../assets/logos/BA.png";
import QR from "../assets/logos/QR.png";
import LH from "../assets/logos/LH.png";
import EK from "../assets/logos/EK.png";
import DEFAULT from "../assets/logos/default.png";

export function getAirlineLogo(flightCode) {
  if (!flightCode) return DEFAULT;
  const prefix = flightCode.substring(0, 2).toUpperCase();

  switch (prefix) {
    case "TK":
      return TK;
    case "EK":
      return EK;
    case "LH":
      return LH;
    case "BA":
      return BA;
    case "PC":
      return PC;
    case "QR":
      return QR;    
    default:
      return DEFAULT;
  }
}