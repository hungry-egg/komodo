export const coordFromClick = ({
  clientX,
  clientY,
  target,
}: {
  clientX: number;
  clientY: number;
  target: EventTarget;
}) => {
  const {
    left: elX,
    bottom: elY,
    width,
    height,
  } = (target as HTMLElement).getBoundingClientRect();
  return [
    Math.round(((clientX - elX) / width) * 100),
    -Math.round(((clientY - elY) / height) * 100),
  ];
};
