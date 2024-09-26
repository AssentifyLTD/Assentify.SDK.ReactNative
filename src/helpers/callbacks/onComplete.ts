import type { BaseDataModel } from '../../types';
import JsonParserFaceMatch from '../parsers/FaceMatchParser';
import JsonParserIdCard from '../parsers/IDCardParser';
import JsonParserOtherID from '../parsers/OtherIDParser';
import JsonParserPassport from '../parsers/PassportParser';

export const onCompleteCallback = (
  result: BaseDataModel,
  callback?: (data: any) => void
) => {
  if (result?.PassportDataModel) {
    const passport = JsonParserPassport(result?.PassportDataModel as string);
    callback && callback?.(passport);
  } else if (result?.FaceMatchDataModel) {
    const faceMatch = JsonParserFaceMatch(result?.FaceMatchDataModel as string);
    callback && callback?.(faceMatch);
  } else if (result?.IdDataModel) {
    const idData = JsonParserIdCard(result?.IdDataModel as string);
    callback && callback?.(idData);
  } else if (result?.OtherDataModel) {
    const otherIdData = JsonParserOtherID(result?.OtherDataModel as string);
    callback && callback?.(otherIdData);
  }
};
