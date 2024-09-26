import React from 'react';
import Svg, { Path, type SvgProps } from 'react-native-svg';

const BigWarningIcon: React.FC = (props: SvgProps) => (
  <Svg
    width={81}
    height={80}
    viewBox="0 0 81 80"
    fill="none"
    // @ts-ignore
    xmlns="http://www.w3.org/2000/svg"
    {...props}
  >
    <Path
      d="M40.5 29.9999V43.3333M67.31 69.9999H13.69C8.5633 69.9999 5.35663 64.4533 7.90996 60.0099L34.72 13.3833C37.2866 8.9266 43.7166 8.9266 46.28 13.3833L73.09 60.0099C75.6433 64.4533 72.4333 69.9999 67.31 69.9999Z"
      stroke="#DB7742"
      strokeWidth={3}
      strokeLinecap="round"
    />
    <Path
      d="M40.5 56.7L40.5333 56.6633"
      stroke="#DB7742"
      strokeWidth={3}
      strokeLinecap="round"
      strokeLinejoin="round"
    />
  </Svg>
);
export default BigWarningIcon;
