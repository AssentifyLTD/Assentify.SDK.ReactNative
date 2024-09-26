import type { BaseDataModel } from '../../types';

export const onEnvironmentalConditionsChangeCallback = (
  dataModel: BaseDataModel
) => {
  if (dataModel?.PassportDataModel) {
    // const result = JSON.parse(dataModel?.PassportDataModel as string);
    // const result = dataModel?.PassportDataModel as string;
    // console.log('onEnvironmentalConditionsChange passport: ', result);
  } else if (dataModel?.FaceMatchDataModel) {
    // const result = JSON.parse(dataModel?.FaceMatchDataModel as string);
    // const result = dataModel?.FaceMatchDataModel as string;
    // console.log('onEnvironmentalConditionsChange faceMatch: ', result);
  } else if (dataModel?.IdDataModel) {
    // const result = JSON.parse(dataModel?.IdDataModel as string);
    // const result = dataModel?.IdDataModel as string;
    // console.log('onEnvironmentalConditionsChange ID: ', result);
  } else if (dataModel?.OtherDataModel) {
    // const result = JSON.parse(dataModel?.OtherDataModel as string);
    // const result = dataModel?.OtherDataModel as string;
    // console.log('onEnvironmentalConditionsChange otherID: ', result);
  }
};
