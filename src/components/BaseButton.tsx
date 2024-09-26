import { StyleSheet, Text, TouchableOpacity } from 'react-native';
import React from 'react';
import { COLORS } from '../themes';
import {
  fontPixel,
  pixelSizeHorizontal,
  pixelSizeVertical,
} from '../themes/styling';

type Props = {
  label: string;
  onPress?: () => void;
};

const BaseButton: React.FC<Props> = ({ label, onPress }) => {
  return (
    <TouchableOpacity
      activeOpacity={0.7}
      style={styles.BaseButton}
      onPress={onPress}
    >
      <Text style={styles.labelStyle}>{label}</Text>
    </TouchableOpacity>
  );
};

export default BaseButton;

const styles = StyleSheet.create({
  BaseButton: {
    backgroundColor: "#f5a103",
    paddingVertical: pixelSizeVertical(12),
    paddingHorizontal: pixelSizeHorizontal(16),
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 48,
  },
  labelStyle: {
    fontSize: fontPixel(16),
    fontWeight: '500',
    lineHeight: 22,
    color: COLORS.white,
  },
});
