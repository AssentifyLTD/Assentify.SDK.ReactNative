import type {
  Faces,
  IdentificationDocumentCapture,
  OtherExtractedModel,
} from '../../types';

const JsonParserOtherID = (jsonString: string): OtherExtractedModel => {
  const jsonObject = JSON.parse(jsonString ?? '');
  const outputProperties = jsonObject?.outputProperties;
  const extractedData = jsonObject?.extractedData;
  const additionalDetails = jsonObject?.additionalDetails;
  const imageUrl = jsonObject?.imageUrl;
  const faces = jsonObject?.faces as Faces[];
  const identificationDocumentCapture =
    jsonObject?.identificationDocumentCapture as IdentificationDocumentCapture;

  return {
    outputProperties,
    extractedData,
    additionalDetails,
    imageUrl,
    faces,
    identificationDocumentCapture,
  };
};

export default JsonParserOtherID;
