import React from 'react';
import { ActivityIndicator, StyleSheet, View } from 'react-native';
//import { COLORS } from '../../lib/commonjs/themes';

const AppSpinner: React.FC = () => {
  return (
    <View style={styles.Loader}>
      <ActivityIndicator
        style={styles.ActivityIndicator}
        size="large"
        color="#f5a103"
      />
    </View>
  );
};

export default AppSpinner;

const styles = StyleSheet.create({
  Loader: {
    flex: 1,
    position: 'absolute',
    zIndex: 99999,
    top: 0,
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: '#00000000',
  },
  ActivityIndicator: {
    zIndex: 99999,
    justifyContent: 'center',
    alignItems: 'center',
    flex: 1,
  },
});
