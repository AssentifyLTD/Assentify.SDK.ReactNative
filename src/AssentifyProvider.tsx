import {
  NativeModules,
  NativeEventEmitter,
  DeviceEventEmitter,
  LogBox,
} from 'react-native';
import React, {
  createContext,
  useCallback,
  useEffect,
  useMemo,
  useRef,
} from 'react';
import {
  type PassportExtractedModel,
  type FaceExtractedModel,
  type IDExtractedModel,
  type OtherExtractedModel,
  FAILED_RESULT,
  type IdentificationDocumentCapture,
} from './types';
import JsonParserPassport from './helpers/parsers/PassportParser';
import useGlobalStore from './useGlobalStore';
import './navigator';
import NavigationContainer from './navigator';
import { useSub } from './helpers/usePubSub';
import {
  onCardDetectedCallback,
  onClipPreparationCompleteCallback,
  onCompleteCallback,
  onDocumentCapturedCallback,
  onDocumentCroppedCallback,
  onEnvironmentalConditionsChangeCallback,
  onErrorCallback,
  onFaceDetectedCallback,
  onFaceExtractedCallback,
  onLivenessUpdateCallback,
  onMrzDetectedCallback,
  onMrzExtractedCallback,
  onNoFaceDetectedCallback,
  onNoMrzDetectedCallback,
  onQualityCheckAvailableCallback,
  onRetryCallback,
  onStatusUpdatedCallback,
  onUpdatedCallback,
  onUploadFailedCallback,
} from './helpers/callbacks';
import {
  BottomSheetModal,
  BottomSheetModalProvider,
} from '@gorhom/bottom-sheet';
import JsonParserFaceMatch from './helpers/parsers/FaceMatchParser';
import JsonParserIdCard from './helpers/parsers/IDCardParser';
import JsonParserOtherID from './helpers/parsers/OtherIDParser';
import { onWrongTemplateCallback } from './helpers/callbacks/onWrongTemplate';
import { DOC_TYPE, PAGES } from './helpers/constants';
import NavigationService from './helpers/NavigationService';

const { NativeAssentifySdk } = NativeModules;

const AssentifyContext = createContext<undefined>(undefined);

LogBox.ignoreAllLogs();
const AssentifyProvider = () => {
  const {
    docType,
    isPassportScanComplete,
    isIDScanComplete,
    isOtherIDScanComplete,
    isFaceScanComplete,
    setIsPassportScanComplete,
    setIsIDScanComplete,
    setIsOtherIDScanComplete,
    setIsFaceScanComplete,
    setScannedData,
    setIDScannedData,
    setOtherIDScannedData,
    setFaceMatchData,
    setCountryCode,
    setDocType,
    setIsSubmittingData,
    setIsSubmittedData,
    setIsSubmittedSuccess,
  } = useGlobalStore();
  const bottomSheetModalRef = useRef<BottomSheetModal>(null);

  const onNavigateFailed = (reason: number) => {
    setTimeout(() => {
      NavigationService.navigate(PAGES.SCAN_FAILED, {
        reason,
      });
    }, 600);
  };

  const identificationChecking = useCallback(
    (identity: IdentificationDocumentCapture) => {
      if (identity?.isExpired) {
        onNavigateFailed(FAILED_RESULT.EXPIRED_DOCUMENT);
        return false;
      }

      if (identity?.isTampering) {
        onNavigateFailed(FAILED_RESULT.TAMPERED_DOCUMENT);
        return false;
      }

      if (identity?.isFailedFront) {
        onNavigateFailed(FAILED_RESULT.FAILED_FRONT_ID);
        return false;
      }

      if (identity?.isFailedBack) {
        onNavigateFailed(FAILED_RESULT.FAILED_BACK_ID);
        return false;
      }

      if (identity?.isBackTampering) {
        onNavigateFailed(FAILED_RESULT.TAMPERED_BACK_DOCUMENT);
        return false;
      }

      return true;
    },
    []
  );

  const onPassportScanComplete = useCallback(
    (data: PassportExtractedModel) => {
      if (data) {
        const identity = data?.identificationDocumentCapture;
        const willProceed = identificationChecking(identity!);
        if (!willProceed) {
          setIsPassportScanComplete(false);
          return;
        }

        setIsPassportScanComplete(true);
        setScannedData(data);
      }
    },
    [identificationChecking, setIsPassportScanComplete, setScannedData]
  );

  const onFaceScanComplete = useCallback(
    (data: FaceExtractedModel) => {
      if (data) {
        setIsFaceScanComplete(true);
        setFaceMatchData(data);
        const params = {
        };
       NativeAssentifySdk.submitData(params);
      }
    },
    [setIsFaceScanComplete, setFaceMatchData]
  );

  const onIDScanComplete = useCallback(
    (data: IDExtractedModel) => {
      console.log('onIDScanComplete: ', data);
      if (data) {
        const identity = data?.identificationDocumentCapture;
        const willProceed = identificationChecking(identity!);
        console.log('onIDScanComplete willProceed: ', willProceed);
        if (!willProceed) {
          setIsIDScanComplete(false);
          return;
        }

        setIsIDScanComplete(true);
        setIDScannedData(data);
      }
    },
    [identificationChecking, setIDScannedData, setIsIDScanComplete]
  );

  const onOtherIDScanComplete = useCallback(
    (data: OtherExtractedModel) => {
      if (data) {
        const identity = data?.identificationDocumentCapture;
        const willProceed = identificationChecking(identity!);
        if (!willProceed) {
          setIsOtherIDScanComplete(false);
          return;
        }

        setIsOtherIDScanComplete(true);
        setOtherIDScannedData(data);
      }
    },
    [identificationChecking, setIsOtherIDScanComplete, setOtherIDScannedData]
  );

  const onClose = () => {
    setCountryCode(null);
    setDocType(null);
    bottomSheetModalRef.current?.dismiss();
  };

  useSub('doneScanResult', () => {
    onClose();
    DeviceEventEmitter.emit('doneScanResult');
  });

  useSub('closeApp', () => {
    onClose();
    DeviceEventEmitter.emit('closeAssentifyApp');
  });

  useEffect(() => {
    const emitter = new NativeEventEmitter(NativeAssentifySdk);
    const subs = emitter.addListener('AppResult', (AppResult) => {
      if (AppResult?.assentifySdkInitStart) {
        bottomSheetModalRef.current?.present();
      }
    });

    const subs1 = emitter.addListener('EventResult', (result: any) => {
      if (result?.SubmitData) {
        const submittedData = result?.SubmitData;
        if (submittedData?.SubmitDataRequest) {
          setIsSubmittingData(true);
        } else if (submittedData?.SubmitDataResponse) {
          setIsSubmittingData(false);
          setIsSubmittedData(true);
          setIsSubmittedSuccess(!!submittedData?.success);
        }
      }
    });

    const onSend = emitter.addListener('onSend', (result) => {
      console.log('onSend result: ', result);
    });

    const onRetry = emitter.addListener('onRetry', (result) => {
      onRetryCallback(result);
    });

    const onError = emitter.addListener('onError', (result) => {
      onErrorCallback(result);
    });

    const onClipPreparationComplete = emitter.addListener(
      'onClipPreparationComplete',
      (result) => {
        onClipPreparationCompleteCallback(result);
      }
    );

    const onStatusUpdated = emitter.addListener('onStatusUpdated', (result) => {
      onStatusUpdatedCallback(result);
    });

    const onUpdated = emitter.addListener('onUpdated', (result) => {
      onUpdatedCallback(result);
    });

    const onLivenessUpdate = emitter.addListener(
      'onLivenessUpdate',
      (result) => {
        onLivenessUpdateCallback(result);
      }
    );

    const onComplete = emitter.addListener('onComplete', (result) => {
      onCompleteCallback(result);
      if (result?.PassportDataModel) {
        const response = JsonParserPassport(result?.PassportDataModel);
        onPassportScanComplete(response);
      } else if (result?.FaceMatchDataModel) {
        const response = JsonParserFaceMatch(result?.FaceMatchDataModel);
        onFaceScanComplete(response);
      } else if (result?.IdDataModel) {
        const response = JsonParserIdCard(result?.IdDataModel);
        onIDScanComplete(response);
      } else if (result?.OtherDataModel) {
        const response = JsonParserOtherID(result?.OtherDataModel);
        onOtherIDScanComplete(response);
      }
    });

    const onCardDetected = emitter.addListener('onCardDetected', (result) => {
      onCardDetectedCallback(result);
    });

    const onMrzExtracted = emitter.addListener('onMrzExtracted', (result) => {
      onMrzExtractedCallback(result);
    });

    const onMrzDetected = emitter.addListener('onMrzDetected', (result) => {
      onMrzDetectedCallback(result);
    });

    const onNoMrzDetected = emitter.addListener('onNoMrzDetected', (result) => {
      onNoMrzDetectedCallback(result);
    });

    const onFaceDetected = emitter.addListener('onFaceDetected', (result) => {
      onFaceDetectedCallback(result);
    });

    const onNoFaceDetected = emitter.addListener(
      'onNoFaceDetected',
      (result) => {
        onNoFaceDetectedCallback(result);
      }
    );

    const onFaceExtracted = emitter.addListener('onFaceExtracted', (result) => {
      onFaceExtractedCallback(result);
    });

    const onQualityCheckAvailable = emitter.addListener(
      'onQualityCheckAvailable',
      (result) => {
        onQualityCheckAvailableCallback(result);
      }
    );

    const onDocumentCaptured = emitter.addListener(
      'onDocumentCaptured',
      (result) => {
        onDocumentCapturedCallback(result);
      }
    );

    const onDocumentCropped = emitter.addListener(
      'onDocumentCropped',
      (result) => {
        onDocumentCroppedCallback(result);
      }
    );

    const onUploadFailed = emitter.addListener('onUploadFailed', (result) => {
      onUploadFailedCallback(result);
    });

    const onEnvironmentalConditionsChange = emitter.addListener(
      'onEnvironmentalConditionsChange',
      (result) => {
        onEnvironmentalConditionsChangeCallback(result);
      }
    );

    const onWrongTemplate = emitter.addListener('onWrongTemplate', (result) => {
      onWrongTemplateCallback(result);
      onNavigateFailed(FAILED_RESULT.WRONG_TEMPLATE);
    });

    return () => {
      subs.remove();
      subs1.remove();

      onSend.remove();
      onRetry.remove();
      onError.remove();
      onClipPreparationComplete.remove();
      onStatusUpdated.remove();
      onUpdated.remove();
      onLivenessUpdate.remove();
      onComplete.remove();
      onCardDetected.remove();
      onMrzExtracted.remove();
      onMrzDetected.remove();
      onNoMrzDetected.remove();
      onFaceDetected.remove();
      onNoFaceDetected.remove();
      onFaceExtracted.remove();
      onQualityCheckAvailable.remove();
      onDocumentCaptured.remove();
      onDocumentCropped.remove();
      onUploadFailed.remove();
      onEnvironmentalConditionsChange.remove();
      onWrongTemplate.remove();
    };
  }, [
    onPassportScanComplete,
    onFaceScanComplete,
    onIDScanComplete,
    onOtherIDScanComplete,
    setIsSubmittedData,
    setIsSubmittedSuccess,
    setIsSubmittingData,
  ]);

  useEffect(() => {
    console.log('docType: ', docType);
    if (docType === DOC_TYPE.PASSPORT) {
      console.log('isPassportScanComplete: ', isPassportScanComplete);
      console.log('isFaceScanComplete: ', isFaceScanComplete);
      if (isPassportScanComplete && isFaceScanComplete) {
        NavigationService.navigate(PAGES.SCAN_RESULT);
      }
    } else if (docType === DOC_TYPE.CIVIL_ID) {
      console.log('isIDScanComplete: ', isIDScanComplete);
      console.log('isFaceScanComplete: ', isFaceScanComplete);
      if (isIDScanComplete && isFaceScanComplete) {
        NavigationService.navigate(PAGES.SCAN_RESULT);
      }
    } else if (docType === DOC_TYPE.OTHER) {
      console.log('isOtherIDScanComplete: ', isOtherIDScanComplete);
      console.log('isFaceScanComplete: ', isFaceScanComplete);
      if (isOtherIDScanComplete && isFaceScanComplete) {
        NavigationService.navigate(PAGES.SCAN_RESULT);
      }
    }
  }, [
    isPassportScanComplete,
    isFaceScanComplete,
    docType,
    isIDScanComplete,
    isOtherIDScanComplete,
  ]);

  const snapPoints = useMemo(() => ['100%'], []);

  return (
    <AssentifyContext.Provider value={undefined}>
      <BottomSheetModalProvider>
        <BottomSheetModal
          handleComponent={null}
          enablePanDownToClose={false}
          enableHandlePanningGesture={true}
          enableContentPanningGesture={false}
          ref={bottomSheetModalRef}
          index={0}
          snapPoints={snapPoints}
        >
          <NavigationContainer />
        </BottomSheetModal>
      </BottomSheetModalProvider>
    </AssentifyContext.Provider>
  );
};

export { AssentifyProvider };
