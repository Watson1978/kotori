#import <WebKit/WebKit.h>

// This is using private property which defined in https://github.com/WebKit/webkit/blob/7682431c131a398e57ffb13473beb130f42c58d6/Source/WebKit2/UIProcess/API/Cocoa/WKWebViewPrivate.h#L235
@interface WKWebView (Kotori)

@property (nonatomic, setter=_setTextZoomFactor:) double _textZoomFactor;

- (double)textZoomFactor;
- (void)setTextZoomFactor:(double)factor;

@end
