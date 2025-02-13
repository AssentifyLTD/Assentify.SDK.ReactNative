import type {
  Faces,
  IdentificationDocumentCapture,
  PassportExtractedModel,
} from '../../types';

const JsonParserPassport = (jsonString: string): PassportExtractedModel => {
  const jsonObject = JSON.parse(jsonString ?? '');
  const outputProperties = jsonObject?.outputProperties;
  const transformedProperties = jsonObject?.transformedProperties;
  const extractedData = jsonObject?.extractedData;
  const imageUrl = jsonObject?.imageUrl;
  const identificationDocumentCapture =
    jsonObject?.identificationDocumentCapture as IdentificationDocumentCapture;
  const faces = jsonObject?.faces as Faces[];

  return {
    outputProperties,
    transformedProperties,
    extractedData,
    imageUrl,
    faces,
    identificationDocumentCapture,
  };
};

export default JsonParserPassport;
