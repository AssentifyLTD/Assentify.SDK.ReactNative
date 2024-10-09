import { Platform, StyleSheet, Text, View, Image } from 'react-native';
import React from 'react';
import {
  fontPixel,
  pixelSizeHorizontal,
  pixelSizeVertical,
} from '../themes/styling';
import { COLORS } from '../themes';
import BaseButton from '../components/BaseButton';
import Page from '../components/Page';
import BackButton from '../components/BackButton';
import { DOC_TYPE } from '../helpers/constants';
import { NativeModules } from 'react-native';
import useGlobalStore from '../useGlobalStore';
import NavigationService from '../helpers/NavigationService';
import { Language } from '../helpers/constants';

const { NativeAssentifySdk } = NativeModules;

type Props = {};

const HowToCapture: React.FC<Props> = () => {
  const { docType, kycDocumentDetails } = useGlobalStore();

  const onStart = () => {
    if (docType === DOC_TYPE.PASSPORT) {
       NativeAssentifySdk.startScanPassport(Language.Arabic,false);
    } else if (docType === DOC_TYPE.CIVIL_ID) {
      NativeAssentifySdk.startScanIDPage(JSON.stringify(kycDocumentDetails),Language.English, true, true);
    } else if (docType === DOC_TYPE.OTHER) {
      NativeAssentifySdk.startScanOtherIDPage(Language.English,true);
    }
    // navigation.navigate(PAGES.SCANNER);
    // navigation.navigate(PAGES.SCAN_FAILED);
    // navigation.navigate(PAGES.SCAN_RESULT);
  };

  const onPressBack = () => {
    NavigationService.pop(1);
  };

  return (
    <Page
      scrollViewStyle={styles.container}
      headerLeft={<BackButton onPress={onPressBack} />}
      footerComponent={
        <View
          style={{
            ...styles.Footer,
            paddingBottom: pixelSizeVertical(Platform.OS === 'ios' ? 8 : 30),
          }}
        >
          <BaseButton label="Continue" onPress={onStart} />
        </View>
      }
    >
      <View style={styles.Header}>
        <Text style={styles.HeaderText}>
          How to capture{' '}
          {docType === DOC_TYPE.PASSPORT ? 'passport' : 'id card'}
        </Text>
      </View>
      <View style={styles.Flex}>
        <Image source={require('../assets/passport.png')} />
      </View>
    </Page>
  );
};

export default HowToCapture;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.white,
    paddingHorizontal: pixelSizeHorizontal(16),
  },
  Header: {
    paddingVertical: pixelSizeVertical(16),
    marginBottom: pixelSizeVertical(20),
  },
  HeaderText: {
    fontSize: fontPixel(24),
    fontWeight: '700',
    lineHeight: 30,
    color: COLORS.secondaryBase1,
  },
  Footer: {
    paddingHorizontal: pixelSizeHorizontal(16),
  },
  Flex: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'flex-start',
  },
});
