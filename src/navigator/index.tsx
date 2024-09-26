import { PAGES } from '../helpers/constants';
import SplashScreen from '../screens/SplashScreen';
import SelectDocument from '../screens/SelectDocument';

import React from 'react';
// import { View } from 'react-native';
import {
  NavigationContainer,
  type NavigationContainerRef,
} from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import HowToCapture from '../screens/HowToCapture';
import ScanResult from '../screens/ScanResult';
import Scanner from '../screens/Scanner';
import ScanFailed from '../screens/ScanFailed';
import NavigationService from '../helpers/NavigationService';

const Stack = createNativeStackNavigator();

const AssentifyNavigator = () => {
  const navigationRef = React.useRef<NavigationContainerRef<any> | null>(null);

  return (
    <NavigationContainer
      independent
      ref={navigationRef}
      onReady={() => {
        NavigationService.setTopLevelNavigator(navigationRef.current!);

        NavigationService.reset(PAGES.SPLASH_SCREEN);
      }}
    >
      <Stack.Navigator
        screenOptions={{
          headerShown: false,
        }}
        initialRouteName={PAGES.SPLASH_SCREEN}
      >
        <Stack.Screen name={PAGES.SPLASH_SCREEN} component={SplashScreen} />
        <Stack.Screen name={PAGES.SELECT_DOCUMENT} component={SelectDocument} />
        <Stack.Screen name={PAGES.HOW_TO_CAPTURE} component={HowToCapture} />
        <Stack.Screen name={PAGES.SCANNER} component={Scanner} />
        <Stack.Screen name={PAGES.SCAN_RESULT} component={ScanResult} />
        <Stack.Screen name={PAGES.SCAN_FAILED} component={ScanFailed} />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default AssentifyNavigator;
