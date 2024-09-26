import { StyleSheet, View } from 'react-native';
import React from 'react';
import type { IDExtractedModel, OtherExtractedModel } from '../types';
import { COLORS } from '../themes';
import { pixelSizeHorizontal, pixelSizeVertical } from '../themes/styling';
import DetailLabel from './DetailLabel';

type Props = {
  scannedData?: IDExtractedModel | OtherExtractedModel;
};

const IDDocumentDetail: React.FC<Props> = (props) => {
  const { scannedData } = props;
  const mrzFields = scannedData?.identificationDocumentCapture;

  const mrzField = (field: string) => {
    return mrzFields?.[field as keyof typeof mrzFields];
  };

  return (
    <View style={styles.DocumentDetails}>
      <DetailLabel title="First name" label={mrzField('name')} />
      <DetailLabel title="Family name" label={mrzField('surname')} />
      <DetailLabel title="Mother's name" label={mrzField('iDMothersName')} />
      <DetailLabel title="Father's name" label={mrzField('iDFathersName')} />
      <DetailLabel title="Country" label={mrzField('country')} />
      <DetailLabel title="Nationality" label={mrzField('nationality')} />
      <DetailLabel title="Birthdate" label={mrzField('birthDate')} />
      <DetailLabel title="Place of birth" label={mrzField('iDPlaceOfBirth')} />
      <DetailLabel title="Expiry date" label={mrzField('expiryDate')} />
      <DetailLabel title="Sex" label={mrzField('sex')} />
      <DetailLabel title="ID type" label={mrzField('iDType')} />
      <DetailLabel title="Document number" label={mrzField('documentNumber')} />
    </View>
  );
};

export default IDDocumentDetail;

const styles = StyleSheet.create({
  DocumentDetails: {
    borderWidth: 1,
    borderColor: COLORS.secondary200,
    borderRadius: 16,
    paddingVertical: pixelSizeVertical(24),
    paddingHorizontal: pixelSizeHorizontal(24),
  },
});
