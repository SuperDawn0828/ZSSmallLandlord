
#import <UIKit/UIKit.h>
#import "KSHCameraController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "KSHContextManager.h"
#import "sys/sysctl.h"

#define ORIENTATION_OFFSET  100
//#define MIN_FOCUS_SCORE     3.5
#define MIN_FOCUS_SCORE     5.0
#define ABANDON_FRAME_COUNT 4
/////////////////////////////////////////////////////////
int  nType = 0;
int  nRate = 0;
int  nCharNum = 0;
char szBankName[128];
char numbers[256];
CGRect rects[64];
CGRect subRect;
/////////////////////////////////////////////////////////
@import CoreImage;

static long lFrameCount = 0;
static int abandonFrameCount = 0;
@interface KSHCameraController () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL bFirstTime;
    BOOL bNotLessThan5s;
}

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (weak, nonatomic) AVCaptureDeviceInput *activeVideoInput;

@property (strong, nonatomic) AVCaptureStillImageOutput *imageOutput;
@property (strong, nonatomic) AVCaptureVideoDataOutput *videoDataOutput;
@property (strong, nonatomic) AVCaptureAudioDataOutput *audioDataOutput;
@property (strong, nonatomic) AVCaptureMetadataOutput *medaDataOutput;
@property (strong, nonatomic) AVAssetWriter *assetWriter;
@property (strong, nonatomic) AVAssetWriterInput *assetWriterVideoInput;
@property (strong, nonatomic) AVAssetWriterInputPixelBufferAdaptor *assetWriterInputPixelBufferAdaptor;
@property (strong, nonatomic) AVAssetWriterInput *assetWriterAudioInput;
@property (strong, nonatomic) NSMutableDictionary *videoSettings;
@property (strong, nonatomic) NSDictionary *audioSettings;
@property (strong, nonatomic) dispatch_queue_t captureQueue;
@property (assign, nonatomic) CMTime startTime;
@property (assign, nonatomic) BOOL isWriting;
@property (assign, nonatomic) BOOL firstSample;
@property (strong, nonatomic) NSURL *outputURL;

@property (nonatomic, assign, readwrite) NSTimeInterval recordedDuration;

@property (nonatomic, strong) NSArray *faceObjects;

@property (nonatomic, strong) CIFilter *filter;
@property (nonatomic, strong) CIContext *ciContext;
@property (nonatomic, strong) EAGLContext *eaglContext;

@end

@implementation KSHCameraController
static BankInfo * bankInfo;
@synthesize bInProcessing;
@synthesize bHasResult;
@synthesize bShouldStop;

- (void)resetRecParams
{
    abandonFrameCount = 0;
    bInProcessing = NO;
    bHasResult = NO;
    if ([self.captureSession canAddOutput:self.videoDataOutput]) {
        [self.captureSession addOutput:self.videoDataOutput];
        ZSLOG(@"captureSession addOutput");
    }
    
}

- (BOOL)setupSession:(NSError **)error {
    abandonFrameCount = 0;
    bInProcessing = NO;
    bHasResult = NO;
    bFirstTime = YES;
    bNotLessThan5s = [self NotLessThan5s];
    
    self.filterEnable = YES;
    self.filter = [CIFilter filterWithName:@"CIPixellate"];
    self.eaglContext = [KSHContextManager sharedInstance].eaglContext;
    self.ciContext = [KSHContextManager sharedInstance].ciContext;
    
    // Dispatch Setup
    self.captureQueue = dispatch_queue_create("com.kimsungwhee.mosaiccamera.videoqueue", NULL);
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession beginConfiguration];
    self.captureSession.sessionPreset = self.sessionPreset;
    
    // Set up default camera device
    AVCaptureDevice *videoDevice =
    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *videoInput =
    [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
    if (videoInput) {
        if ([self.captureSession canAddInput:videoInput]) {
            [self.captureSession addInput:videoInput];
            self.activeVideoInput = videoInput;
        }
    }
    else {
        [self.captureSession commitConfiguration];
        return NO;
    }
    
    // Setup default microphone
    //	AVCaptureDevice *audioDevice =
    //	    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    //
    //	AVCaptureDeviceInput *audioInput =
    //	    [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:error];
    //	if (audioInput) {
    //		if ([self.captureSession canAddInput:audioInput]) {
    //			[self.captureSession addInput:audioInput];
    //		}
    //	}
    //	else {
    //		return NO;
    //	}
    //Meta data
    /*
     self.medaDataOutput = [[AVCaptureMetadataOutput alloc] init];
     if ([self.captureSession canAddOutput:self.medaDataOutput]) {
     [self.captureSession addOutput:self.medaDataOutput];
     
     self.medaDataOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
     [self.medaDataOutput setMetadataObjectsDelegate:self queue:self.captureQueue];
     
     }
     */
    // Setup the still image output
    //	self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    //	self.imageOutput.outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG };
    //
    //	if ([self.captureSession canAddOutput:self.imageOutput]) {
    //		[self.captureSession addOutput:self.imageOutput];
    //	}
    
    
    //VideoOutput Setup
    self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    [self.videoDataOutput setSampleBufferDelegate:self queue:self.captureQueue];
    
    self.videoDataOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], (id)kCVPixelBufferPixelFormatTypeKey,
                                          nil];
    
    
    if ([self.captureSession canAddOutput:self.videoDataOutput]) {
        [self.captureSession addOutput:self.videoDataOutput];
    }
    else {
        [self.captureSession commitConfiguration];
        return NO;
    }
    
    //AudioOutpu Setup
    //	self.audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
    //	[self.audioDataOutput setSampleBufferDelegate:self queue:self.captureQueue];
    //
    //	if ([self.captureSession canAddOutput:self.audioDataOutput]) {
    //		[self.captureSession addOutput:self.audioDataOutput];
    //	}
    //	else {
    //		return NO;
    //	}
    
    AVCaptureConnection *videoConnection;
    
    for (AVCaptureConnection *connection in[self.videoDataOutput connections]) {
        for (AVCaptureInputPort *port in[connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
            }
        }
    }
    
    
    if ([videoConnection isVideoStabilizationSupported]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            videoConnection.enablesVideoStabilizationWhenAvailable = YES;
        }
        else {
            videoConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    AVCaptureDevice *device = [self activeCamera];
    
    // Use Smooth focus
    if( YES == [device lockForConfiguration:NULL] )
    {
        if([device respondsToSelector:@selector(setSmoothAutoFocusEnabled:)] && [device isSmoothAutoFocusSupported] )
        {
            [device setSmoothAutoFocusEnabled:YES];
        }
        AVCaptureFocusMode currentMode = [device focusMode];
        if( currentMode == AVCaptureFocusModeLocked )
        {
            currentMode = AVCaptureFocusModeAutoFocus;
        }
        if(bNotLessThan5s) {
            currentMode = AVCaptureFocusModeContinuousAutoFocus;
        } else {
            currentMode = AVCaptureFocusModeAutoFocus;
        }
        if( [device isFocusModeSupported:currentMode] )
        {
            [device setFocusMode:currentMode];
        }
        [device unlockForConfiguration];
    }
    
    [self.captureSession commitConfiguration];
    
    //	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    return YES;
}

- (void)startSession {
    abandonFrameCount = 0;
    bHasResult = NO;
    bShouldStop = NO;
    bankInfo = nil;
    if (![self.captureSession isRunning]) {
        dispatch_async([self globalQueue], ^{
            [self.captureSession startRunning];
        });
    }
}

- (void)stopSession {
    if ([self.captureSession isRunning]) {
        dispatch_async([self globalQueue], ^{
            [self.captureSession stopRunning];
        });
    }
}

- (void)deviceOrientationChanged:(id)sender {
    dispatch_sync([self globalQueue], ^{
        if (self.isWriting) {
            return;
        }
        [self updateOrientation];
    });
}

- (void)updateOrientation {
    AVCaptureConnection *videoConnection;
    
    for (AVCaptureConnection *connection in[self.videoDataOutput connections]) {
        for (AVCaptureInputPort *port in[connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
            }
        }
    }
    
    
    if ([videoConnection isVideoOrientationSupported]) {
        videoConnection.videoOrientation = self.currentVideoOrientation;
    }
    
    if ([videoConnection isVideoStabilizationSupported]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            videoConnection.enablesVideoStabilizationWhenAvailable = YES;
        }
        else {
            videoConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    AVCaptureDevice *device = [self activeCamera];
    
    // Use Smooth focus
    NSError *error;
    if( YES == [device lockForConfiguration:NULL] )
    {
        if( [device isSmoothAutoFocusSupported] )
        {
            [device setSmoothAutoFocusEnabled:YES];
        }
        AVCaptureFocusMode currentMode = [device focusMode];
        if( currentMode == AVCaptureFocusModeLocked )
        {
            currentMode = AVCaptureFocusModeAutoFocus;
        }
        if(bNotLessThan5s) {
            currentMode = AVCaptureFocusModeContinuousAutoFocus;
        } else {
            currentMode = AVCaptureFocusModeAutoFocus;
        }
        if( [device isFocusModeSupported:currentMode] )
        {
            [device setFocusMode:currentMode];
        }
        [device unlockForConfiguration];
    }else {
        [self.delegate deviceConfigurationFailedWithError:error];
    }
    
}

- (dispatch_queue_t)globalQueue {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

#pragma mark - Device Configuration

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)activeCamera {
    return self.activeVideoInput.device;
}

- (AVCaptureDevice *)inactiveCamera {
    AVCaptureDevice *device = nil;
    if (self.cameraCount > 1) {
        if ([self activeCamera].position == AVCaptureDevicePositionBack) {
            device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        }
        else {
            device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
    }
    return device;
}

- (BOOL)canSwitchCameras {
    return self.cameraCount > 1;
}

- (NSUInteger)cameraCount {
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

- (BOOL)switchCameras {
    if (![self canSwitchCameras]) {
        return NO;
    }
    
    NSError *error;
    AVCaptureDevice *videoDevice = [self inactiveCamera];
    
    AVCaptureDeviceInput *videoInput =
    [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    
    if (videoInput) {
        [self.captureSession beginConfiguration];
        
        [self.captureSession removeInput:self.activeVideoInput];
        
        if ([self.captureSession canAddInput:videoInput]) {
            [self.captureSession addInput:videoInput];
            self.activeVideoInput = videoInput;
        }
        else {
            [self.captureSession addInput:self.activeVideoInput];
        }
        
        [self.captureSession commitConfiguration];
    }
    else {
        [self.delegate deviceConfigurationFailedWithError:error];
        return NO;
    }
    
    
    self.faceObjects = nil;
    
    return YES;
}

#pragma mark - Flash and Torch Modes

- (BOOL)cameraHasFlash {
    return [[self activeCamera] hasFlash];
}

- (AVCaptureFlashMode)flashMode {
    return [[self activeCamera] flashMode];
}

- (void)setFlashMode:(AVCaptureFlashMode)flashMode {
    AVCaptureDevice *device = [self activeCamera];
    
    if (device.flashMode != flashMode &&
        [device isFlashModeSupported:flashMode]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.flashMode = flashMode;
            [device unlockForConfiguration];
        }
        else {
            [self.delegate deviceConfigurationFailedWithError:error];
        }
    }
}

- (BOOL)cameraHasTorch {
    return [[self activeCamera] hasTorch];
}

- (AVCaptureTorchMode)torchMode {
    return [[self activeCamera] torchMode];
}

- (void)setTorchMode:(AVCaptureTorchMode)torchMode {
    AVCaptureDevice *device = [self activeCamera];
    
    if (device.torchMode != torchMode &&
        [device isTorchModeSupported:torchMode]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.torchMode = torchMode;
            [device unlockForConfiguration];
        }
        else {
            [self.delegate deviceConfigurationFailedWithError:error];
        }
    }
}

#pragma mark - Focus Methods

- (BOOL)cameraSupportsTapToFocus {
    return [[self activeCamera] isFocusPointOfInterestSupported];
}

- (void)focusAtPoint:(CGPoint)point {
    AVCaptureDevice *device = [self activeCamera];
    
    if (device.isFocusPointOfInterestSupported &&
        [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.focusPointOfInterest = point;
            if(bNotLessThan5s) {
                device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            } else {
                device.focusMode = AVCaptureFocusModeAutoFocus;
            }
            [device unlockForConfiguration];
        }
        else {
            [self.delegate deviceConfigurationFailedWithError:error];
        }
    }
}

#pragma mark - Exposure Methods

- (BOOL)cameraSupportsTapToExpose {
    return [[self activeCamera] isExposurePointOfInterestSupported];
}

// Define KVO context pointer for observing 'adjustingExposure" device property.
static const NSString *THCameraAdjustingExposureContext;

- (void)exposeAtPoint:(CGPoint)point {
    AVCaptureDevice *device = [self activeCamera];
    
    AVCaptureExposureMode exposureMode =
    AVCaptureExposureModeContinuousAutoExposure;
    
    if (device.isExposurePointOfInterestSupported &&
        [device isExposureModeSupported:exposureMode]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.exposurePointOfInterest = point;
            device.exposureMode = exposureMode;
            
            if ([device isExposureModeSupported:AVCaptureExposureModeLocked]) {
                [device addObserver:self
                         forKeyPath:@"adjustingExposure"
                            options:NSKeyValueObservingOptionNew
                            context:&THCameraAdjustingExposureContext];
            }
            
            [device unlockForConfiguration];
        }
        else {
            [self.delegate deviceConfigurationFailedWithError:error];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context == &THCameraAdjustingExposureContext) {
        AVCaptureDevice *device = (AVCaptureDevice *)object;
        
        if (!device.isAdjustingExposure &&
            [device isExposureModeSupported:AVCaptureExposureModeLocked]) {
            [object removeObserver:self
                        forKeyPath:@"adjustingExposure"
                           context:&THCameraAdjustingExposureContext];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error;
                if ([device lockForConfiguration:&error]) {
                    device.exposureMode = AVCaptureExposureModeLocked;
                    [device unlockForConfiguration];
                }
                else {
                    [self.delegate deviceConfigurationFailedWithError:error];
                }
            });
        }
    }
    else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)resetFocusAndExposureModes {
    AVCaptureDevice *device = [self activeCamera];
    
    AVCaptureExposureMode exposureMode =
    AVCaptureExposureModeContinuousAutoExposure;
    
    AVCaptureFocusMode focusMode;
    if(bNotLessThan5s) {
        focusMode = AVCaptureFocusModeContinuousAutoFocus;
    } else {
        focusMode = AVCaptureFocusModeAutoFocus;
    }
    
    BOOL canResetFocus = [device isFocusPointOfInterestSupported] &&
    [device isFocusModeSupported:focusMode];
    
    BOOL canResetExposure = [device isExposurePointOfInterestSupported] &&
    [device isExposureModeSupported:exposureMode];
    
    CGPoint centerPoint = CGPointMake(0.5f, 0.5f);
    
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        if (canResetFocus) {
            device.focusMode = focusMode;
            device.focusPointOfInterest = centerPoint;
        }
        
        if (canResetExposure) {
            device.exposureMode = exposureMode;
            device.exposurePointOfInterest = centerPoint;
        }
        
        [device unlockForConfiguration];
    }
    else {
        [self.delegate deviceConfigurationFailedWithError:error];
    }
}

#pragma mark - Image Capture Methods



- (void)captureStillImage {
    AVCaptureConnection *connection =
    [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (connection.isVideoOrientationSupported) {
        connection.videoOrientation = [self currentVideoOrientation];
    }
    
    id handler = ^(CMSampleBufferRef sampleBuffer, NSError *error) {
        if (sampleBuffer != NULL) {
            NSData *imageData =
            [AVCaptureStillImageOutput
             jpegStillImageNSDataRepresentation:sampleBuffer];
            
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            [self writeImageToAssetsLibrary:image];
        }
        else {
            ZSLOG(@"NULL sampleBuffer: %@", [error localizedDescription]);
        }
    };
    // Capture still image
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:connection
                                                  completionHandler:handler];
}

- (void)writeImageToAssetsLibrary:(UIImage *)image {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library writeImageToSavedPhotosAlbum:image.CGImage
                              orientation:(NSInteger)image.imageOrientation
                          completionBlock: ^(NSURL *assetURL, NSError *error) {
                              if (!error) {
                                  [self postThumbnailNotifification:image];
                              }
                              else {
                                  id message = [error localizedDescription];
                                  ZSLOG(@"Error: %@", message);
                              }
                          }];
}

- (void)postThumbnailNotifification:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:KSHThumbnailCreatedNotification object:image];
    });
}

#pragma mark - Video Capture Methods

- (BOOL)isRecording {
    return self.isWriting;
}

- (void)startRecording {
    dispatch_async([self globalQueue], ^{
        if (![self isRecording]) {
            self.videoSettings = [[self.videoDataOutput recommendedVideoSettingsForAssetWriterWithOutputFileType:AVFileTypeMPEG4] mutableCopy];
            
            self.audioSettings = [self.audioDataOutput recommendedAudioSettingsForAssetWriterWithOutputFileType:AVFileTypeMPEG4];
            
            self.outputURL = [self uniqueURL];
            self.startTime = kCMTimeZero;
            NSError *error = nil;
            
            NSString *fileType = AVFileTypeMPEG4;
            self.assetWriter =
            [AVAssetWriter assetWriterWithURL:self.outputURL
                                     fileType:fileType
                                        error:&error];
            if (!self.assetWriter || error) {
                NSString *formatString = @"Could not create AVAssetWriter: %@";
                ZSLOG(@"%@", [NSString stringWithFormat:formatString, error]);
                
                return;
            }
            
            self.assetWriterVideoInput =
            [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo
                                           outputSettings:self.videoSettings];
            
            self.assetWriterVideoInput.expectsMediaDataInRealTime = YES;
            
            UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
            self.assetWriterVideoInput.transform = KSHTransformForDeviceOrientation(orientation);
            
            NSDictionary *attributes = @{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
                                         (id)kCVPixelBufferWidthKey : self.videoSettings[AVVideoWidthKey],
                                         (id)kCVPixelBufferHeightKey : self.videoSettings[AVVideoHeightKey],
                                         (id)kCVPixelFormatOpenGLESCompatibility : (id)kCFBooleanTrue
                                         };
            self.assetWriterInputPixelBufferAdaptor = [[AVAssetWriterInputPixelBufferAdaptor alloc]
                                                       initWithAssetWriterInput:self.assetWriterVideoInput
                                                       sourcePixelBufferAttributes:attributes];
            
            if ([self.assetWriter canAddInput:self.assetWriterVideoInput]) {
                [self.assetWriter addInput:self.assetWriterVideoInput];
            }
            else {
                ZSLOG(@"Unable to add video input.");
                
                return;
            }
            
            self.assetWriterAudioInput =
            [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeAudio
                                           outputSettings:self.audioSettings];
            
            self.assetWriterAudioInput.expectsMediaDataInRealTime = YES;
            
            if ([self.assetWriter canAddInput:self.assetWriterAudioInput]) {
                [self.assetWriter addInput:self.assetWriterAudioInput];
            }
            else {
                ZSLOG(@"Unable to add audio input.");
            }
            
            self.isWriting = YES;
            self.firstSample = YES;
        }
    });
}

- (NSURL *)uniqueURL {
    NSString *fileName = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *movieDirectory = [NSString stringWithFormat:@"%@/Videos", documentsPath];
    
    BOOL isDirectory;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:movieDirectory isDirectory:&isDirectory]) {
        [fileManager createDirectoryAtPath:movieDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = nil;
    do {
        filePath = [NSString stringWithFormat:@"%@/%@.mp4", movieDirectory, fileName];
    }
    while ([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    return fileURL;
}

- (void)stopRecording {
    dispatch_async([self globalQueue], ^{
        self.isWriting = NO;
        self.startTime = kCMTimeZero;
        self.recordedDuration = 0;
        [self.assetWriter finishWritingWithCompletionHandler: ^{
            if (self.assetWriter.status == AVAssetWriterStatusCompleted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSURL *fileURL = [self.assetWriter outputURL];
                    [self writeVideoToAssetsLibrary:[fileURL copy]];
                    ZSLOG(@"----finish recoding");
                });
                self.outputURL = nil;
            }
            else {
                ZSLOG(@"Failed to write movie: %@", self.assetWriter.error);
            }
        }];
    });
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)                  captureOutput:(AVCaptureFileOutput *)captureOutput
    didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
                        fromConnections:(NSArray *)connections
                                  error:(NSError *)error {
    if (error) {
        [self.delegate mediaCaptureFailedWithError:error];
    }
    else {
        [self writeVideoToAssetsLibrary:[self.outputURL copy]];
    }
    self.outputURL = nil;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    if (bShouldStop == YES) {
        return;
    }
    if (abandonFrameCount++ < ABANDON_FRAME_COUNT) {        //abandon first ABANDON_FRAME_COUNT frames
        ZSLOG(@"abandon %d frame", abandonFrameCount);
        return;
    }
    if (lFrameCount ++ % 5 == 0)
    {
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices)
        {
            if ([device position] == AVCaptureDevicePositionBack)
            {                                   //AVCaptureFocusModeAutoFocus
                //AVCaptureFocusModeContinuousAutoFocus
                if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus] )
                {
                    NSError *error = nil;
                    if ([device lockForConfiguration:&error])
                    {
                        if(bNotLessThan5s) {
                            device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
                        } else {
                            device.focusMode = AVCaptureFocusModeAutoFocus;
                        }
                        
                        if ([device respondsToSelector:@selector(isAutoFocusRangeRestrictionSupported)] && device.autoFocusRangeRestrictionSupported) {
                            device.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNear;
                        }
                        [device unlockForConfiguration];
                    }
                }
            }
        }
        lFrameCount = 1;
        return;
    }
    
    
    __block CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if ([captureOutput isEqual:self.videoDataOutput]) {
        
        if(bInProcessing == NO)
        {
            [self doRec:imageBuffer];
        }
    }
}

- (CIImage*)makeFaceWithCIImage:(CIImage *)inputImage
{
    [self.filter setValue:inputImage forKey:kCIInputImageKey];
    [self.filter setValue:@(MAX(inputImage.extent.size.width, inputImage.extent.size.height) / 60) forKey:kCIInputScaleKey];
    CIImage *fullPixellatedImage = self.filter.outputImage;
    
    CIImage *maskImage;
    for (AVMetadataFaceObject *faceObject in self.faceObjects) {
        CGRect faceBounds = faceObject.bounds;
        CGFloat centerX = inputImage.extent.size.width * (faceBounds.origin.x + faceBounds.size.width/2);
        CGFloat centerY = inputImage.extent.size.height * (1 - faceBounds.origin.y - faceBounds.size.height /2);
        
        CGFloat radius = faceBounds.size.width * inputImage.extent.size.width/1.5;
        
        CIFilter *radialGradient = [CIFilter filterWithName:@"CIRadialGradient" keysAndValues:@"inputRadius0",@(radius),@"inputRadius1",@(radius+1),@"inputColor0",[CIColor colorWithRed:0 green:1 blue:0 alpha:1],@"inputColor1",[CIColor colorWithRed:0 green:0 blue:0 alpha:0],kCIInputCenterKey,[CIVector vectorWithX:centerX Y:centerY], nil];
        
        CIImage *radialGradientOutputImage = [radialGradient.outputImage imageByCroppingToRect:inputImage.extent];
        if (maskImage == nil) {
            maskImage = radialGradientOutputImage;
        }else{
            maskImage = [[CIFilter filterWithName:@"CISourceOverCompositing" keysAndValues:kCIInputImageKey,radialGradientOutputImage,kCIInputBackgroundImageKey,maskImage,nil] outputImage];
        }
    }
    
    CIFilter *blendFilter = [CIFilter filterWithName:@"CIBlendWithMask"];
    [blendFilter setValue:fullPixellatedImage forKey:kCIInputImageKey];
    [blendFilter setValue:inputImage forKey:kCIInputBackgroundImageKey];
    [blendFilter setValue:maskImage forKey:kCIInputMaskImageKey];
    
    return blendFilter.outputImage;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    self.faceObjects = metadataObjects;
}

- (void)writeVideoToAssetsLibrary:(NSURL *)videoURL {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:videoURL]) {
        ALAssetsLibraryWriteVideoCompletionBlock completionBlock;
        
        completionBlock = ^(NSURL *assetURL, NSError *error) {
            if (error) {
                [self.delegate assetLibraryWriteFailedWithError:error];
            }
            else {
                [self generateThumbnailForVideoAtURL:videoURL];
            }
        };
        
        [library writeVideoAtPathToSavedPhotosAlbum:videoURL
                                    completionBlock:completionBlock];
    }
}

- (void)generateThumbnailForVideoAtURL:(NSURL *)videoURL {
    dispatch_async([self globalQueue], ^{
        AVAsset *asset = [AVAsset assetWithURL:videoURL];
        
        AVAssetImageGenerator *imageGenerator =
        [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        imageGenerator.maximumSize = CGSizeMake(100.0f, 0.0f);
        imageGenerator.appliesPreferredTrackTransform = YES;
        
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:kCMTimeZero
                                                     actualTime:NULL
                                                          error:nil];
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postThumbnailNotifification:image];
        });
    });
}

#pragma mark - Recoding Destination URL

- (AVCaptureVideoOrientation)currentVideoOrientation {
    AVCaptureVideoOrientation videoOrientation;
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    switch (deviceOrientation) {
        case UIDeviceOrientationLandscapeLeft:
            videoOrientation = AVCaptureVideoOrientationLandscapeRight;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
            
        case UIDeviceOrientationPortrait:
            videoOrientation = AVCaptureVideoOrientationPortrait;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
            
        default:
            videoOrientation = AVCaptureVideoOrientationPortrait;
            break;
    }
    
    return videoOrientation;
}

CGAffineTransform KSHTransformForDeviceOrientation(UIDeviceOrientation orientation) {
    CGAffineTransform result;
    
    switch (orientation) {
            
        case UIDeviceOrientationLandscapeRight:
            result = CGAffineTransformMakeRotation(M_PI);
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            result = CGAffineTransformMakeRotation((M_PI_2 * 3));
            break;
            
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            result = CGAffineTransformMakeRotation(M_PI_2);
            break;
            
        default: // Default orientation of landscape left
            result = CGAffineTransformIdentity;
            break;
    }
    
    return result;
}

#pragma mark do reco

- (CGRect)getGuideFrame:(CGRect)rect withOrientation:(int)orientation
{
    float previewWidth;
    float previewHeight;
    
    float cardh, cardw;
    float lft, top;
    CGRect r;
    float rate;
    
    if (orientation == UIInterfaceOrientationPortrait) {    //screen portrait
        previewWidth = rect.size.width;
        previewHeight = rect.size.height;
        rate = 0.9f;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){  //screen landscape
        previewWidth = rect.size.height;
        previewHeight = rect.size.width;
        rate = 0.7f;
    } else if (orientation == UIInterfaceOrientationPortrait + ORIENTATION_OFFSET) {    //image portrait
        previewWidth = rect.size.height;
        previewHeight = rect.size.width;
        rate = 0.9f;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft + ORIENTATION_OFFSET ||
               orientation == UIInterfaceOrientationLandscapeRight + ORIENTATION_OFFSET) {  //image landscape
        previewWidth = rect.size.width;
        previewHeight = rect.size.height;
        rate = 0.7f;
    }
    
    cardw = previewWidth*rate;
    cardh = cardw * 0.63084f;
    if (previewHeight < cardh) {
        cardh = previewHeight * 90 / 100;
        cardw = cardh / 0.63084f;
    }
    
    lft = (previewWidth-cardw)/2;
    top = (previewHeight-cardh)/2;
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationLandscapeLeft + ORIENTATION_OFFSET ||
        orientation == UIInterfaceOrientationLandscapeRight + ORIENTATION_OFFSET) {
        r = CGRectMake(lft+rect.origin.x, top+rect.origin.y, cardw, cardh);
    } else {
        r = CGRectMake(top+rect.origin.x, lft+rect.origin.y, cardh, cardw);
    }
    
    return r;
}

CGRect combinRect(CGRect A, CGRect B)
{
    CGFloat t,b,l,r;
    l = fminf(A.origin.x, B.origin.x);
    r = fmaxf(A.size.width+A.origin.x, B.size.width+B.origin.x);
    t = fminf(A.origin.y, B.origin.y);
    b = fmaxf(A.size.height+A.origin.y, B.size.height+B.origin.y);
    
    return CGRectMake(l, t, r-l, b-t);
}

CGRect getCorpCardRect( int width, int height, CGRect guideRect, int charCount)
{
    subRect = rects[0];
    
    int i;
    int nAvgW = 0;
    int nAvgH = 0;
    int nCount = 0;
    //    Rect rect = new Rect(cardInfo.rects[0]);
    nAvgW  = rects[0].size.width;
    nAvgH  = rects[0].size.height;
    nCount = 1;
    //所有非空格的字符的矩形框合并
    for(i = 1; i < charCount; ++i){
        
        //        rect.union(cardInfo.rects[i]);
        subRect = combinRect(subRect, rects[i]);
        if(numbers[i] != ' '){
            nAvgW += rects[i].size.width;
            nAvgH += rects[i].size.height;
            nCount ++;
        }
    }
    //统计得到的平均宽度和高度
    nAvgW /= nCount;
    nAvgH /= nCount;
    
    //releative to the big image（相对于大图）
    subRect.origin.x = subRect.origin.x + guideRect.origin.x;
    subRect.origin.y = subRect.origin.y + guideRect.origin.y;
    //    rect.offset(guideRect.left, guideRect.top);
    //做一个扩展
    subRect.origin.y -= nAvgH;  if(subRect.origin.y < 0) subRect.origin.y = 0;
    subRect.size.height += nAvgH * 2; if(subRect.size.height+subRect.origin.y  >= height) subRect.size.height = height-subRect.origin.y-1;
    subRect.origin.x -= nAvgW; if(subRect.origin.x < 0) subRect.origin.x = 0;
    subRect.size.width += nAvgW * 2; if(subRect.size.width+subRect.origin.x >= width) subRect.size.width = width-subRect.origin.x-1;
    return subRect;
}

int docode(unsigned char *pbBuf, int tLen)
{
    int hic, lwc;
    int i, j, code;
    int x, y, w, h;
    int charCount = 0;
    
    nType = 0;
    nRate = 0;
    nCharNum = 0;
    szBankName[0]=0;
    numbers[0] = 0;
    
    //字符解析，包含空格
    i = 0;
    //nType
    hic = pbBuf[i++]; lwc = pbBuf[i++]; code = (hic<<8)+lwc;
    nType = code;
    //nRate
    hic = pbBuf[i++]; lwc = pbBuf[i++]; code = (hic<<8)+lwc;
    nRate = code;
    
    //bank name, GBK CharSet;
    for(j = 0; j < 64; ++j) { szBankName[j] = pbBuf[i++]; }
    
    //nCharNum
    hic = pbBuf[i++]; lwc = pbBuf[i++]; code = (hic<<8)+lwc;
    nCharNum = code;
    
    //char code and its rect
    while(i < tLen-9){
        //字符的编码unsigned short
        hic = pbBuf[i++]; lwc = pbBuf[i++]; x = (hic<<8)+lwc;
        numbers[charCount] = (char)x;
        //字符的矩形框lft, top, w, h
        hic = pbBuf[i++]; lwc = pbBuf[i++]; x = (hic<<8)+lwc;
        hic = pbBuf[i++]; lwc = pbBuf[i++]; y = (hic<<8)+lwc;
        hic = pbBuf[i++]; lwc = pbBuf[i++]; w = (hic<<8)+lwc;
        hic = pbBuf[i++]; lwc = pbBuf[i++]; h = (hic<<8)+lwc;
        rects[charCount] = CGRectMake(x, y, w, h);
        charCount++;
    }
    numbers[charCount] = 0;
    
    if(charCount < 10 || charCount > 24 || nCharNum != charCount){
        charCount = 0;
    }
    return charCount;
}

- (UIImage*)getSubImage:(CGRect)rect inImage:(UIImage*)img

{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(img.CGImage, rect);
    
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, smallBounds, subImageRef);
    
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CFRelease(subImageRef);
    
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}

- (UIImage*) getImageStream:(CVImageBufferRef)imageBuffer
{
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(imageBuffer),
                                                 CVPixelBufferGetHeight(imageBuffer))];
    
    UIImage *image = [[UIImage alloc] initWithCGImage:videoImage];
    CGImageRelease(videoImage);
    return image;
}



- (void)doRec:(CVImageBufferRef)imageBuffer
{
    @synchronized(self)
    {
        if(bHasResult == YES)
        {
            return;
        }
        
        CVBufferRetain(imageBuffer);
        bInProcessing = YES;
        
        if(CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
        {
            size_t width= CVPixelBufferGetWidth(imageBuffer);
            size_t height = CVPixelBufferGetHeight(imageBuffer);
            
            CVPlanarPixelBufferInfo_YCbCrBiPlanar *planar = CVPixelBufferGetBaseAddress(imageBuffer);
            size_t offset = NSSwapBigIntToHost(planar->componentInfoY.offset);
//            size_t rowBytes = NSSwapBigIntToHost(planar->componentInfoY.rowBytes);
            unsigned char* baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
            unsigned char* pixelAddress = baseAddress + offset;
            
            size_t cbCrOffset = NSSwapBigIntToHost(planar->componentInfoCbCr.offset);
//            size_t cbCrPitch = NSSwapBigIntToHost(planar->componentInfoCbCr.rowBytes);
            uint8_t *cbCrBuffer = baseAddress + cbCrOffset;
            
            CGRect effectRect = [self.recDelegate getEffectImageRect:CGSizeMake(width, height)];
            UIInterfaceOrientation orientation = [self.recDelegate getOrientation];
            CGRect rect = [self getGuideFrame:effectRect withOrientation:orientation + ORIENTATION_OFFSET];
            
            BOOL sufficientFocus = NO;
            float focusScore = GetFocusScore(pixelAddress, (int)width, (int)height, (int)width, rect.origin.x, rect.origin.y, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
            if (focusScore >= MIN_FOCUS_SCORE) {
                sufficientFocus = YES;
            }
            if (sufficientFocus) {
#if 1
                TEXBCard bCard;
                unsigned char *pbImage = NULL;
                int nCardW, nCardH, nStride;
                int direction;
                switch (orientation) {
                    case UIInterfaceOrientationLandscapeRight:
                        direction = EX_ORIENTATION_LANDSCAPE_LEFT;
                        break;
                    case UIInterfaceOrientationLandscapeLeft:
                        direction = EX_ORIENTATION_LANDSCAPE_RIGHT;
                        break;
                    case UIInterfaceOrientationPortrait:
                        direction = EX_ORIENTATION_PORTRAIT;
                        break;
                    default:
                        direction = EX_ORIENTATION_LANDSCAPE_LEFT;
                        break;
                }
                int ret = BankCardNV12ST(&bCard, pixelAddress, cbCrBuffer, (int)width, (int)height, rect.origin.x, rect.origin.y, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height,
                                         direction, 1, 1);
                
                if (ret <= 0){   //failed
                    ZSLOG(@"BANKCardRecApi，ret[%d]", ret);
                }else{          //succeed
                    bHasResult = YES;
                    ZSLOG(@"ret=[%d]", ret);
                    ZSLOG(@"%f", focusScore);
                    
                    bankInfo = [[BankInfo alloc] init];
                    
                    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    bankInfo.bankName = [NSString stringWithCString:(char *)bCard.szBankName encoding:gbkEncoding];
                    bankInfo.cardName = [NSString stringWithCString:(char *)bCard.szCardName encoding:gbkEncoding];
                    bankInfo.cardType = [NSString stringWithCString:(char *)bCard.szCardType encoding:gbkEncoding];
                    char cardNum[32];
                    int i = 0;
                    for (i = 0; i < bCard.nNumCount; i++) {
                        cardNum[i] = bCard.ZInfo[i].wCand;
                    }
                    cardNum[i] = 0;
                    NSString *str;
                    if ([BankInfo getSpaceWithBANKCardNum]) {
                        str = [NSString stringWithCString:cardNum encoding:gbkEncoding];
                    } else {
                        NSString *tmp = [NSString stringWithCString:cardNum encoding:gbkEncoding];
                        NSArray *array = [tmp componentsSeparatedByString:@" "];;
                        str = [array componentsJoinedByString:@""];
                    }
                    bankInfo.cardNum = str;
                    ZSLOG(@"%d/%d",bCard.expiryMonth, bCard.expiryYear);
                    if (bCard.expiryMonth != 0 && bCard.expiryYear != 0) {
                        if (bCard.expiryMonth > 9 && (bCard.expiryYear - 2000) > 9) {
                            bankInfo.validDate = [NSString stringWithFormat:@"%d/%d", bCard.expiryMonth, bCard.expiryYear-2000];
                        } else if (bCard.expiryMonth <= 9 && (bCard.expiryYear - 2000) > 9){
                            bankInfo.validDate = [NSString stringWithFormat:@"0%d/%d", bCard.expiryMonth, bCard.expiryYear-2000];
                        } else if (bCard.expiryMonth > 9 && (bCard.expiryYear - 2000) <= 9){
                            bankInfo.validDate = [NSString stringWithFormat:@"%d/0%d", bCard.expiryMonth, bCard.expiryYear-2000];
                        } else if (bCard.expiryMonth <= 9 && (bCard.expiryYear - 2000) <= 9){
                            bankInfo.validDate = [NSString stringWithFormat:@"0%d/0%d", bCard.expiryMonth, bCard.expiryYear-2000];
                        }
                    } else {
                        bankInfo.validDate = @"0/0";
                    }
                    
                    //convert image
                    nCardW = bCard.nW;
                    nCardH = bCard.nH;
                    nStride= nCardW*4;
                    pbImage = (unsigned char*)malloc(nCardH*nStride);
                    if(pbImage){
                        
                        //缓存图像数据
                        BankCardConvert2ABGR(&bCard, pbImage, nCardW, nCardH, nStride);
                        
                        //获得CGImage
                        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                        CGContextRef context = CGBitmapContextCreate(pbImage, nCardW, nCardH, 8, nStride, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
                        CGImageRef quartzImage = CGBitmapContextCreateImage(context);
                        
                        bankInfo.cardNumImg = [UIImage imageWithCGImage:quartzImage];
                        
                        CFRelease(quartzImage);
                        CGContextRelease(context);
                        CGColorSpaceRelease(colorSpace);
                        
                        free(pbImage);
                    }
                    
                    //银行卡整图
                    UIImage *image = [self getImageStream:imageBuffer];
                    UIImage *corpImage = [self getSubImage:rect inImage:image];
                    bankInfo.fullImg = corpImage;
                    
                    if (0) {
                        UIImageWriteToSavedPhotosAlbum(bankInfo.fullImg, nil, nil, nil);
                    }
                    
                    
                    if (bankInfo!=nil && [bankInfo isOK]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (FILTER_BANK) {
                                if ([self.recDelegate bankIsSupport:bankInfo.bankName]) {
                                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                                    ZSLOG(@"支持，银行名称: %@", bankInfo.bankName);
                                    [self.recDelegate BankCardRecognited:bankInfo];
                                } else {
                                    ZSLOG(@"不支持，银行名称: %@", bankInfo.bankName);
                                    [self.recDelegate setPrompt:PROMPT_NOT_SUPPORT];
                                    [self performSelector:@selector(setDefaultPrompt) withObject:nil afterDelay:1.0f];

                                }
                            } else {
                                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                                [self.recDelegate BankCardRecognited:bankInfo];
                            }
                        });
                    }
                }
                //释放结构体
                BankCardFreeST(&bCard);
#endif
            }
            CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
        }
        bInProcessing = NO;
        CVBufferRelease(imageBuffer);
    }
}

void DrawRect(unsigned char *pY, int w, int h, int lft, int top, int rgt, int btm, int ori)
{
    unsigned char *pLine;
    int i, j;
    int scanline = 0;
    
    if (ori == UIInterfaceOrientationLandscapeRight + ORIENTATION_OFFSET) {
        scanline = top + (btm-top+1)*32/54;
    } else if (ori == UIInterfaceOrientationLandscapeLeft + ORIENTATION_OFFSET){
        scanline = top + (btm-top+1)*22/54;
    } else if (ori == UIInterfaceOrientationPortrait + ORIENTATION_OFFSET) {
        scanline = lft + (rgt-lft+1)*32/54;
    }
    //top line
    pLine = pY + top*w;
    for(j = lft; j < rgt; ++j) pLine[j] = 0x00;
    
    //lft and right line
    for(i = top+1; i < btm; ++i){
        pLine[lft] = 0x00;
        pLine[rgt] = 0x00;
        if (ori == UIInterfaceOrientationPortrait + ORIENTATION_OFFSET) {
            pLine[scanline] = 0x00;
        }
        pLine += w;
    }
    
    //bottom line
    pLine = pY + btm*w;
    for(j = lft; j < rgt; ++j) pLine[j] = 0x00;
    
    //scan line
    if (ori == UIInterfaceOrientationLandscapeRight + ORIENTATION_OFFSET || ori == UIInterfaceOrientationLandscapeLeft + ORIENTATION_OFFSET) {
        pLine = pY + scanline*w;
        for(j = lft; j < rgt; ++j) pLine[j] = 0x00;
    }
}

- (void)setDefaultPrompt
{
    [self resetRecParams]; /*重置参数*/
    [self.recDelegate setPrompt:PROMPT_DEFAULT];
}

- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

#pragma mark 判断手机型号
- (BOOL)NotLessThan5s
{
    NSString *platform = [self getDeviceVersion];
    if([[platform substringWithRange:NSMakeRange(0, 6)]isEqualToString:@"iPhone"]) {
        int version = [[platform substringWithRange:NSMakeRange(6, 1)]intValue];
        if (version >= 6) { //NOT less than iPhone5s
            return true;
        }
    }
    
    return false;
}

#pragma mark 获得设备型号
- (NSString *)getDeviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}
@end
