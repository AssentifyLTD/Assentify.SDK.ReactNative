import { Dimensions, PixelRatio, Platform } from 'react-native';

const { width: SCREEN_WIDTH, height: SCREEN_HEIGHT } = Dimensions.get('window');
// const ratio = PixelRatio.get();

// Use iPhone5 as base size which is 320 x 568
// const baseWidth = 320;
// const baseHeight = 568;

// Use iPhone6 as base size which is 375 x 667
const baseWidth = 375;
const baseHeight = 667;

// const baseWidth = 375;
// const baseHeight = 811;

const scaleWidth = SCREEN_WIDTH / baseWidth;
const scaleHeight = SCREEN_HEIGHT / baseHeight;
const scale = Math.min(scaleWidth, scaleHeight);

export const normalize = (
  size: number,
  based: 'width' | 'height' = 'width'
) => {
  // const newSize = size * scale;
  const newSize = based === 'height' ? size * scale : size * scale;
  if (Platform.OS === 'ios') {
    return Math.round(PixelRatio.roundToNearestPixel(newSize));
  } else {
    return Math.round(PixelRatio.roundToNearestPixel(newSize)) - 2;
  }
};

//for width  pixel
export const widthPixel = (size: number) => {
  return normalize(size, 'width');
};
//for height  pixel
export const heightPixel = (size: number) => {
  return normalize(size, 'height');
};
//for font  pixel
export const fontPixel = (size: number) => {
  return heightPixel(size);
};
//for Margin and Padding vertical pixel
export const pixelSizeVertical = (size: number) => {
  return heightPixel(size);
};
//for Margin and Padding horizontal pixel
export const pixelSizeHorizontal = (size: number) => {
  return widthPixel(size);
};
