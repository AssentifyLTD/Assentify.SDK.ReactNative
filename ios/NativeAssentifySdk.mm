#import <React/RCTBridgeModule.h>
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(NativeAssentifySdk, RCTEventEmitter)

RCT_EXTERN_METHOD(initialize: (NSString *)apiKey
                  tenantIdentifier:(NSString *)tenantIdentifier
                  instanceHash:(NSString *)interaction
                  processMrz:(BOOL *)processMrz
                  storeCapturedDocument:(BOOL *)storeCapturedDocument
                  performLivenessDocument:(BOOL *)performLivenessDocument
                  performLivenessFace:(BOOL *)performLivenessFace
                  storeImageStream:(BOOL *)storeImageStream
                  saveCapturedVideoID:(BOOL *)saveCapturedVideoID
                  saveCapturedVideoFace:(BOOL *)saveCapturedVideoFace
                  ENV_CustomColor:(NSString *)ENV_CustomColor
                  enableDetect:(BOOL *)enableDetect
                  enableGuide:(BOOL *)enableGuide
                  )
RCT_EXTERN_METHOD(startScanPassport:
                  (NSString *)language
                  )
RCT_EXTERN_METHOD(startScanOtherIDPage:
                  (NSString *)language
                  )
RCT_EXTERN_METHOD(startScanIDPage:(NSString *)kycDocumentDetails
                          language:(NSString *)language
                      flippingCard:(BOOL)flippingCard
                      )
RCT_EXTERN_METHOD(startFaceMatch:(NSString *)imageUrl
                      showCountDown:(BOOL)showCountDown
                      )

RCT_EXTERN_METHOD(submitData:(NSDictionary *)data)
RCT_EXTERN_METHOD(supportedEvents)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end



