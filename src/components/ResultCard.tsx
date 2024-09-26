import { StyleSheet, Text, View } from 'react-native';
import React from 'react';
import BaseIcon from './BaseIcon/BaseIcon';
import BaseButton from './BaseButton';
import { fontPixel, pixelSizeVertical } from '../themes/styling';
import { COLORS } from '../themes';
import { FAILED_RESULT } from '../types';

type Props = {
  reason: number;
  onPress?: () => void;
};

const ResultCard: React.FC<Props> = ({ reason, onPress }) => {
  return (
    <View style={styles.ResultCard}>
      <View style={styles.Content}>
        <BaseIcon name="big_warning" size={80} />
        {reason === FAILED_RESULT.WRONG_TEMPLATE && (
          <>
            <Text style={styles.Title}>Wrong ID Template</Text>
            <Text style={styles.Subtitle}>Invalid document type</Text>
          </>
        )}
        {reason === FAILED_RESULT.NO_FACE_DETECTED && (
          <>
            <Text style={styles.Title}>Face not detected</Text>
            <Text style={styles.Subtitle}>
              Face not detected or recognizable. Please try again
            </Text>
          </>
        )}
        {reason === FAILED_RESULT.EXPIRED_DOCUMENT && (
          <>
            <Text style={styles.Title}>This document is expired</Text>
            <Text style={styles.Subtitle}>
              Please try again with a valid document
            </Text>
          </>
        )}
        {(reason === FAILED_RESULT.TAMPERED_DOCUMENT ||
          reason === FAILED_RESULT.TAMPERED_BACK_DOCUMENT) && (
          <>
            <Text style={styles.Title}>This document is tampered</Text>
            <Text style={styles.Subtitle}>
              Please try again with a valid document
            </Text>
          </>
        )}
        {reason === FAILED_RESULT.FAILED_FRONT_ID && (
          <>
            <Text style={styles.Title}>Scan failed</Text>
            <Text style={styles.Subtitle}>
              Please try again with a valid Front ID
            </Text>
          </>
        )}
        {reason === FAILED_RESULT.FAILED_BACK_ID && (
          <>
            <Text style={styles.Title}>Scan failed</Text>
            <Text style={styles.Subtitle}>
              Please try again with a valid Back ID
            </Text>
          </>
        )}
      </View>
      <BaseButton label="Try again" onPress={onPress} />
    </View>
  );
};

export default ResultCard;

const styles = StyleSheet.create({
  ResultCard: {},
  Content: {
    alignItems: 'center',
    marginBottom: pixelSizeVertical(24),
  },
  Title: {
    fontSize: fontPixel(20),
    lineHeight: 26,
    fontWeight: '600',
    color: COLORS.secondaryBase1,
    marginVertical: pixelSizeVertical(16),
  },
  Subtitle: {
    fontSize: fontPixel(14),
    lineHeight: 20,
    fontWeight: '400',
    color: COLORS.secondary700,
  },
});
