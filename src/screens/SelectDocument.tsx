import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import React, { useEffect, useState } from 'react';
import CountryPicker from 'react-native-country-picker-modal';
import type { Country, CountryCode } from 'react-native-country-picker-modal';
import {
  fontPixel,
  pixelSizeHorizontal,
  pixelSizeVertical,
} from '../themes/styling';
import { COLORS } from '../themes';
import BaseIcon from '../components/BaseIcon/BaseIcon';
import Page from '../components/Page';
import CloseButton from '../components/CloseButton';
import { DOC_TYPE, PAGES } from '../helpers/constants';
import useGlobalStore from '../useGlobalStore';
import Each from '../components/Each';
import type { KycDocumentDetails, Templates } from '../types';
import { usePub } from '../helpers/usePubSub';
import NavigationService from '../helpers/NavigationService';
import { useBackHandler } from '../helpers/useBackHandler';

type Props = {};

const SelectDocument: React.FC<Props> = () => {
  const {
    supportedTemplates,
    supportedCountries,
    preferredCountry,
    countryCode,
    setCountryCode,
    setSupportedTemplates,
    setKYCDocumentDetails,
    setDocType,
    setIsVisible,
  } = useGlobalStore();
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const publish = usePub();

  useBackHandler(() => {
    console.log('SelectDocument backAction');
    onClose();
    return false;
  });

  const onClose = () => {
    console.log('SelectDocument onClose');
    setCountryCode(null);
    setDocType(null);
    setIsVisible(false);
    publish('closeApp');
  };

  const onNavigate = (docType: string, docDetails?: KycDocumentDetails[]) => {
    setDocType(docType);
    if (docDetails && docDetails?.length) {
      setKYCDocumentDetails(docDetails!);
    }
    NavigationService.navigate(PAGES.HOW_TO_CAPTURE);
  };

  const onSelect = (country: Country) => {
    setCountryCode(country.cca2);
  };

  const onOpen = () => {
    setIsOpenModal(true);
  };

  useEffect(() => {
    if (supportedCountries) {
      const seletedCountry = supportedCountries?.find(
        (item) => item.sourceCountryCode === countryCode ?? 'LB'
      );
      if (seletedCountry) {
        const templates = seletedCountry?.templates;
        const kycDetails: Templates[] = [];
        templates.forEach((item) => {
          if (item.kycDocumentDetails && item.kycDocumentDetails?.length) {
            kycDetails.push(item);
          }
        });
        setSupportedTemplates(kycDetails);
      }
    }
  }, [countryCode, setSupportedTemplates, supportedCountries]);

  return (
    <Page
      scrollViewStyle={styles.ScrollView}
      headerLeft={<CloseButton onPress={onClose} />}
    >
      <View style={styles.container}>
        <Text style={styles.CardTitle}>Select Document</Text>
        {preferredCountry && (
          <TouchableOpacity style={styles.DropdownSelect} onPress={onOpen}>
            <CountryPicker
              preferredCountries={preferredCountry as CountryCode[]}
              countryCodes={preferredCountry as CountryCode[]}
              onClose={() => setIsOpenModal(false)}
              countryCode={countryCode ?? 'LB'}
              onSelect={onSelect}
              withFilter
              withFlag
              withCountryNameButton
              withAlphaFilter={false}
              withCallingCode
              withEmoji
              key={'countryPicker-' + countryCode}
              visible={isOpenModal}
            />
            <BaseIcon name="chevron_down" color={COLORS.secondary800} />
          </TouchableOpacity>
        )}
      </View>
      <View style={styles.Card}>
        <Text style={styles.CardTitle}>Select document type</Text>
        <View style={styles.CardContent}>
          <TouchableOpacity
            style={[
              styles.CardItem,
              supportedTemplates?.length ? styles.CardItemBordered : null,
            ]}
            onPress={() => onNavigate(DOC_TYPE.PASSPORT)}
          >
            <Text style={styles.CardItemText}>Passport</Text>
            <BaseIcon name="chevron_right" color={COLORS.secondary800} />
          </TouchableOpacity>
          {supportedTemplates && (
            <Each
              of={supportedTemplates}
              render={(item, index) => (
                <TouchableOpacity
                  key={`supported_template_${index}`}
                  style={[
                    styles.CardItem,
                    index !== supportedTemplates?.length - 1
                      ? styles.CardItemBordered
                      : null,
                  ]}
                  onPress={() =>
                    onNavigate(DOC_TYPE.CIVIL_ID, item.kycDocumentDetails)
                  }
                >
                  <Text style={styles.CardItemText}>
                    {item?.kycDocumentType}
                  </Text>
                  <BaseIcon name="chevron_right" color={COLORS.secondary800} />
                </TouchableOpacity>
              )}
            />
          )}
        </View>
      </View>
    </Page>
  );
};

export default SelectDocument;

const styles = StyleSheet.create({
  ScrollView: {
    flex: 1,
    backgroundColor: '#fff',
    paddingHorizontal: pixelSizeHorizontal(16),
  },
  container: {
    marginTop: pixelSizeVertical(40),
  },
  Card: {
    flex: 1,
    marginVertical: pixelSizeVertical(16),
  },
  CardTitle: {
    fontSize: fontPixel(14),
    fontWeight: '600',
    lineHeight: 20,
    color: COLORS.secondary1200,
    marginBottom: pixelSizeVertical(8),
  },
  CardContent: {
    borderWidth: 1,
    borderColor: COLORS.secondary300,
    borderRadius: 16,
  },
  CardItem: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingLeft: pixelSizeHorizontal(24),
    paddingRight: pixelSizeHorizontal(12),
    paddingVertical: pixelSizeVertical(16),
  },
  CardItemBordered: {
    borderBottomWidth: 1,
    borderBottomColor: COLORS.secondary300,
  },
  CardItemText: {
    fontSize: fontPixel(14),
    fontWeight: '600',
    lineHeight: 20,
    color: COLORS.secondaryBase1,
  },
  DropdownSelect: {
    borderWidth: 1,
    borderColor: COLORS.secondary300,
    borderRadius: 16,

    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',

    paddingVertical: pixelSizeVertical(10),
    paddingHorizontal: pixelSizeVertical(16),
  },
  DropdownTitle: {
    fontSize: fontPixel(14),
    fontWeight: '500',
    lineHeight: 20,
    color: COLORS.secondaryBase1,
  },
});
