import { StyleSheet, Text, View, Image } from 'react-native';
import React, { useMemo } from 'react';
import { COLORS } from '../themes';
import {
  fontPixel,
  heightPixel,
  pixelSizeHorizontal,
  pixelSizeVertical,
  widthPixel,
} from '../themes/styling';
import BaseIcon from './BaseIcon/BaseIcon';
import type { FaceExtractedModel, IdentificationDocument } from '../types';

type Props = {
  faceExtracted?: FaceExtractedModel | null;
  mrzExtracted?: IdentificationDocument | null;
};

const FaceScan: React.FC<Props> = ({ faceExtracted }) => {
  const percentageMatch = useMemo(() => {
    return isNaN(faceExtracted?.percentageMatch!)
      ? faceExtracted?.extractedData?.Percentage
      : faceExtracted?.percentageMatch;
  }, [faceExtracted]);

  return (
    <View style={styles.FaceScan}>
      <Image
        style={styles.FaceImage}
        source={{
          uri: faceExtracted?.baseImageFace!,
        }}
        defaultSource={require('../assets/user.png')}
      />
      <View style={styles.Match}>
        <BaseIcon name="check_success" size={24} />
        <Text
          style={[
            styles.MatchText,
            {
              marginTop: pixelSizeVertical(4),
            },
          ]}
        >
          {Number(percentageMatch).toFixed(2)}%
        </Text>
        <Text style={styles.MatchText}>Match</Text>
      </View>
      <Image
        style={styles.FaceImage}
        source={{
          uri: faceExtracted?.secondImageFace!,
        }}
        defaultSource={require('../assets/user.png')}
      />
    </View>
  );
};

export default FaceScan;

const styles = StyleSheet.create({
  FaceScan: {
    borderWidth: 1,
    borderColor: COLORS.secondary200,
    borderRadius: 16,
    paddingVertical: pixelSizeVertical(24),
    paddingHorizontal: pixelSizeHorizontal(24),

    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  FaceImage: {
    width: widthPixel(100),
    height: heightPixel(100),
    backgroundColor: COLORS.grey300,
    borderRadius: 12,
    overflow: 'hidden',
  },
  Match: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  MatchText: {
    fontSize: fontPixel(14),
    fontWeight: '400',
    lineHeight: 20,
    color: COLORS.secondary700,
  },
});
