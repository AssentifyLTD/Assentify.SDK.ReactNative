import type {
  FaceExtractedModel,
  IDExtractedModel,
  KycDocumentDetails,
  OtherExtractedModel,
  PassportExtractedModel,
  Templates,
  TemplatesByCountry,
} from './types';
import { create } from 'zustand';
import type { CountryCode } from 'react-native-country-picker-modal';

type GlobalStoreState = {
  countryCode: CountryCode;
  isPassportScanComplete: boolean;
  isIDScanComplete: boolean;
  isOtherIDScanComplete: boolean;
  isFaceScanComplete: boolean;
  isSubmittingData: boolean;
  isSubmittedData: boolean;
  isSubmittedSuccess: boolean;
  scannedData: PassportExtractedModel | null;
  idScannedData: IDExtractedModel | null;
  otherIdScannedData: OtherExtractedModel | null;
  faceMatchData: FaceExtractedModel | null;
  preferredCountry: CountryCode[] | string[];
  supportedCountries: TemplatesByCountry[];
  supportedTemplates: Templates[];
  kycDocumentDetails: KycDocumentDetails[] | null;
  docType: string | null;
  isVisible: boolean;

  setCountryCode: (countryCode: CountryCode | null) => void;
  setIsPassportScanComplete: (isPassportScanComplete: boolean) => void;
  setIsIDScanComplete: (isIDScanComplete: boolean) => void;
  setIsOtherIDScanComplete: (isOtherIDScanComplete: boolean) => void;
  setIsFaceScanComplete: (isFaceScanComplete: boolean) => void;
  setIsSubmittingData: (isSubmittingData: boolean) => void;
  setIsSubmittedData: (isSubmittedData: boolean) => void;
  setIsSubmittedSuccess: (isSubmittedSuccess: boolean) => void;
  setScannedData: (scannedData: PassportExtractedModel | null) => void;
  setIDScannedData: (idScannedData: IDExtractedModel | null) => void;
  setOtherIDScannedData: (
    otherIdScannedData: OtherExtractedModel | null
  ) => void;
  setFaceMatchData: (faceMatchData: FaceExtractedModel | null) => void;
  setPreferredCountry: (preferredCountry: CountryCode[]) => void;
  setSupportedCountries: (supportedCountries: TemplatesByCountry[]) => void;
  setSupportedTemplates: (supportedTemplates: Templates[]) => void;
  setKYCDocumentDetails: (
    kycDocumentDetails: KycDocumentDetails[] | null
  ) => void;
  setDocType: (docType: string | null) => void;
  setIsVisible: (isVisible: boolean) => void;
  clearGlobalStore: () => void;
};

const persistState = {
  countryCode: 'LB' as CountryCode,
  preferredCountry: [],
  supportedCountries: [],
  supportedTemplates: [],
  kycDocumentDetails: [],
};

const initialState = {
  isPassportScanComplete: false,
  isIDScanComplete: false,
  isOtherIDScanComplete: false,
  isFaceScanComplete: false,
  isSubmittingData: false,
  isSubmittedData: false,
  isSubmittedSuccess: false,
  scannedData: null,
  idScannedData: null,
  otherIdScannedData: null,
  faceMatchData: null,
  docType: null,
  isVisible: false,
};

const useGlobalStore = create<GlobalStoreState>()((set) => ({
  ...initialState,
  ...persistState,
  setCountryCode: (countryCode: CountryCode | null) =>
    set({ countryCode: countryCode as any }),
  setIsPassportScanComplete: (isPassportScanComplete: boolean) =>
    set({ isPassportScanComplete }),
  setIsIDScanComplete: (isIDScanComplete: boolean) => set({ isIDScanComplete }),
  setIsOtherIDScanComplete: (isOtherIDScanComplete: boolean) =>
    set({ isOtherIDScanComplete }),
  setIsFaceScanComplete: (isFaceScanComplete: boolean) =>
    set({ isFaceScanComplete }),
  setIsSubmittingData: (isSubmittingData: boolean) => set({ isSubmittingData }),
  setIsSubmittedData: (isSubmittedData: boolean) => set({ isSubmittedData }),
  setIsSubmittedSuccess: (isSubmittedSuccess: boolean) =>
    set({ isSubmittedSuccess }),
  setScannedData: (scannedData: PassportExtractedModel | null) =>
    set({ scannedData }),
  setIDScannedData: (idScannedData: IDExtractedModel | null) =>
    set({ idScannedData }),
  setOtherIDScannedData: (otherIdScannedData: OtherExtractedModel | null) =>
    set({ otherIdScannedData }),
  setFaceMatchData: (faceMatchData: FaceExtractedModel | null) =>
    set({ faceMatchData }),
  setPreferredCountry: (preferredCountry: CountryCode[]) =>
    set({ preferredCountry }),
  setSupportedCountries: (supportedCountries: TemplatesByCountry[]) =>
    set({ supportedCountries }),
  setSupportedTemplates: (supportedTemplates: Templates[]) =>
    set({ supportedTemplates }),
  setKYCDocumentDetails: (kycDocumentDetails: KycDocumentDetails[] | null) =>
    set({ kycDocumentDetails }),
  setDocType: (docType: string | null) => set({ docType }),
  setIsVisible: (isVisible: boolean) => set({ isVisible }),
  clearGlobalStore: () => set({ ...initialState }),
}));

export default useGlobalStore;
