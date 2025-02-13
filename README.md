# assentify-sdk-react-native


This React Native package provides integration with Assentify's services, allowing developers to incorporate Assentify functionalities seamlessly into their React Native applications.

## About Assentify

[Assentify](https://assentify.com/home) is a leading provider of advanced AI-driven solutions for businesses across various industries. We specialize in harnessing the power of artificial intelligence to optimize processes, enhance decision-making, and drive innovation.

With a focus on cutting-edge technologies such as machine learning, natural language processing, and computer vision, Assentify empowers organizations to unlock new opportunities and stay ahead in today's rapidly evolving digital landscape.

## Features

- **Integration:** Easily integrate Assentify's AI capabilities into your React Native applications..
- **Customization:** Tailor the integration to suit your specific requirements and use cases.
- **Scalability:**  Scale seamlessly as your application grows, with robust support from Assentify's infrastructure.
- **Security:** Ensure the highest levels of data security and compliance with Assentify's industry-leading standards.

## Installation

To install the Assentify React Native package, simply add it to your project:

npm install assentify-sdk-react-native
# or
yarn add assentify-sdk-react-native

## Installation Android
**Permissions**

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
**AndroidManifest** Open your AndroidManifest.xml file and add the following activity.

```xml
<application>
  <activity android:name="com.assentifysdk.ScanPassportActivity" android:exported="true" android:noHistory="true" />
  <activity android:name="com.assentifysdk.ScanOtherActivity" android:exported="true" android:noHistory="true" />
  <activity android:name="com.assentifysdk.FaceMatchActivity" android:exported="true" android:noHistory="true" />
  <activity android:name="com.assentifysdk.ScanIDActivity" android:exported="true" android:noHistory="true" />
</application>
```

## Versions
**0.0.1**
- Initial release of the Assentify React Native SDK
- Core features implemented, including integration with Assentify's AI services
- Basic scanning and face matching functionalities
- Support for both iOS and Android platforms


## Author

Assentify, info.assentify@gmail.com

## License

AssentifySdk is available under the MIT license. See the LICENSE file for more info.
