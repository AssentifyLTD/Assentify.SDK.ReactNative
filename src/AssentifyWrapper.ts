import { NativeModules, Platform, Alert, Linking } from 'react-native';
import { request, PERMISSIONS, RESULTS } from 'react-native-permissions';

const LINKING_ERROR =
  `The package 'react-native-react-native-assentify-sdk' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

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
  initialize: function (
    apiKey: string,
    tenantIdentifier: string,
    instanceHash: string,
    processMrz?: boolean,
    storeCapturedDocument?: boolean,
    performLivenessDetection?: boolean,
    storeImageStream?: boolean,
    saveCapturedVideoID?: boolean,
    saveCapturedVideoFace?: boolean,
    ENV_BRIGHTNESS_HIGH_THRESHOLD?: number,
    ENV_BRIGHTNESS_LOW_THRESHOLD?: number,
    ENV_PREDICTION_LOW_PERCENTAGE?: number,
    ENV_PREDICTION_HIGH_PERCENTAGE?: number,
    ENV_CustomColor?: string,
    ENV_HoldHandColor?: string,
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
            performLivenessDetection ?? false,
            storeImageStream ?? true,
            saveCapturedVideoID ?? true,
            saveCapturedVideoFace ?? true,
            ENV_BRIGHTNESS_HIGH_THRESHOLD ?? 500.0,
            ENV_BRIGHTNESS_LOW_THRESHOLD ?? 0.0,
            ENV_PREDICTION_LOW_PERCENTAGE ?? 50.0,
            ENV_PREDICTION_HIGH_PERCENTAGE ?? 100.0,
            ENV_CustomColor ?? '#ffffff',
            ENV_HoldHandColor ?? '#f5a103',
            enableDetect ?? true,
            enableGuide ?? true,
          );
        } else if (result === RESULTS.UNAVAILABLE) {
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
};

export default AssentifyWrapper;
