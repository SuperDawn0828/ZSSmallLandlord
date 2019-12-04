//
//  IDCardViewController.m
//  idcard
//
//  Created by hxg on 14-10-10.
//  Copyright (c) 2014年 hxg. All rights reserved.
//
@import MobileCoreServices;
@import ImageIO;
#import "VECardViewController.h"
#import "./camera/VECameraController.h"
#import "./camera/VEFrameView.h"
#import "VeCardInfo.h"
#import "photo/VEPhoto.h"
#import "photo/VEPhotoViewController.h"
#import "../cardcore/DictManager.h"

@interface VECardViewController ()<VERecDelegate, VEPhotoDelegate, UIAlertViewDelegate>
{
    CGRect  frameBounders;
    UILabel *supportLabel;
}
@property (nonatomic, strong) VECameraController *cameraController;
@property (nonatomic, strong) VEFrameView        *frameView;
@property (nonatomic, strong) IBOutlet UIButton  *logoBtn;
@property (nonatomic, strong) IBOutlet UIButton  *photoBtn;
@property (nonatomic, strong) VEPhoto            *photo;
@property (nonatomic, assign) BOOL               bphotoReco;
@end

@implementation VECardViewController
@synthesize     VECamDelegate;
@synthesize     photo;
@synthesize     bphotoReco;

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

CGRect getVEPreViewFrame( int previewWidth, int previewHeight)
{
    float cardh, cardw;
    float lft, top;
    
    //cardw = previewWidth*70/100;
    if (IS_IPHONE) {
        cardw = previewWidth*95/100;
    } else {
        cardw = previewWidth*80/100;
    }
    if(previewWidth < cardw)
        cardw = previewWidth;
    
    cardh = (float)(cardw / 0.63084f);
    
    lft = (previewWidth-cardw)/2;
    top = (previewHeight-cardh)/2;
    CGRect r = CGRectMake(lft, top+25, cardw, cardh);
    return r;
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
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    self.cameraController.bShouldStop = NO;
    
    if (![DictManager hasInit]) {
        if([self.cameraController.captureSession isRunning])
        {
            [self.cameraController.captureSession stopRunning];
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"识别核心初始化失败，请检查授权并重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if([self.cameraController.captureSession isRunning] == NO && bphotoReco == NO)
    {
        [self.cameraController.captureSession startRunning];
        [self.cameraController resetRecParams];
    }
}

- (VECameraController *)cameraController {
    if (!_cameraController) {
        _cameraController = [[VECameraController alloc] init];
    }
    return _cameraController;
}

- (VEFrameView*)frameView
{
    if(!_frameView)
    {
        CGRect rect = getVEPreViewFrame(frameBounders.size.width, frameBounders.size.height);
        _frameView = [[VEFrameView alloc] initWithFrame:rect];
    }
    return _frameView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)dealloc {
    [self.frameView.timer invalidate];
    [self.frameView.line_timer invalidate];
    self.frameView.timer = nil;
    self.frameView.line_timer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"";
    frameBounders = [UIScreen mainScreen].bounds;
    
    [self.view insertSubview:self.frameView atIndex:0];
    
    float viewAlpha = 0.5;
    
    CGRect frameRct = getVEPreViewFrame(frameBounders.size.width, frameBounders.size.height);
    CGRect topFrame =  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, frameRct.origin.y);
    
    UIView * uiTop = [[UIView alloc] initWithFrame:topFrame];
    [uiTop setBackgroundColor:ZSColorBlack];
    uiTop.alpha = viewAlpha;
    [self.view insertSubview:uiTop atIndex:0];
    
    CGRect leftFrame =  CGRectMake(0, frameRct.origin.y, frameRct.origin.x, frameRct.size.height);
    UIView * uiLeft = [[UIView alloc] initWithFrame:leftFrame];
    [uiLeft setBackgroundColor:ZSColorBlack];
    uiLeft.alpha = viewAlpha;
    [self.view insertSubview:uiLeft atIndex:0];
    
    CGRect rightFrame =  CGRectMake(frameRct.origin.x + frameRct.size.width, frameRct.origin.y , frameBounders.size.width - (frameRct.origin.x + frameRct.size.width), frameRct.size.height);
    
    UIView * uiRight = [[UIView alloc] initWithFrame:rightFrame];
    [uiRight setBackgroundColor:ZSColorBlack];
    uiRight.alpha = viewAlpha;
    [self.view insertSubview:uiRight atIndex:0];
    
    CGRect bottomFrame =  CGRectMake(0, frameRct.origin.y + frameRct.size.height, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height - (frameRct.origin.y + frameRct.size.height ) );
    
    UIView * uiBottom = [[UIView alloc] initWithFrame:bottomFrame];
    [uiBottom setBackgroundColor:ZSColorBlack];
    uiBottom.alpha = viewAlpha;
    [self.view insertSubview:uiBottom atIndex:0];
    
    _photoBtn.center = CGPointMake(ZSWIDTH/2, _photoBtn.center.y);
    bphotoReco = NO;
    
    if (DISPLAY_LOGO_VE) {
        supportLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ZSHEIGHT, 50)];
        supportLabel.backgroundColor = [UIColor clearColor];
        supportLabel.textAlignment = NSTextAlignmentCenter;
        supportLabel.textColor = [UIColor lightGrayColor];
        supportLabel.font = [UIFont boldSystemFontOfSize:16];
        supportLabel.text = SUPPORT_INFO;
        [self.view addSubview:supportLabel];
        
        CGAffineTransform transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        supportLabel.transform = transform;
        supportLabel.center = CGPointMake(20, ZSHEIGHT/2);
    } else {
        _logoBtn.hidden = YES;
    }
    
    self.cameraController.recDelegate = self;
    //    [self.view insertSubview:self.previewView atIndex:0];
    
    self.cameraController.sessionPreset = AVCaptureSessionPreset1280x720;
    
    //    self.overlayView.session = self.cameraController.captureSession;
    
    NSError *error;
    if ([self.cameraController setupSession:&error]) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        
        [self.view insertSubview:view atIndex:0];
        AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.cameraController.captureSession];
        preLayer.frame = frameBounders;// CGRectMake(0, 0, 320, 240);
        preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [view.layer addSublayer:preLayer];
        
        [self.cameraController startSession];
    }
    else {
        ZSLOG(@"%@", error.localizedDescription);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (CGRect)getEffectImageRect:(CGSize)size
{
    //    CGSize size = image.extent.size;
    //    CGSize size2 = frameBounders.size;
    CGSize size2 = CGSizeMake(frameBounders.size.height, frameBounders.size.width);
    CGPoint pt;
    if(size.width/size.height > size2.width/size2.height)
    {
        float oldW = size.width;
        size.width = size2.width / size2.height * size.height;
        pt.x = (oldW - size.width)/2;
        pt.y = 0;
    }
    else
    {
        float oldH = size.height;
        size.height = size2.height / size2.width * size.width;
        pt.x = 0;
        pt.y = (oldH - size.height)/2;;
    }
    return CGRectMake(pt.x, pt.y, size.width, size.height);
}

- (void)showRecError:(NSString*)str
{
    //errorLabel.text = str;
}


- (void)VECardRecognited:(VeCardInfo*)veInfo
{
    self.cameraController.bHasResult = TRUE;
    self.cameraController.bShouldStop = YES;
    [self.frameView.timer invalidate];
    [self.frameView.line_timer invalidate];
    self.frameView.timer = nil;
    self.frameView.line_timer = nil;
    
    //用户退出时，可能核心正在识别。此段代码目的为 防止退出时，发生崩溃
    for (int i = 0; i < 50; i++) {
        if (self.cameraController.bInProcessing == true) {
            [NSThread sleepForTimeInterval:0.2];
        }else{
            break;
        }
    }
    
    [VECamDelegate didEndRecVEWithResult:veInfo from:self];
    
}


- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backAc:(id)sender {
    //self.cameraController.bHasResult = TRUE;
    self.cameraController.bShouldStop = YES;
    [self.frameView.timer invalidate];
    [self.frameView.line_timer invalidate];
    self.frameView.timer = nil;
    self.frameView.line_timer = nil;
    
    //用户退出时，可能核心正在识别。此段代码目的为 防止退出时，发生崩溃
    for (int i = 0; i < 50; i++) {
        if (self.cameraController.bInProcessing == true) {
            [NSThread sleepForTimeInterval:0.2];
        }else{
            break;
        }
    }
    
    //    IDCardResultViewController * IDRstVc = [[IDCardResultViewController alloc] init];
    //    IDRstVc.IDInfo = nil;
    //    //IDRstVc.delegate =self;
    //    //[self presentViewController:editVc animated:YES completion:nil];
    //    [self.navigationController pushViewController:IDRstVc animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)lightAc:(id)sender {
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

- (IBAction)photo:(id)sender {
    bphotoReco = YES;
    self.cameraController.bHasResult = YES;
    self.cameraController.bShouldStop = YES;
    if([self.cameraController.captureSession isRunning])
    {
        [self.cameraController.captureSession stopRunning];
    }
    ZSLOG(@"VE Photo");
    if(![self.cameraController.captureSession isRunning]) {
        self.photo = [[VEPhoto alloc] init];
        ((VEPhoto *)self.photo).target = self;
        ((VEPhoto *)self.photo).delegate = self;
        [self.photo photoReco];
    }
}

#pragma mark - VEPhotoDelegate
- (void)didEndPhotoRecVEWithResult:(VeCardInfo *)veInfo from:(id)sender
{
    if (![VeCardInfo getNoShowVEResultView]) {
        VEPhotoViewController *vec = [[VEPhotoViewController alloc] init];
        vec.VEInfo = veInfo;
        [self.navigationController pushViewController:vec animated:YES];
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
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
