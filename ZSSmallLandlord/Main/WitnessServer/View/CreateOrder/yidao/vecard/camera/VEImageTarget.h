
#import <CoreMedia/CoreMedia.h>

@protocol VEImageTarget <NSObject>
- (void)updateContentImage:(CIImage*)image;
- (void)updateContentImage2:(CIImage*)image;
- (CGRect)getEffectImageRect;
@end