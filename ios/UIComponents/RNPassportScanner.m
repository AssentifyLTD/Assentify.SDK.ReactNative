#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(RNPassportScanner, RCTViewManager)

    RCT_EXPORT_VIEW_PROPERTY(onSendCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onErrorCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onRetryCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onClipPreparationCompleteCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onStatusUpdatedCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onUpdatedCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onLivenessUpdateCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onCompleteCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onCardDetectedCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onMrzExtractedCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onMrzDetectedCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onNoMrzDetectedCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onFaceDetectedCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onNoFaceDetectedCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onFaceExtractedCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onQualityCheckAvailableCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onDocumentCapturedCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onDocumentCroppedCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onUploadFailedCallback, RCTBubblingEventBlock)
    RCT_EXPORT_VIEW_PROPERTY(onEnvironmentalConditionsChangeCallback, RCTBubblingEventBlock)

@end
