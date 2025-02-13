import React from 'react';

import { createNativeStackNavigator } from '@react-navigation/native-stack';
import Home from './Home';

const Stack = createNativeStackNavigator();

function MyStack() {
  return (
    <Stack.Navigator>
      <Stack.Screen name="Home" component={Home} />
    </Stack.Navigator>
  );
}

export default MyStack;
