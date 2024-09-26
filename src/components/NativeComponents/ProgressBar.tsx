import React from 'react';
import { requireNativeComponent, Platform } from 'react-native';

const RNIOSProgressBar = requireNativeComponent('RNIOSProgressBar');
const AndroidProgressBarModule = requireNativeComponent(
  'AndroidProgressBarModule'
);

type Props = {
  progress: number;
  max: number;
  progressTintColor: string;
  trackTintColor: string;
};

const NativeProgressBar: React.FC<Props> = (props) => {
  return Platform.OS === 'ios' ? (
    <RNIOSProgressBar {...props} />
  ) : (
    <AndroidProgressBarModule {...props} />
  );
};

module.exports = NativeProgressBar;
