import type { BaseDataModel } from '../../types';

export const onErrorCallback = (dataModel: BaseDataModel) => {
  if (dataModel?.PassportDataModel) {
    const result = JSON.parse(dataModel?.PassportDataModel as string);
    console.log('onError passport: ', result);
  } else if (dataModel?.FaceMatchDataModel) {
    const result = JSON.parse(dataModel?.FaceMatchDataModel as string);
    console.log('onError faceMath: ', result);
  } else if (dataModel?.IdDataModel) {
    const result = JSON.parse(dataModel?.IdDataModel as string);
    console.log('onError ID: ', result);
  } else if (dataModel?.OtherDataModel) {
    const result = JSON.parse(dataModel?.OtherDataModel as string);
    console.log('onError otherID: ', result);
  }
};
