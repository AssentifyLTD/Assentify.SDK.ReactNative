import React from 'react';
import Svg, { Path, type SvgProps } from 'react-native-svg';

const CloseIcon: React.FC = (props: SvgProps) => (
  <Svg
    width={24}
    height={24}
    viewBox="0 0 24 24"
    fill="none"
    // @ts-ignore
    xmlns="http://www.w3.org/2000/svg"
    {...props}
  >
    <Path
      fillRule="evenodd"
      clipRule="evenodd"
      d="M6.22772 6.22662C6.52064 5.93376 6.99551 5.9338 7.28838 6.22672L12.0001 10.9393L16.7137 6.22662C17.0066 5.93376 17.4815 5.9338 17.7744 6.22672C18.0672 6.51965 18.0672 6.99452 17.7743 7.28738L13.0612 11.9996L17.7743 16.7127C18.0672 17.0056 18.0672 17.4804 17.7743 17.7733C17.4814 18.0662 17.0066 18.0662 16.7137 17.7733L12.001 13.0607L7.28833 17.7733C6.99543 18.0662 6.52056 18.0662 6.22767 17.7733C5.93477 17.4804 5.93477 17.0056 6.22767 16.7127L10.9399 12.0005L6.22761 7.28728C5.93475 6.99436 5.93479 6.51949 6.22772 6.22662Z"
      fill={props.color}
    />
  </Svg>
);
export default CloseIcon;
