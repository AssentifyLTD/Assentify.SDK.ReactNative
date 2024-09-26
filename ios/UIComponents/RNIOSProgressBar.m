#import <React/RCTViewManager.h>

@interface RNIOSProgressBar : RCTViewManager

@end
 
#import <React/RCTConvert.h>
#import <React/RCTUIManager.h>

@interface ProgressBarView : UIProgressView

@end

@implementation ProgressBarView

@end

@implementation RNIOSProgressBar

RCT_EXPORT_MODULE()

- (UIView *)view
{
  // Progressbar UI
    ProgressBarView *progressBar = [[ProgressBarView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    return progressBar;
}

// Progress bar properties
RCT_EXPORT_VIEW_PROPERTY(progress, float)
RCT_EXPORT_VIEW_PROPERTY(progressTintColor, UIColor)
RCT_EXPORT_VIEW_PROPERTY(trackTintColor, UIColor)

@end
