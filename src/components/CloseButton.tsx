import { StyleSheet, TouchableOpacity } from 'react-native';
import React from 'react';
import { pixelSizeHorizontal } from '../themes/styling';
import { COLORS } from '../themes';
import BaseIcon from './BaseIcon/BaseIcon';

type Props = {
  onPress?: () => void;
};

const CloseButton: React.FC<Props> = ({ onPress }) => {
  return (
    <TouchableOpacity style={styles.BackButtons} onPress={onPress}>
      <BaseIcon name="close" color={COLORS.secondaryBase1} />
    </TouchableOpacity>
  );
};

export default CloseButton;

const styles = StyleSheet.create({
  BackButtons: {
    padding: 6,
    justifyContent: 'center',
    alignItems: 'center',
    marginLeft: pixelSizeHorizontal(16),
  },
});
