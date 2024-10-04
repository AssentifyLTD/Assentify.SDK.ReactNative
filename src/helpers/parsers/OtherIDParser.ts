import type {
  Faces,
  IdentificationDocumentCapture,
  OtherExtractedModel,
} from '../../types';

const JsonParserOtherID = (jsonString: string): OtherExtractedModel => {
  const jsonObject = JSON.parse(jsonString ?? '');
  const outputProperties = jsonObject?.outputProperties;
  const transformedProperties = jsonObject?.transformedProperties;
  const extractedData = jsonObject?.extractedData;
  const additionalDetails = jsonObject?.additionalDetails;
  const transformedDetails = jsonObject?.transformedDetails;
  const imageUrl = jsonObject?.imageUrl;
  const faces = jsonObject?.faces as Faces[];
  const identificationDocumentCapture =
    jsonObject?.identificationDocumentCapture as IdentificationDocumentCapture;

  return {
    outputProperties,
    transformedProperties,
    extractedData,
    additionalDetails,
    transformedDetails,
    imageUrl,
    faces,
    identificationDocumentCapture,
  };
};

export default JsonParserOtherID;
