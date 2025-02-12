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
import { merge } from 'lodash';
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



  useEffect(() => {
    const emitter = new NativeEventEmitter(NativeAssentifySdk);

    /// Initialize
    const assentifySdkInit = emitter.addListener('AppResult', (result) => {
    if(result?.assentifySdkInitSuccess!=null){
      if (result?.assentifySdkInitSuccess) {
            const templates = JSON.parse(result?.AssentifySdkHasTemplates ) as TemplatesByCountry[];
             DeviceEventEmitter.emit('assentifySdkInit',{"status":true,"templates":templates});
          }else{
             DeviceEventEmitter.emit('assentifySdkInit',{"status":false});
          }
    }
   });

    /// onComplete
    const onComplete = emitter.addListener('onComplete', (result) => {
      if (result?.PassportDataModel) {
        const response = JsonParserPassport(result?.PassportDataModel);
        DeviceEventEmitter.emit('onCompletePassport',{"passportExtractedModel":response});
      } else if (result?.FaceMatchDataModel) {
        const response = JsonParserFaceMatch(result?.FaceMatchDataModel);
       DeviceEventEmitter.emit('onCompleteFaceMatch',{"faceExtractedModel":response});
      } else if (result?.IdDataModel) {
        const response = JsonParserIdCard(result?.IdDataModel);
       DeviceEventEmitter.emit('onCompleteIDCard',{"iDExtractedModel":response});
      } else if (result?.OtherDataModel) {
        const response = JsonParserOtherID(result?.OtherDataModel);
        DeviceEventEmitter.emit('onCompleteOther',{"otherExtractedModel":response});
      }
    });

   // General
   const onSendEvent = emitter.addListener('onSend', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onSend" });
   });

   const onRetryEvent = emitter.addListener('onRetry', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onRetry" });
   });

   const onClipPreparationCompleteEvent = emitter.addListener('onClipPreparationComplete', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onClipPreparationComplete" });
   });

   const onStatusUpdatedEvent = emitter.addListener('onStatusUpdated', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onStatusUpdated" });
   });

   const onUpdatedEvent = emitter.addListener('onUpdated', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onUpdated" });
   });

   const onLivenessUpdateEvent = emitter.addListener('onLivenessUpdate', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onLivenessUpdate" });
   });

   const onCardDetectedEvent = emitter.addListener('onCardDetected', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onCardDetected" });
   });

   const onMrzExtractedEvent = emitter.addListener('onMrzExtracted', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onMrzExtracted" });
   });

   const onMrzDetectedEvent = emitter.addListener('onMrzDetected', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onMrzDetected" });
   });

   const onNoMrzDetectedEvent = emitter.addListener('onNoMrzDetected', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onNoMrzDetected" });
   });

   const onFaceDetectedEvent = emitter.addListener('onFaceDetected', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onFaceDetected" });
   });

   const onNoFaceDetectedEvent = emitter.addListener('onNoFaceDetected', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onNoFaceDetected" });
   });

   const onFaceExtractedEvent = emitter.addListener('onFaceExtracted', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onFaceExtracted" });
   });

   const onQualityCheckAvailableEvent = emitter.addListener('onQualityCheckAvailable', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onQualityCheckAvailable" });
   });

   const onDocumentCapturedEvent = emitter.addListener('onDocumentCaptured', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onDocumentCaptured" });
   });

   const onDocumentCroppedEvent = emitter.addListener('onDocumentCropped', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onDocumentCropped" });
   });

   const onUploadFailedEvent = emitter.addListener('onUploadFailed', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onUploadFailed" });
   });

   const onWrongTemplate = emitter.addListener('onWrongTemplate', (result) => {
     DeviceEventEmitter.emit('EventResult', { "eventName": "onWrongTemplate" });
   });


   /// SubmitResult
     const submitResult = emitter.addListener('SubmitResult', (result) => {
     if(result != null){
      if (result?.success) {
         DeviceEventEmitter.emit('SubmitDataEvents',{"Success":true});
        }else{
         DeviceEventEmitter.emit('SubmitDataEvents',{"Success":false});
       }
     }
    });


    return () => {
      assentifySdkInit.remove();
      onComplete.remove();
      onSendEvent.remove();
      onRetryEvent.remove();
      onClipPreparationCompleteEvent.remove();
      onStatusUpdatedEvent.remove();
      onUpdatedEvent.remove();
      onLivenessUpdateEvent.remove();
      onCardDetectedEvent.remove();
      onMrzExtractedEvent.remove();
      onMrzDetectedEvent.remove();
      onNoMrzDetectedEvent.remove();
      onFaceDetectedEvent.remove();
      onNoFaceDetectedEvent.remove();
      onFaceExtractedEvent.remove();
      onQualityCheckAvailableEvent.remove();
      onDocumentCapturedEvent.remove();
      onDocumentCroppedEvent.remove();
      onUploadFailedEvent.remove();
      onWrongTemplate.remove();
      submitResult.remove();
    };
  }, [
  ]);

  return (
    <AssentifyContext.Provider value={undefined}>
    </AssentifyContext.Provider>
  );
};

export { AssentifyProvider };

