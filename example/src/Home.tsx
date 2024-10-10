import { View, StyleSheet, Button, DeviceEventEmitter } from 'react-native';
import React, { useEffect } from 'react';

import { Assentify } from 'react-native-assentify-sdk';

const API_KEY =
  '7UXZBSN2CeGxamNnp9CluLJn7Bb55lJo2SjXmXqiFULyM245nZXGGQvs956Fy5a5s1KoC4aMp5RXju8w';
const tenantIdentifier = '4232e33b-1a90-4b74-94a4-08dcab07bc4d';
const instanceHash =
  'F0D1B6A7D863E9E4089B70EE5786D3D8DF90EE7BDD12BE315019E1F2FC0E875A';

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
