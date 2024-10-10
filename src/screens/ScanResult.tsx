import { StyleSheet, Text, View, Platform } from 'react-native';
import React from 'react';
import {
  fontPixel,
  pixelSizeHorizontal,
  pixelSizeVertical,
} from '../themes/styling';
import { COLORS } from '../themes';
import BaseButton from '../components/BaseButton';
import FaceScan from '../components/FaceScan';
import DocumentDetails from '../components/DocumentDetails';
import Page from '../components/Page';
import BackButton from '../components/BackButton';
import useGlobalStore from '../useGlobalStore';
import { usePub } from '../helpers/usePubSub';
import AppSpinner from '../components/AppSpinner';
import ResultCard from '../components/ResultCard';
import { DOC_TYPE, PAGES } from '../helpers/constants';
import NavigationService from '../helpers/NavigationService';
import { FAILED_RESULT } from '../types';
import { useBackHandler } from '../helpers/useBackHandler';
import IDDocumentDetail from '../components/IDDocumentDetail';

type Props = {};

const ScanResult: React.FC<Props> = () => {
  const publish = usePub();
  const {
    docType,
    scannedData,
    faceMatchData,
    idScannedData,
    otherIdScannedData,
    clearGlobalStore,
    isSubmittingData,
    isSubmittedData,
    isSubmittedSuccess,
  } = useGlobalStore();


  useBackHandler(() => {
    console.log('HowToCapture backAction');
    onPressBack();
    return false;
  });

  const onPressBack = () => {
    NavigationService.goBack();
  };

  const onContinue = () => {
    clearGlobalStore();
    publish('doneScanResult');
  };

  const onTryAgain = () => {
    clearGlobalStore();
    NavigationService.reset(PAGES.SELECT_DOCUMENT);
  };

  const renderPageScanResult = () => (
    <>
      <View style={styles.Header}>
        <Text style={styles.HeaderText}>Review extracted details</Text>
      </View>
      <View style={styles.CardGroup}>
        <Text style={styles.CardGroupTitle}>Face scan</Text>
        <FaceScan faceExtracted={faceMatchData!} />
      </View>
      <View style={styles.CardGroup}>
        <Text style={styles.CardGroupTitle}>Document details</Text>
        {docType === DOC_TYPE.PASSPORT && (
          <DocumentDetails scannedData={scannedData!} />
        )}
        {docType === DOC_TYPE.CIVIL_ID && (
          <IDDocumentDetail scannedData={idScannedData!} />
        )}
        {docType === DOC_TYPE.OTHER && (
          <IDDocumentDetail scannedData={otherIdScannedData!} />
        )}
      </View>
    </>
  );

  const renderPageScanFailed = () => (
    <>
      <View style={styles.Header}>
        <Text style={styles.HeaderText}>Invalid Document</Text>
      </View>
      <View style={styles.Content}>
        <ResultCard
          reason={FAILED_RESULT.EXPIRED_DOCUMENT}
          onPress={onTryAgain}
        />
      </View>
    </>
  );

  return (
    <Page
      scrollViewStyle={styles.container}
      headerLeft={<BackButton onPress={onPressBack} />}
      footerComponent={
        isSubmittedData && isSubmittedSuccess ? (
          <View
            style={{
              ...styles.Footer,
              paddingBottom: pixelSizeVertical(Platform.OS === 'ios' ? 8 : 30),
            }}
          >
            <BaseButton label="Continue" onPress={onContinue} />
          </View>
        ) : null
      }
    >
      {isSubmittingData ? (
        <AppSpinner />
      ) : isSubmittedData ? (
        isSubmittedSuccess ? (
          renderPageScanResult()
        ) : (
          renderPageScanFailed()
        )
      ) : (
        <AppSpinner />
      )}
    </Page>
  );
};

export default ScanResult;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.secondary100,
    paddingHorizontal: pixelSizeHorizontal(16),
  },
  Header: {
    paddingVertical: pixelSizeVertical(16),
    marginBottom: pixelSizeVertical(24),
  },
  HeaderText: {
    fontSize: fontPixel(24),
    fontWeight: '700',
    lineHeight: 30,
    color: COLORS.secondaryBase1,
  },
  ScrollViewContent: {
    flexGrow: 1,
  },
  CardGroup: { marginBottom: pixelSizeVertical(24) },
  CardGroupTitle: {
    fontSize: fontPixel(16),
    fontWeight: '600',
    lineHeight: 22,
    color: COLORS.secondaryBase1,
    marginBottom: pixelSizeVertical(8),
  },
  Footer: {
    paddingHorizontal: pixelSizeHorizontal(16),
  },
  Content: { flex: 1, alignItems: 'center', justifyContent: 'center' },
});
