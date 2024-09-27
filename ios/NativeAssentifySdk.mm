#import <React/RCTBridgeModule.h>
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(NativeAssentifySdk, RCTEventEmitter)

RCT_EXTERN_METHOD(initialize: (NSString *)apiKey
                  tenantIdentifier:(NSString *)tenantIdentifier
                  instanceHash:(NSString *)interaction
                  processMrz:(BOOL *)processMrz
                  storeCapturedDocument:(BOOL *)storeCapturedDocument
                  performLivenessDetection:(BOOL *)performLivenessDetection
                  storeImageStream:(BOOL *)storeImageStream
                  saveCapturedVideoID:(BOOL *)saveCapturedVideoID
                  saveCapturedVideoFace:(BOOL *)saveCapturedVideoFace
                  ENV_BRIGHTNESS_HIGH_THRESHOLD:(float *)ENV_BRIGHTNESS_HIGH_THRESHOLD
                  ENV_BRIGHTNESS_LOW_THRESHOLD:(float *)ENV_BRIGHTNESS_LOW_THRESHOLD
                  ENV_PREDICTION_LOW_PERCENTAGE:(float *)ENV_PREDICTION_LOW_PERCENTAGE
                  ENV_PREDICTION_HIGH_PERCENTAGE:(float *)ENV_PREDICTION_HIGH_PERCENTAGE
                  ENV_CustomColor:(NSString *)ENV_CustomColor
                  ENV_HoldHandColor:(NSString *)ENV_HoldHandColor
                  )
RCT_EXTERN_METHOD(startScanPassport)
RCT_EXTERN_METHOD(startScanOtherIDPage)
RCT_EXTERN_METHOD(startScanIDPage:(NSString *)kycDocumentDetails)
RCT_EXTERN_METHOD(submitData:(NSDictionary *)data)
RCT_EXTERN_METHOD(supportedEvents)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end



