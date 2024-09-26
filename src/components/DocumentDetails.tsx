import { StyleSheet, View } from 'react-native';
import React from 'react';
import { COLORS } from '../themes';
import { pixelSizeHorizontal, pixelSizeVertical } from '../themes/styling';
import DetailLabel from './DetailLabel';
import type { PassportExtractedModel } from '../types';

type Props = {
  scannedData?: PassportExtractedModel;
};

const DocumentDetails: React.FC<Props> = (props) => {
  const { scannedData } = props;
  const mrzFields = scannedData?.identificationDocumentCapture;

  const mrzField = (field: string) => {
    return mrzFields?.[field as keyof typeof mrzFields];
  };

  return (
    <View style={styles.DocumentDetails}>
      <DetailLabel title="First name" label={mrzField('name')} />
      <DetailLabel title="Family name" label={mrzField('surname')} />
      <DetailLabel title="Country" label={mrzField('country')} />
      <DetailLabel title="Nationality" label={mrzField('nationality')} />
      <DetailLabel title="Birthdate" label={mrzField('birthDate')} />
      <DetailLabel title="Expiry date" label={mrzField('expiryDate')} />
      <DetailLabel title="Sex" label={mrzField('sex')} />
      <DetailLabel title="Document type" label={mrzField('documentType')} />
      <DetailLabel title="Document number" label={mrzField('documentNumber')} />
    </View>
  );
};

export default DocumentDetails;

const styles = StyleSheet.create({
  DocumentDetails: {
    borderWidth: 1,
    borderColor: COLORS.secondary200,
    borderRadius: 16,
    paddingVertical: pixelSizeVertical(24),
    paddingHorizontal: pixelSizeHorizontal(24),
  },
});
