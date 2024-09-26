import { StyleSheet, Text, View } from 'react-native';
import React from 'react';
import Page from '../components/Page';
import BackButton from '../components/BackButton';
import {
  fontPixel,
  pixelSizeHorizontal,
  pixelSizeVertical,
} from '../themes/styling';
import { DOC_TYPE } from '../helpers/constants';
import { COLORS } from '../themes';
import useGlobalStore from '../useGlobalStore';
import PassportScanner from '../components/NativeComponents/PassportScanner';
import NavigationService from '../helpers/NavigationService';

const Scanner = () => {
  const { docType } = useGlobalStore();

  const onPressBack = () => {
    NavigationService.goBack();
  };

  return (
    <Page
      scrollViewStyle={styles.container}
      headerLeft={<BackButton onPress={onPressBack} />}
    >
      <View style={styles.Header}>
        <Text style={styles.HeaderText}>
          Please scan your {docType === DOC_TYPE.PASSPORT ? 'passport' : 'ID'}
        </Text>
      </View>
      <View style={styles.Flex}>
        <PassportScanner style={{ flex: 1, backgroundColor: 'red' }} />
        {/* <Image source={require('../assets/passport.png')} /> */}
        {/* <ProgressBar
          progress={50}
          progressTintColor={'#000'}
          trackTintColor={'#ccc'}
          style={styles.bar}
        /> */}
      </View>
    </Page>
  );
};

export default Scanner;

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
    // backgroundColor: '#1C1C1D',
    borderRadius: 16,
    overflow: 'hidden',
  },
  bar: { width: '80%', height: 30 },
});
