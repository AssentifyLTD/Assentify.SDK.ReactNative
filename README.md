# assentify-sdk

React Native module that allows you to use the native Assentify SDK

## Installation

```sh
npm install @me/assentify-sdk
```

```sh
yarn add @me/assentify-sdk
```

## Usag

```js
  import { Assentify } from '@me/assentify-sdk';
  import { View, NativeModules } from 'react-native';

  const { NativeAssentifySdk } = NativeModules;

  const apiKey = 'YOUR_API_KEY';
  const tenantIdentifier = 'YOUR_TENANT_IDENTIFIER';
  const instanceHash = 'YOUR_INTERACTION';

  React.useEffect(() => {
    const listener = new NativeEventEmitter(AssentifySdk);

    listener.addListener('EventResult', (EventResult) => {
      console.log('EventResult: ', EventResult);
    });

    listener.addListener('EventError', (EventError) =>
      console.log('EventError: ', EventError)
    );

    return ()=> {
      listener.removeAllListeners('EventResult');
      listener.removeAllListeners('EventError');
    }
  }, []);

  // ... Press to start verification proces
  const onStartVerification = () => {
    Assentify.initialize(apiKey, tenantIdentifier, instanceHash);
  };


  export default function App() {
    return (
      <View>
        // Provider must be added
        <AssentifyProvider />
      </View>
    );
  }
```

## Compatibility
We only ensure compatibility with a minimum React Native version of 0.73.6


## Integration

### iOS
 --- Documentation Here ---
```
 yarn install

 cd ios && NO_FLIPPER=1 USE_FRAMEWORKS=static pod install && cd ..

 yarn example ios
 ```


### Android
--- Documentation Here ---

```
yarn install

yarn example android
```

__Permissions__
```xml
  <uses-permission android:name="android.permission.INTERNET" />
  <uses-permission android:name="android.permission.CAMERA" />
  <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
  <uses-permission android:name="android.permission.RECORD_AUDIO" />
  <uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />

  <uses-feature android:name="android.hardware.camera" />
  <uses-feature android:name="android.hardware.camera.autofocus" />
```


__AndroidManifest__ Open your AndroidManifest.xml file and add the following activity.
```xml
<application>
      <activity android:name="com.assentifysdk.SplashScreen"/>
      <activity android:name="com.assentifysdk.IdCapture.DocCaptureConfig"/>
      <activity android:name="com.assentifysdk.IdCapture.DocCaptureID"/>
      <activity android:name="com.assentifysdk.IdCapture.DocCaptureIntro"/>
      <activity android:name="com.assentifysdk.IdCapture.DocCaptureOtherResult"/>
      <activity android:name="com.assentifysdk.IdCapture.DocCapturePassportResult"/>
      <activity android:name="com.assentifysdk.IdCapture.DocCaptureIDResult"/>
      <activity android:name="com.assentifysdk.IdCapture.DocCapturePassport"/>
      <activity android:name="com.assentifysdk.IdCapture.DocCaptureOther"/>
      <activity android:name="com.assentifysdk.IdCapture.DocCaptureIDBack"/>
      <activity android:name="com.assentifysdk.IdCapture.IDCardRotation"/>
      <activity android:name="com.assentifysdk.FaceMatch.FaceMatchActivity"/>
      <activity android:name="com.assentifysdk.FaceMatch.FaceMatchResult"/>
      <activity android:name="com.assentifysdk.ContextAware.ContextAwareSigningActivity"/>
      <activity android:name="com.assentifysdk.FaceMatch.PdfFullScreen"/>
</application>
```


## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

Copyright (c) 2024  SAL

Proprietary and confidential.  This project is confidential and only available to authorized individuals with the permission of the copyright holders.

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
