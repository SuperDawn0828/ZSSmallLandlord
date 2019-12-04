
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface VEContextManager : NSObject
+ (instancetype)sharedInstance;
@property (strong, nonatomic, readonly) EAGLContext *eaglContext;
@property (strong, nonatomic, readonly) CIContext *ciContext;
@end