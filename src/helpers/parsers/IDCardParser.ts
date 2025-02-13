import type {
  Faces,
  IDExtractedModel,
  IdentificationDocumentCapture,
} from '../../types';

const JsonParserIdCard = (jsonString: string): IDExtractedModel => {
  const jsonObject = JSON.parse(jsonString ?? '');
  const outputProperties = jsonObject?.outputProperties;
  const transformedProperties = jsonObject?.transformedProperties;
  const extractedData = jsonObject?.extractedData;
  const imageUrl = jsonObject?.imageUrl;
  const faces = jsonObject?.faces as Faces[];
  const identificationDocumentCapture =
    jsonObject?.identificationDocumentCapture as IdentificationDocumentCapture;

  return {
    outputProperties,
    transformedProperties,
    extractedData,
    imageUrl,
    faces,
    identificationDocumentCapture,
  };
};

export default JsonParserIdCard;
