import { NavigationContainer } from '@react-navigation/native';
import * as React from 'react';
import MyStack from './navigator';
import { AssentifyProvider } from 'react-native-assentify-sdk';
import { GestureHandlerRootView } from 'react-native-gesture-handler';

export default function App() {
  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <NavigationContainer>
        <MyStack />
        <AssentifyProvider />
      </NavigationContainer>
    </GestureHandlerRootView>
  );
}
