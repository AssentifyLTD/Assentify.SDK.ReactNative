import React from 'react';
import { requireNativeComponent } from 'react-native';
import type { StyleProp, ViewStyle } from 'react-native';
import type { BaseDataModel, MotionType, ZoomType } from '../../types';

const PassportScannerModule = requireNativeComponent('RNPassportScanner');

type Props = {
  onError?: (resp: BaseDataModel) => void;
  onSend?: () => void;
  onRetry?: (resp: BaseDataModel) => void;
  onClipPreparationComplete?: (resp: BaseDataModel) => void;
  onStatusUpdated?: (resp: BaseDataModel) => void;
  onUpdated?: (resp: BaseDataModel) => void;
  onLivenessUpdate?: (resp: BaseDataModel) => void;
  onComplete?: (resp: BaseDataModel) => void;
  onCardDetected?: (resp: BaseDataModel) => void;
  onMrzExtracted?: (resp: BaseDataModel) => void;
  onMrzDetected?: (resp: BaseDataModel) => void;
  onNoMrzDetected?: (resp: BaseDataModel) => void;
  onFaceDetected?: (resp: BaseDataModel) => void;
  onNoFaceDetected?: (resp: BaseDataModel) => void;
  onFaceExtracted?: (resp: BaseDataModel) => void;
  onQualityCheckAvailable?: (resp: BaseDataModel) => void;
  onDocumentCaptured?: (resp: BaseDataModel) => void;
  onDocumentCropped?: (resp: BaseDataModel) => void;
  onUploadFailed?: (resp: BaseDataModel) => void;
  onEnvironmentalConditionsChange?: (
    brightness: number,
    motion: MotionType,
    zoom?: ZoomType
  ) => void;
  style?: StyleProp<ViewStyle>;
};

const PassportScanner: React.FC<Props> = (props) => {
  return <PassportScannerModule {...props} />;
};

// module.exports = requireNativeComponent('RNIOSProgressBar');
export default PassportScanner;
