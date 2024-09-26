import type {
  FaceExtractedModel,
  IdentificationDocumentCapture,
} from '../../types';

const JsonParserFaceMatch = (jsonString: string): FaceExtractedModel => {
  const jsonObject = JSON.parse(jsonString ?? '');
  const outputProperties = jsonObject?.outputProperties;
  const extractedData = jsonObject?.extractedData;
  const baseImageFace = jsonObject?.baseImageFace;
  const secondImageFace = jsonObject?.secondImageFace;
  const isLive = !!jsonObject?.isLive;
  const identificationDocumentCapture =
    jsonObject?.identificationDocumentCapture as IdentificationDocumentCapture;
  const percentageMatch = Number(jsonObject?.PercentageMatch) ?? 0;

  return {
    outputProperties,
    baseImageFace,
    secondImageFace,
    percentageMatch,
    extractedData,
    identificationDocumentCapture,
    isLive,
  };
};

export default JsonParserFaceMatch;
