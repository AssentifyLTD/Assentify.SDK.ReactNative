import { StyleSheet, View, Text } from 'react-native';
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
  const extractedFields = scannedData?.extractedData;

  if (!extractedFields) {
    return <Text>No data available</Text>;
  }

  return (
    <View style={styles.DocumentDetails}>
      {Object.entries(extractedFields).map(([key, value]) => (
        <DetailLabel key={key} title={key} label={value} />
      ))}
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
