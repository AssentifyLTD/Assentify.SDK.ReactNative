import { pixelSizeVertical } from '../themes/styling';
import React from 'react';
import { View, StyleSheet, SafeAreaView } from 'react-native';
import type { ViewStyle, StyleProp } from 'react-native';

type HeaderSubComponent = React.ReactElement<{}> | React.ReactNode;

type CustomHeaderProps = {
  headerLeft?: HeaderSubComponent;
  headerRight?: HeaderSubComponent;
  headerTitle?: HeaderSubComponent;
  containerStyle?: StyleProp<ViewStyle>;
};

const CustomHeader: React.FC<CustomHeaderProps> = ({
  headerLeft,
  headerRight,
  headerTitle,
  containerStyle,
}) => {
  return (
    <SafeAreaView style={[styles.ViewHeader, containerStyle]}>
      <View style={styles.headerLeft}>{headerLeft}</View>
      <View style={styles.headerTitle}>{headerTitle}</View>
      <View style={styles.headerRight}>{headerRight}</View>
    </SafeAreaView>
  );
};

export default CustomHeader;

const styles = StyleSheet.create({
  ViewHeader: {
    flexDirection: 'row',
    alignItems: 'center',

    marginTop: pixelSizeVertical(15),
    width: '100%',
  },
  headerLeft: {
    // flex: 1,
    minWidth: 50,
    justifyContent: 'center',
    alignItems: 'flex-start',
  },
  headerRight: {
    // flex: 1,
    minWidth: 50,
    justifyContent: 'center',
    alignItems: 'flex-end',
  },
  headerTitle: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    width: 'auto',
  },
});
