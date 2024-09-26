import { useFocusEffect } from '@react-navigation/native';
import { useCallback } from 'react';
import { BackHandler } from 'react-native';

export function useBackHandler(handler: () => boolean) {
  useFocusEffect(
    useCallback(() => {
      BackHandler.addEventListener('hardwareBackPress', handler);

      return () =>
        BackHandler.removeEventListener('hardwareBackPress', handler);
    }, [handler])
  );
}
