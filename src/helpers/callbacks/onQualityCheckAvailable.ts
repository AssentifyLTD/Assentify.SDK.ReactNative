import type { BaseDataModel } from '../../types';

export const onQualityCheckAvailableCallback = (dataModel: BaseDataModel) => {
  if (dataModel?.PassportDataModel) {
    const result = JSON.parse(dataModel?.PassportDataModel as string);
    console.log('onQualityCheckAvailable passport: ', result);
  } else if (dataModel?.FaceMatchDataModel) {
    const result = JSON.parse(dataModel?.FaceMatchDataModel as string);
    console.log('onQualityCheckAvailable faceMath: ', result);
  } else if (dataModel?.IdDataModel) {
    const result = JSON.parse(dataModel?.IdDataModel as string);
    console.log('onQualityCheckAvailable ID: ', result);
  } else if (dataModel?.OtherDataModel) {
    const result = JSON.parse(dataModel?.OtherDataModel as string);
    console.log('onQualityCheckAvailable otherID: ', result);
  }
};
