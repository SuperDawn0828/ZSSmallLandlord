//
//  ESCameraViewController.m
//  EaseReco
//
//  Created by wangchen on 4/2/15.
//  Copyright (c) 2015 wangchen. All rights reserved.
//

#import "ESCameraViewController.h"
#import "KSHCameraController.h"
//#import "KSHPreviewView.h"
#import "KSHContextManager.h"
//#import "KSHOverlayView.h"
#import "KSFrameView.h"
#import "BankInfo.h"
#import "photo/KCPhoto.h"
#import "photo/KCResultViewController.h"

@interface ESCameraViewController ()
<KSHRecDelegate, KCPhotoDelegate, UIAlertViewDelegate>
{
    CGRect frameBounders;
    UIInterfaceOrientation orientation;
}

@property (nonatomic, strong) KSHCameraController *cameraController;
//@property (strong, nonatomic) KSHPreviewView *previewView;
@property (strong, nonatomic) KSFrameView *frameView;
//@property (weak, nonatomic) IBOutlet KSHOverlayView *overlayView;
@property(nonatomic, strong) IBOutlet UIButton *logoBtn;
@property(nonatomic, strong) IBOutlet UIButton *backBtn;
@property(nonatomic, strong) IBOutlet UIButton *flashBtn;
@property(nonatomic, strong) IBOutlet UIButton *photoBtn;
@property(nonatomic, strong) UIView *uiTop;
@property(nonatomic, strong) UIView *uiLeft;
@property(nonatomic, strong) UIView *uiRight;
@property(nonatomic, strong) UIView *uiBottom;
@property(nonatomic, strong) KCPhoto *photo;
@property(nonatomic, assign) BOOL bphotoReco;
@end

@implementation ESCameraViewController
@synthesize delegate;
@synthesize photo;
@synthesize bphotoReco;
@synthesize bankInfo2;

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    if([self.cameraController.captureSession isRunning])
    {
        [self.cameraController.captureSession stopRunning];
    }
    [super viewDidDisappear: animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    if([self.cameraController.captureSession isRunning])
    {
        [self.cameraController.captureSession stopRunning];
    }
    [super viewWillDisappear:animated];
}



- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.cameraController.bShouldStop = NO;
    self.navigationController.navigationBarHidden = YES;
    if([self.cameraController.captureSession isRunning] == NO && bphotoReco == NO)
    {
        [self.cameraController.captureSession startRunning];
        [self.cameraController resetRecParams];
    }
    [super viewWillAppear:animated];
}


- (KSHCameraController *)cameraController {
    if (!_cameraController) {
        _cameraController = [[KSHCameraController alloc] init];
    }
    return _cameraController;
}

- (KSFrameView*)frameView
{
    if(!_frameView)
    {
        CGRect rect = [self.cameraController getGuideFrame:frameBounders withOrientation:orientation];
        _frameView = [[KSFrameView alloc] initWithFrame:rect];
    }
    return _frameView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)dealloc {
    [self.frameView.timer invalidate];
    self.frameView.timer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ZSLOG(@"BankCard Version:%@", [NSString stringWithCString:BankCardGetVersion()]);
    self.navigationItem.title = @"";
    frameBounders = [UIScreen mainScreen].bounds;
    orientation = UIInterfaceOrientationPortrait;
    
    if (FILTER_BANK) {
        //初始化支持的银行
        supportBank = @[@"中国银行", @"中国工商银行", @"中国建设银行", @"中国民生银行", @"招商银行", @"中国农业银行", @"中国邮政储蓄银行有限责任公司", @"中信银行", @"中国光大银行", @"华夏银行", @"广东发展银行", @"平安银行股份有限公司", @"兴业银行", @"上海浦东发展银行"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    self.cameraController.recDelegate = self;
    self.cameraController.sessionPreset = AVCaptureSessionPreset1280x720;
    
    [self createUI];
    bphotoReco = NO;
    
    NSError *error;
    if ([self.cameraController setupSession:&error]) {
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        
        [self.view insertSubview:view atIndex:0];
        AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.cameraController.captureSession];
        preLayer.frame = frameBounders;
        preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [view.layer addSublayer:preLayer];
        
        [self.cameraController startSession];
    }
    else {
        ZSLOG(@"%@", error.localizedDescription);
    }
    
}

- (void)createUI
{
        orientation = [self getCurrentOrientation];
    
    [self.view insertSubview:self.frameView atIndex:0];
    [self.frameView loadUI:orientation];
    
    float viewAlpha = 0.5;
    CGRect frameRct = [self.cameraController getGuideFrame:frameBounders withOrientation:orientation];
    
    CGRect topFrame =  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, frameRct.origin.y);
    _uiTop = [[UIView alloc] initWithFrame:topFrame];
    [_uiTop setBackgroundColor:ZSColorBlack];
    _uiTop.alpha = viewAlpha;
    [self.view insertSubview:_uiTop atIndex:0];
    
    CGRect leftFrame =  CGRectMake(0, frameRct.origin.y, frameRct.origin.x, frameRct.size.height);
    _uiLeft = [[UIView alloc] initWithFrame:leftFrame];
    [_uiLeft setBackgroundColor:ZSColorBlack];
    _uiLeft.alpha = viewAlpha;
    [self.view insertSubview:_uiLeft atIndex:0];
    
    CGRect rightFrame =  CGRectMake(frameRct.origin.x + frameRct.size.width, frameRct.origin.y , frameBounders.size.width - (frameRct.origin.x + frameRct.size.width), frameRct.size.height);
    _uiRight = [[UIView alloc] initWithFrame:rightFrame];
    [_uiRight setBackgroundColor:ZSColorBlack];
    _uiRight.alpha = viewAlpha;
    [self.view insertSubview:_uiRight atIndex:0];
    
    CGRect bottomFrame =  CGRectMake(0, frameRct.origin.y + frameRct.size.height, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height - (frameRct.origin.y + frameRct.size.height ) );
    _uiBottom = [[UIView alloc] initWithFrame:bottomFrame];
    [_uiBottom setBackgroundColor:ZSColorBlack];
    _uiBottom.alpha = viewAlpha;
    [self.view insertSubview:_uiBottom atIndex:0];
    
    _photoBtn.center = CGPointMake(ZSWIDTH/2, _photoBtn.center.y);
    //    [self rotateBtn];
    
    if (!DISPLAY_LOGO_BANK) {
        _logoBtn.hidden = YES;
    }
}

- (void)deviceOrientationDidChange {
        orientation = [self getCurrentOrientation];
    [self reloadUI];
}

- (UIInterfaceOrientation)getCurrentOrientation
{
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            return UIInterfaceOrientationPortrait;
        case UIDeviceOrientationLandscapeLeft:
            return UIInterfaceOrientationLandscapeRight;
        case UIDeviceOrientationLandscapeRight:
            return UIInterfaceOrientationLandscapeLeft;
        default:
            return orientation;
    }
}

- (void)reloadUI
{
    CGRect frameRct = [self.cameraController getGuideFrame:frameBounders withOrientation:orientation];
    
    self.frameView.frame = frameRct;
    [self.frameView loadUI:orientation];
    [self.frameView setNeedsDisplay];
    
    CGRect topFrame =  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, frameRct.origin.y);
    _uiTop.frame = topFrame;
    
    CGRect leftFrame =  CGRectMake(0, frameRct.origin.y, frameRct.origin.x, frameRct.size.height);
    _uiLeft.frame = leftFrame;
    
    CGRect rightFrame =  CGRectMake(frameRct.origin.x + frameRct.size.width, frameRct.origin.y , frameBounders.size.width - (frameRct.origin.x + frameRct.size.width), frameRct.size.height);
    _uiRight.frame = rightFrame;
    
    CGRect bottomFrame =  CGRectMake(0, frameRct.origin.y + frameRct.size.height, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height - (frameRct.origin.y + frameRct.size.height ) );
    _uiBottom.frame = bottomFrame;
    
        [self rotateBtn];
}

- (void)rotateBtn
{
    float rotate;
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            rotate = 0.0f;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotate = 270.0f;
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotate = 90.0f;
            break;
        default:
            rotate = 0.0f;
            break;
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation((rotate * M_PI) / 180.0f);
    _logoBtn.transform = transform;
    _flashBtn.transform = transform;
    _backBtn.transform = transform;
    _photoBtn.transform = transform;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)back:(id)sender
{
    [self.frameView.timer invalidate];
    self.frameView.timer = nil;
    
    self.cameraController.bShouldStop = YES;
    //用户退出时，可能核心正在识别。此段代码目的为 防止退出时，发生崩溃
    for (int i = 0; i < 50; i++) {
        if (self.cameraController.bInProcessing == YES) {
            [NSThread sleepForTimeInterval:0.2];
        }else{
            break;
        }
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)light:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if(btn.selected == NO)
    {
        btn.selected = YES;
        self.cameraController.torchMode = AVCaptureTorchModeOn;
    }
    else
    {
        btn.selected = NO;
        self.cameraController.torchMode = AVCaptureTorchModeOff;
        
    }
}

- (IBAction)logo:(id)sender {
}

- (IBAction)photo:(id)sender {
    bphotoReco = YES;
    self.cameraController.bHasResult = YES;
    self.cameraController.bShouldStop = YES;
    if([self.cameraController.captureSession isRunning])
    {
        [self.cameraController.captureSession stopRunning];
    }
    ZSLOG(@"Bank Photo");
    if(![self.cameraController.captureSession isRunning]) {
        self.photo = [[KCPhoto alloc] init];
        ((KCPhoto *)self.photo).target = self;
        ((KCPhoto *)self.photo).delegate = self;
        [self.photo photoReco];
    }
}

#pragma mark - KSHRecDelegate
- (CGRect)getEffectImageRect:(CGSize)ImageSize
{
    CGSize ScreenSize = CGSizeMake(frameBounders.size.height, frameBounders.size.width);
    CGPoint pt;
    if(ImageSize.width/ImageSize.height > ScreenSize.width/ScreenSize.height)
    {
        float oldW = ImageSize.width;
        ImageSize.width = ScreenSize.width / ScreenSize.height * ImageSize.height;
        pt.x = (oldW - ImageSize.width)/2;
        pt.y = 0;
    }
    else
    {
        float oldH = ImageSize.height;
        ImageSize.height = ScreenSize.height / ScreenSize.width * ImageSize.width;
        pt.x = 0;
        pt.y = (oldH - ImageSize.height)/2;;
    }
    return CGRectMake(pt.x, pt.y, ImageSize.width, ImageSize.height);
}

- (UIInterfaceOrientation)getOrientation
{
    return orientation;
}

- (void)showRecError:(NSString*)str
{
    //    errorLabel.text = str;
}

- (void)BankCardRecognited:(BankInfo *)bankInfo
{
    self.cameraController.bShouldStop = YES;
    [self.frameView.timer invalidate];
    self.frameView.timer = nil;
    
    //用户退出时，可能核心正在识别。此段代码目的为 防止退出时，发生崩溃
    for (int i = 0; i < 50; i++) {
        if (self.cameraController.bInProcessing == true) {
            [NSThread sleepForTimeInterval:0.2];
        }else{
            break;
        }
    }
    [delegate didEndRecBANKWithResult:bankInfo from:self];
}

- (BOOL)bankIsSupport:(NSString *)bankName
{
    for(NSString *str in supportBank) {
        if([bankName rangeOfString:str].location == 0 && [bankName rangeOfString:str].length == str.length) {
            return YES;
        }
    }
    
    return NO;
}

- (void)setPrompt:(NSString *)prompt
{
    _frameView.promptLabel.text = prompt;
}

#pragma mark- KSHPreviewViewDelegate
- (void)tappedToFocusAtPoint:(CGPoint)point {
    [self.cameraController focusAtPoint:point];
}

- (void)tappedToResetFocusAndExposure {
    [self.cameraController resetFocusAndExposureModes];
}

- (void)tappedToExposeAtPoint:(CGPoint)point {
}

#pragma mark - KCPhotoDelegate
- (void)didEndPhotoRecBANKWithResult:(BankInfo *)bankInfo Image:(UIImage *)image from:(id)sender
{
    if (![BankInfo getNoShowBANKResultView]) {
        bankInfo2=bankInfo;
        ZSLOG(@" =%@==%@==%@=%@==%@==%@",bankInfo2.cardName,bankInfo.fullImg,bankInfo.bankName,bankInfo.cardName,bankInfo.cardNum,image);
        ZSLOG(@"点击了银行卡的识别");
        ZSLOG(@"bankInfo=====%@",bankInfo);
        [USER_DEFALT setObject:bankInfo.cardNum forKey:@"bankInfo.cardNum"];
        
        //        KCResultViewController *evc = [[KCResultViewController alloc] init];
        //        evc.bankInfo = bankInfo;
        //        evc.img = image;
        //        [self.navigationController pushViewController:evc animated:YES];
        //        [USER_DEFALT setObject:bankInfo forKey:@"bankInfo"];
        [self.navigationController popViewControllerAnimated:NO];
    }
}
- (void)didFinishPhotoRec
{
    bphotoReco = NO;
    if([self.cameraController.captureSession isRunning] == NO && bphotoReco == NO)
    {
        [self.cameraController.captureSession startRunning];
        [self.cameraController resetRecParams];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}
@end
