import { StyleSheet, Text, View } from 'react-native';
import React from 'react';
import { fontPixel, pixelSizeVertical } from '../themes/styling';
import { COLORS } from '../themes';

type Props = {
  title?: string;
  label?: string;
};

const DetailLabel: React.FC<Props> = ({ title, label }) => {
  return (
    <View style={styles.DetailLabel}>
      <Text style={styles.Title}>{title}</Text>
      <Text style={styles.Label}>{label}</Text>
    </View>
  );
};

export default DetailLabel;

const styles = StyleSheet.create({
  DetailLabel: {
    marginBottom: pixelSizeVertical(16),
  },
  Title: {
    fontSize: fontPixel(16),
    fontWeight: '500',
    lineHeight: 22,
    color: COLORS.secondary700,
  },
  Label: {
    fontSize: fontPixel(14),
    fontWeight: '400',
    lineHeight: 20,
    color: COLORS.secondaryBase1,
  },
});
