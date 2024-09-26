import { StyleSheet, TouchableOpacity } from 'react-native';
import React from 'react';
import { pixelSizeHorizontal } from '../themes/styling';
import { COLORS } from '../themes';
import BaseIcon from './BaseIcon/BaseIcon';

type Props = {
  onPress?: () => void;
};

const BackButton: React.FC<Props> = ({ onPress }) => {
  return (
    <TouchableOpacity style={styles.BackButtons} onPress={onPress}>
      <BaseIcon name="arrow_left" color={COLORS.secondaryBase1} />
    </TouchableOpacity>
  );
};

export default BackButton;

const styles = StyleSheet.create({
  BackButtons: {
    padding: 6,
    justifyContent: 'center',
    alignItems: 'center',
    marginLeft: pixelSizeHorizontal(16),
  },
});
