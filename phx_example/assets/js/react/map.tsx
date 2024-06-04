import React, { CSSProperties, MouseEventHandler, useRef } from "react";
import { coordFromClick } from "../helpers/coordFromClick";

const Logo = () => (
  <svg
    width="100%"
    height="100%"
    viewBox="-10.5 -9.45 21 18.9"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
    color="rgb(26, 114, 151)"
  >
    <circle cx="0" cy="0" r="2" fill="currentColor"></circle>
    <g stroke="currentColor" strokeWidth="1" fill="none">
      <ellipse rx="10" ry="4.5"></ellipse>
      <ellipse rx="10" ry="4.5" transform="rotate(60)"></ellipse>
      <ellipse rx="10" ry="4.5" transform="rotate(120)"></ellipse>
    </g>
  </svg>
);

const markerStyle = (x: number, y: number) => ({
  width: "32px",
  height: "32px",
  marginLeft: "-16px",
  marginTop: "-16px",
  position: "absolute" as CSSProperties["position"],
  left: `${x}%`,
  top: `calc(100% - ${y}%)`,
});

type Props = {
  marker: [number, number];
  onSelectCoord: (coord: { x: number; y: number }) => void;
};

const Map = ({ marker: [x, y], onSelectCoord }: Props) => {
  const handleClick: MouseEventHandler<HTMLElement> = (event) => {
    const [x, y] = coordFromClick(event);
    onSelectCoord({ x, y });
  };

  return (
    <div
      style={{
        width: "200px",
        height: "200px",
        border: "solid 1px slategrey",
        position: "relative",
        borderRadius: 4,
      }}
      onClick={handleClick}
    >
      <div style={markerStyle(x, y)}>
        <Logo />
      </div>
    </div>
  );
};

export default Map;
