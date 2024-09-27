import { View, StyleSheet, Button, DeviceEventEmitter } from 'react-native';
import React, { useEffect } from 'react';

import { Assentify } from 'react-native-assentify-sdk';

const API_KEY =
  'QwWzzKOYLkDzCLJ9lENlgvRQ1kmkKDv76KbJ9sPfr9Joxwj2DUuzC7htaZP89RqzgB9i9lHc4IpYOA7g';
const tenantIdentifier = '2937c91f-c905-434b-d13d-08dcc04755ec';
const instanceHash =
  'AA48A31C1B6852BE4C709956F540403C906950181561A490FC8CC8D45050EE7E';

const Home = () => {
  const onStartVerification = () => {
    Assentify.initialize(API_KEY, tenantIdentifier, instanceHash);
  };

  useEffect(() => {
    const emitter = DeviceEventEmitter.addListener(
      'doneScanResult',
      (AppResult) => {
        console.log('DeviceEventEmitter doneScanResult: ', AppResult);
      }
    );
    const emitter2 = DeviceEventEmitter.addListener(
      'closeAssentifyApp',
      (AppResult) => {
        console.log('DeviceEventEmitter closeAssentifyApp: ', AppResult);
      }
    );

    return () => {
      emitter.remove();
      emitter2.remove();
    };
  }, []);

  return (
    <View style={styles.container}>
      <Button title="Initialize KYC" onPress={onStartVerification} />
    </View>
  );
};

export default Home;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    rowGap: 20,
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
