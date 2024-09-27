import { StyleSheet, View, ActivityIndicator } from 'react-native';
import React, { useCallback, useEffect } from 'react';
import { NativeModules, NativeEventEmitter } from 'react-native';
import { PAGES } from '../helpers/constants';
import type { TemplatesByCountry } from '../types';
import type { CountryCode } from 'react-native-country-picker-modal';
import useGlobalStore from '../useGlobalStore';
import NavigationService from '../helpers/NavigationService';

const { AssentifySdk } = NativeModules;

const SplashScreen = () => {
  const { setPreferredCountry, setSupportedCountries } = useGlobalStore();

  const initSupportedCountry = useCallback(
    (AssentifySdkHasTemplates: string) => {
      if (AssentifySdkHasTemplates) {
        const templates = JSON.parse(
          AssentifySdkHasTemplates
        ) as TemplatesByCountry[];
        if (templates && templates?.length) {
          const mapCountries = templates.map(
            (item: TemplatesByCountry) => item.sourceCountryCode
          ) as CountryCode[];
          setPreferredCountry(mapCountries as CountryCode[]);
          setSupportedCountries(templates as TemplatesByCountry[]);
        }
      }
    },
    [setPreferredCountry, setSupportedCountries]
  );

  useEffect(() => {
    const emitter = new NativeEventEmitter(AssentifySdk);
    const subs = emitter.addListener('AppResult', (AppResult) => {
      if (AppResult?.assentifySdkInitSuccess) {
        if (AppResult?.AssentifySdkHasTemplates) {
          const data = AppResult?.AssentifySdkHasTemplates;
          initSupportedCountry(data);
        }
        NavigationService.navigate(PAGES.SELECT_DOCUMENT);
      }
    });
    return () => {
      subs.remove();
    };
  }, [initSupportedCountry]);

  return (
    <View style={styles.container}>
      <View>
        <ActivityIndicator size="large" color="#f5a103" />
      </View>
    </View>
  );
};

export default SplashScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    justifyContent: 'center',
    alignItems: 'center',
  },
});
