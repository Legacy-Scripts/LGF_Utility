import { useMap } from "react-leaflet";
import L from "leaflet";

// THX TO https://github.com/BubbleDK/bub-mdt

const Map = () => {
  const map = useMap();

  const Layer = L.tileLayer(
    `https://s.rsg.sc/sc/images/games/GTAV/map/game/{z}/{x}/{y}.jpg`,
    {
      maxZoom: 7,
      minZoom: 2,
      bounds: L.latLngBounds(L.latLng(0.0, 125.0), L.latLng(-180.0, 0.0)),
    }
  );

  const bounds = L.latLngBounds(L.latLng(0.0, 125.0), L.latLng(-180.0, 0.0));

  map.setMaxBounds(bounds);

  map.attributionControl.setPrefix(false);
  map.setView([0, 0], 2);

  map.addLayer(Layer);

  return null;
};

export default Map;
