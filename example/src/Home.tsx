import { View, StyleSheet, Button, DeviceEventEmitter } from 'react-native';
import React, { useEffect ,useState} from 'react';

import { Assentify , Language } from 'react-native-assentify-sdk';
import { PassportExtractedModel} from 'react-native-assentify-sdk';




const API_KEY =
  '7UXZBSN2CeGxamNnp9CluLJn7Bb55lJo2SjXmXqiFULyM245nZXGGQvs956Fy5a5s1KoC4aMp5RXju8w';
const tenantIdentifier = '4232e33b-1a90-4b74-94a4-08dcab07bc4d';
const instanceHash =
  'F0D1B6A7D863E9E4089B70EE5786D3D8DF90EE7BDD12BE315019E1F2FC0E875A';
 let imageUrl = '';
const Home = () => {
  const [isSdkInitialized, setIsSdkInitialized] = useState(false);
  const [kycDocumentDetailsList, setKycDocumentDetailsList] = useState(null);

 /// Initialize
  const onInitialize = () => {
    Assentify.initialize(
      API_KEY,
      tenantIdentifier,
      instanceHash,
      true, // Process Mrz
      true, // Store Captured Document
      false, // Perform Liveness Document
      false, // Perform Liveness Face
      true, // Store Image Stream
      true, // Save Captured VideoID
      true, // Save Captured Video Face
      '#f50303', // Custom Color
      true, // Enable Detect
      true, // Enable Guide
    );
  };

 /// Passport
  const startScanPassport = () => {
      Assentify.startScanPassport(Language.NON);
  };

/// Other
  const startScanOther = () => {
      Assentify.startScanOther(Language.English);
  };

/// IDCard
  const startScanIDCard = () => {
      Assentify.startScanIDCard(kycDocumentDetailsList,Language.English ,true); // kycDocumentDetailsList - flippingCard
  };


  /// FaceMatch
    const startFaceMatch = () => {
        Assentify.startFaceMatch(imageUrl ,true); // showCountDown
    };

 /// Submit Data
    const submitData = () => {
    const blockLoaderAdditionalData = {
        phoneNumber: '0000',
    };
        Assentify.submitData(blockLoaderAdditionalData); // showCountDown
    };


  useEffect(() => {
   /// Initialize
   const assentifySdkInit = DeviceEventEmitter.addListener(
        'assentifySdkInit',
        (AppResult) => {
        if (AppResult.status === true) {
          const templates = AppResult.templates as TemplatesByCountry[];
          const lebanonTemplates = templates.find(template => template.name === 'Lebanon').templates;
          const civilID = lebanonTemplates.find(template => template.kycDocumentType === 'Lebanese Civil ID');
          setKycDocumentDetailsList(civilID.kycDocumentDetails);
          setIsSdkInitialized(true);
        }
      }
    );

   /// onComplete Passport
   const  onCompletePassport = DeviceEventEmitter.addListener(
        'onCompletePassport',
        (result) => {
        const passportExtractedModel = result.passportExtractedModel as PassportExtractedModel;
        console.log("ExampleEvents Passport: ",passportExtractedModel)
        console.log("ExampleEvents Passport: ",passportExtractedModel.imageUrl)
        console.log("ExampleEvents Passport: ",passportExtractedModel.outputProperties)

        ///
        imageUrl = passportExtractedModel.imageUrl;
      }
    );

   /// onComplete Other
   const  onCompleteOther = DeviceEventEmitter.addListener(
        'onCompleteOther',
        (result) => {
        const otherExtractedModel = result.otherExtractedModel as OtherExtractedModel;
        console.log("ExampleEvents Other: ",otherExtractedModel)
        console.log("ExampleEvents Other: ",otherExtractedModel.imageUrl)
        console.log("ExampleEvents Other: ",otherExtractedModel.outputProperties)
        console.log("ExampleEvents Other: ",otherExtractedModel.additionalDetails)
      }
    );



   /// onComplete IDCard
   const  onCompleteIDCard = DeviceEventEmitter.addListener(
        'onCompleteIDCard',
        (result) => {
        const iDExtractedModel = result.iDExtractedModel as IDExtractedModel;
        console.log("ExampleEvents IDCard: ",iDExtractedModel)
        console.log("ExampleEvents IDCard: ",iDExtractedModel.outputProperties)
        ///
         if (imageUrl === '') {
           imageUrl = iDExtractedModel.imageUrl;
         }
      }
    );




  /// onComplete FaceMatch
    const  onCompleteFaceMatch = DeviceEventEmitter.addListener(
         'onCompleteFaceMatch',
         (result) => {
         const faceExtractedModel = result.faceExtractedModel as FaceExtractedModel;
         console.log("ExampleEvents FaceMatch: ",faceExtractedModel)
         console.log("ExampleEvents FaceMatch: ",faceExtractedModel.percentageMatch)
       }
     );

    /// GeneralEvents
    const generalEvents = DeviceEventEmitter.addListener(
            'EventResult',
            (result) => {
            console.log("ExampleEvents : ",result)
          }
     );

   /// SubmitResult
     const submitDataEvents = DeviceEventEmitter.addListener(
             'SubmitDataEvents',
             (result) => {
              console.log("ExampleEvents : ",result)
           }
      );


    return () => {
      assentifySdkInit.remove();
      onCompletePassport.remove();
      onCompleteOther.remove();
      onCompleteIDCard.remove();
      onCompleteFaceMatch.remove();
      generalEvents.remove();
      submitDataEvents.remove();
    };
  }, []);

return (
  <View style={styles.container}>
    {!isSdkInitialized && (
    <Button title="Initialize KYC" onPress={onInitialize} />
    )}
     {isSdkInitialized && (
           <View style={styles.container}>
             <Button title="Start Scan Passport" onPress={startScanPassport} />
             <Button title="Start Scan Other" onPress={startScanOther} />
             <Button title="Start ID Card" onPress={startScanIDCard} />
             <Button title="Start Face Match" onPress={startFaceMatch} />
             <Button title="Submit Data" onPress={submitData} />
            </View>
      )}
  </View>
);
};

export default Home;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    rowGap: 20,
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
