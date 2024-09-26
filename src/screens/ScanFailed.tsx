import { StyleSheet, Text, View } from 'react-native';
import React from 'react';
import {
  fontPixel,
  pixelSizeHorizontal,
  pixelSizeVertical,
} from '../themes/styling';
import { COLORS } from '../themes';
import ResultCard from '../components/ResultCard';
import Page from '../components/Page';
import BackButton from '../components/BackButton';
import NavigationService from '../helpers/NavigationService';
import { useRoute } from '@react-navigation/native';
import { PAGES } from '../helpers/constants';
import useGlobalStore from '../useGlobalStore';

const ScanFailed = () => {
  const params = useRoute().params as any;
  const reason = params?.reason;
  const { clearGlobalStore } = useGlobalStore();

  const onPressBack = () => {
    NavigationService.goBack();
  };

  const onTryAgain = () => {
    clearGlobalStore();
    NavigationService.reset(PAGES.SELECT_DOCUMENT);
  };

  return (
    <Page
      scrollViewStyle={styles.container}
      headerLeft={<BackButton onPress={onPressBack} />}
    >
      <View style={styles.Header}>
        <Text style={styles.HeaderText}>Invalid Document</Text>
      </View>
      <View style={styles.Content}>
        <ResultCard reason={reason} onPress={onTryAgain} />
      </View>
    </Page>
  );
};

export default ScanFailed;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    paddingHorizontal: pixelSizeHorizontal(16),
  },
  Header: {
    paddingVertical: pixelSizeVertical(16),
  },
  HeaderText: {
    fontSize: fontPixel(24),
    fontWeight: '700',
    lineHeight: 30,
    color: COLORS.secondaryBase1,
  },
  Content: { flex: 1, alignItems: 'center', justifyContent: 'center' },
});
