import { NativeModules, Platform, Alert, Linking } from 'react-native';
import { request, PERMISSIONS, RESULTS } from 'react-native-permissions';
import { type LanguageCode } from './Language';
import { type KycDocumentDetails } from './types';

const LINKING_ERROR =
  `The package 'assentify-sdk-react-native-react-native' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const { NativeAssentifySdk } = NativeModules;

const AssentifySdk = NativeModules.NativeAssentifySdk
  ? NativeModules.NativeAssentifySdk
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

const AssentifyWrapper = {
 /// Initialize
  initialize: function (
    apiKey: string,
    tenantIdentifier: string,
    instanceHash: string,
    processMrz?: boolean,
    storeCapturedDocument?: boolean,
    performLivenessDocument?: boolean,
    performLivenessFace?: boolean,
    storeImageStream?: boolean,
    saveCapturedVideoID?: boolean,
    saveCapturedVideoFace?: boolean,
    ENV_CustomColor?: string,
    enableDetect?: boolean,
    enableGuide?: boolean
  ) {
    request(
      Platform.select({
        android: PERMISSIONS.ANDROID.CAMERA,
        ios: PERMISSIONS.IOS.CAMERA,
        default: PERMISSIONS.ANDROID.CAMERA,
      })
    ).then(
      (result) => {
        if (result === RESULTS.GRANTED) {
          AssentifySdk.initialize(
            apiKey,
            tenantIdentifier,
            instanceHash,
            processMrz ?? true,
            storeCapturedDocument ?? true,
            performLivenessDocument ?? false,
            performLivenessFace ?? false,
            storeImageStream ?? true,
            saveCapturedVideoID ?? true,
            saveCapturedVideoFace ?? true,
            ENV_CustomColor ?? '#f5a103',
            enableDetect ?? true,
            enableGuide ?? true
          );
        } else if (
          result === RESULTS.UNAVAILABLE ||
          result === RESULTS.DENIED ||
          result === RESULTS.BLOCKED
        ) {
          Alert.alert(
            'Warning!',
            'Please allow your camera permission in order to proceed further',
            [
              {
                text: 'Open Settings',
                onPress: () => {
                  Linking.openSettings();
                },
              },
              {
                text: 'Cancel',
                onPress: () => {},
              },
            ]
          );
        }
      },
      () => {
        Alert.alert(
          'Warning!',
          'Please allow your camera permission in order to proceed further',
          [
            {
              text: 'Open Settings',
              onPress: () => {
                Linking.openSettings();
              },
            },
            {
              text: 'Cancel',
              onPress: () => {},
            },
          ]
        );
      }
    );
  },

  /// Passport
   startScanPassport: function (language: LanguageCode,){
      AssentifySdk.startScanPassport(language);
    },

    /// Other
    startScanOther: function (language: LanguageCode,){
       AssentifySdk.startScanOtherIDPage(language);
     },

    /// ID
    startScanIDCard: function (kycDocumentDetailsList: KycDocumentDetails[],language: LanguageCode,flippingCard: boolean){
       AssentifySdk.startScanIDPage(JSON.stringify(kycDocumentDetailsList),language,flippingCard);
    },

    /// Face Match
     startFaceMatch: function (imageUrl: String,showCountDown: boolean){
           AssentifySdk.startFaceMatch(imageUrl,showCountDown);
     },


     /// Submit Data
     submitData: function (dataMap:Record<string, string> ){
          AssentifySdk.submitData(dataMap);
      }





};

export default AssentifyWrapper;
