import type { BaseDataModel } from '../../types';

export const onLivenessUpdateCallback = (dataModel: BaseDataModel) => {
  if (dataModel?.PassportDataModel) {
    const result = JSON.parse(dataModel?.PassportDataModel as string);
    console.log('onLivenessUpdate passport: ', result);
  } else if (dataModel?.FaceMatchDataModel) {
    const result = JSON.parse(dataModel?.FaceMatchDataModel as string);
    console.log('onLivenessUpdate faceMath: ', result);
  } else if (dataModel?.IdDataModel) {
    const result = JSON.parse(dataModel?.IdDataModel as string);
    console.log('onLivenessUpdate ID: ', result);
  } else if (dataModel?.OtherDataModel) {
    const result = JSON.parse(dataModel?.OtherDataModel as string);
    console.log('onLivenessUpdate otherID: ', result);
  }
};
