import { ScrollView, StyleSheet, SafeAreaView } from 'react-native';
import type { ViewStyle, StyleProp } from 'react-native';
import React from 'react';
import CustomHeader from './CustomHeader';
import { COLORS } from '../themes';

type HeaderSubComponent = React.ReactElement<{}> | React.ReactNode;

type PageProps = {
  containerStyle?: StyleProp<ViewStyle>;
  scrollViewStyle?: StyleProp<ViewStyle>;
  scrollViewContentContainerStyle?: StyleProp<ViewStyle>;
  headerContainerStyle?: StyleProp<ViewStyle>;
  children?: React.ReactNode;
  footerComponent?: React.ReactNode;
  headerLeft?: HeaderSubComponent;
  headerRight?: HeaderSubComponent;
  headerTitle?: HeaderSubComponent;
};

const Page: React.FC<PageProps> = ({
  containerStyle,
  scrollViewStyle,
  scrollViewContentContainerStyle,
  children,
  footerComponent,
  headerContainerStyle,
  headerLeft,
  headerRight,
  headerTitle,
}) => {
  return (
    <SafeAreaView style={[styles.container, containerStyle]}>
      <CustomHeader
        headerLeft={headerLeft}
        headerRight={headerRight}
        headerTitle={headerTitle}
        containerStyle={headerContainerStyle}
      />
      <ScrollView
        style={scrollViewStyle}
        contentContainerStyle={[
          styles.ScrollViewContainer,
          scrollViewContentContainerStyle,
        ]}
      >
        {children}
      </ScrollView>
      {footerComponent}
    </SafeAreaView>
  );
};

export default Page;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.white,
  },
  ScrollViewContainer: {
    flexGrow: 1,
  },
});
