

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "KSHImageTarget.h"
#import "exbankcard.h"
#import "../BankInfo.h"

#define KSHThumbnailCreatedNotification @"KSHThumbnailCreated"

@protocol KSHCameraControllerDelegate <NSObject>
- (void)deviceConfigurationFailedWithError:(NSError*)error;
- (void)mediaCaptureFailedWithError:(NSError*)error;
- (void)assetLibraryWriteFailedWithError:(NSError*)error;
@end

@protocol KSHRecDelegate <NSObject>
- (CGRect)getEffectImageRect:(CGSize)size;
- (UIInterfaceOrientation)getOrientation;
- (void)BankCardRecognited:(BankInfo*)bankInfo;
- (void)showRecError:(NSString*)str;
@optional
- (BOOL)bankIsSupport:(NSString *)bankName;
- (void)setPrompt:(NSString *)prompt;
@end

@interface KSHCameraController : NSObject
@property (nonatomic, weak) id <KSHCameraControllerDelegate> delegate;
@property (nonatomic, strong, readonly) AVCaptureSession *captureSession;
@property (nonatomic, assign, readonly) NSUInteger cameraCount;
@property (nonatomic, assign, readonly) BOOL cameraHasTorch;
@property (nonatomic, assign, readonly) BOOL cameraHasFlash;
@property (nonatomic, assign, readonly) BOOL cameraSupportsTapToFocus;
@property (nonatomic, assign, readonly) BOOL cameraSupportsTapToExpose;
@property (nonatomic, assign) AVCaptureTorchMode torchMode;
@property (nonatomic, assign) AVCaptureFlashMode flashMode;
@property (nonatomic, assign, readonly) NSTimeInterval recordedDuration;
@property (nonatomic, copy) NSString *sessionPreset;
@property (nonatomic, weak) id<KSHImageTarget> imageTarget;
@property (nonatomic, weak) id<KSHRecDelegate> recDelegate;
@property (nonatomic, assign) BOOL filterEnable;

@property (nonatomic, assign) BOOL bInProcessing;
@property (nonatomic, assign) BOOL bHasResult;
@property (nonatomic, assign) BOOL bShouldStop;

- (BOOL)setupSession:(NSError **)error;
- (void)startSession;
- (void)stopSession;

- (BOOL)switchCameras;
- (BOOL)canSwitchCameras;

- (void)focusAtPoint:(CGPoint)point;
- (void)exposeAtPoint:(CGPoint)point;
- (void)resetFocusAndExposureModes;

- (void)captureStillImage;
- (void)resetRecParams;
//- (void)flashlight;

//- (void)startRecording;
//- (void)stopRecording;
//- (BOOL)isRecording;
- (CGRect)getGuideFrame:(CGRect)rect withOrientation:(int)orientation;
@end
