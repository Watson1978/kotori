#import <WebKit/WebKit.h>
#import "WKWebView+TextZoom.h"

@implementation WKWebView (Kotori)
@dynamic _textZoomFactor;

- (double)textZoomFactor
{
    double factor = self._textZoomFactor;
    return factor;
}

- (void)setTextZoomFactor:(double)factor
{
    self._textZoomFactor = factor;
}

@end
