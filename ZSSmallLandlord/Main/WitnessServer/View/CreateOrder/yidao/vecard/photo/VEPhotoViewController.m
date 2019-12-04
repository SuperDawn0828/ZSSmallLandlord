//
//  VEPhotoViewController.m
//  EXOCR
//
//  Created by mac on 15/9/21.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "VEPhotoViewController.h"

#define UIColorFromRGBA(rgbValue,al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

@interface VEPhotoViewController ()

@end

@implementation VEPhotoViewController
@synthesize VEInfo;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundColor:UIColorFromRGBA(0xf0eff5,1)];
    self.navigationItem.title = @"行驶证信息";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    UIScrollView * scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0,20, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [scr setBackgroundColor:[UIColor grayColor]];
    scr.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 2);
    [self.view addSubview: scr];
    float lastY = 5;
    
    if (VEInfo.fullImg != nil) {    //无识别结果
        //未识别图片
        UILabel *fullBackground = [[UILabel alloc]initWithFrame:CGRectMake(20-0.5, lastY-0.5, SCREEN_WIDTH-20-20+0.5*2, (SCREEN_WIDTH-20-20)*0.632+0.5*2)];
        fullBackground.backgroundColor = ZSColorWhite;
        fullBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        fullBackground.layer.borderWidth = 0.5;
        [scr addSubview:fullBackground];
        
        fullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, lastY, SCREEN_WIDTH-20-20, (SCREEN_WIDTH-20-20) * 0.632)];
        fullImageView.image = VEInfo.fullImg;
        [scr addSubview:fullImageView];
        lastY = lastY + (SCREEN_WIDTH-20-20) * 0.632 + 20;
    }
    //号牌号码
    if (![VeCardInfo getNoShowVEplateNo]) {
        plateNoLable = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        plateNoLable.text = @"号牌号码";
        
        [scr addSubview: plateNoLable];
        lastY = lastY + plateNoLable.bounds.size.height + 3;
        
        plateNoValue = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        plateNoValue.text = VEInfo.plateNo;
        [scr addSubview:plateNoValue];
        lastY = lastY + plateNoValue.bounds.size.height + 3;
    }
    //车辆类型
    if (![VeCardInfo getNoShowVEvehicleType]) {
        vehicleTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        vehicleTypeLabel.text = @"车辆型号";
        [scr addSubview: vehicleTypeLabel];
        lastY = lastY + vehicleTypeLabel.bounds.size.height + 3;
        
        vehicleTypeValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        vehicleTypeValueTextField.text = VEInfo.vehicleType;
        [scr addSubview:vehicleTypeValueTextField];
        lastY = lastY + vehicleTypeValueTextField.bounds.size.height + 3;
    }
    //所有人
    if (![VeCardInfo getNoShowVEowner]) {
        ownerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        ownerLabel.text = @"所有人";
        [scr addSubview: ownerLabel];
        lastY = lastY + ownerLabel.bounds.size.height + 3;
        
        ownerValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        ownerValueTextField.text = VEInfo.owner;
        [scr addSubview:ownerValueTextField];
        lastY = lastY + ownerValueTextField.bounds.size.height + 3;
    }
    //住址
    if (![VeCardInfo getNoShowVEaddress]) {
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        addressLabel.text = @"住址";
        [scr addSubview: addressLabel];
        lastY = lastY + addressLabel.bounds.size.height + 3;
        
        addressTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        addressTextField.text = VEInfo.address;
        [scr addSubview: addressTextField];
        lastY = lastY + addressTextField.bounds.size.height + 3;
    }
    //使用性质
    if (![VeCardInfo getNoShowVEuseCharacter]) {
        useCharacterLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        useCharacterLabel.text = @"使用性质";
        [scr addSubview: useCharacterLabel];
        lastY = lastY + useCharacterLabel.bounds.size.height + 3;
        
        useCharacterTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        useCharacterTextField.text = VEInfo.useCharacter;
        [scr addSubview:useCharacterTextField];
        lastY = lastY + useCharacterTextField.bounds.size.height + 3;
    }
    //品牌型号
    if (![VeCardInfo getNoShowVEmodel]) {
        modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        modelLabel.text = @"品牌型号";
        [scr addSubview: modelLabel];
        lastY = lastY + modelLabel.bounds.size.height + 3;
        
        modelTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        modelTextField.text = VEInfo.model;
        [scr addSubview:modelTextField];
        lastY = lastY + modelTextField.bounds.size.height + 3;
    }
    //车辆识别代码
    if (![VeCardInfo getNoShowVEvin]) {
        VINLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        VINLabel.text = @"车辆识别代码";
        [scr addSubview: VINLabel];
        lastY = lastY + VINLabel.bounds.size.height + 3;
        
        VINValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        VINValueTextField.text = VEInfo.VIN;
        [scr addSubview:VINValueTextField];
        lastY = lastY + VINValueTextField.bounds.size.height + 3;
    }
    //发动机号
    if (![VeCardInfo getNoShowVEengineNo]) {
        engineNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        engineNoLabel.text = @"发动机号码";
        [scr addSubview: engineNoLabel];
        lastY = lastY + engineNoLabel.bounds.size.height + 3;
        
        engineNoTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        engineNoTextField.text = VEInfo.engineNo;
        [scr addSubview:engineNoTextField];
        lastY = lastY + engineNoTextField.bounds.size.height + 3;
    }
    //注册日期
    if (![VeCardInfo getNoShowVEregisterDate]) {
        registerDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        registerDateLabel.text = @"注册日期";
        [scr addSubview: registerDateLabel];
        lastY = lastY + registerDateLabel.bounds.size.height + 3;
        
        registerDateValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        registerDateValueTextField.text = VEInfo.registerDate;
        [scr addSubview:registerDateValueTextField];
        lastY = lastY + registerDateValueTextField.bounds.size.height + 3;
    }
    //发证日期
    if (![VeCardInfo getNoShowVEissueDate]) {
        issueDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        issueDateLabel.text = @"发证日期";
        [scr addSubview: issueDateLabel];
        lastY = lastY + issueDateLabel.bounds.size.height + 3;
        
        issueDateValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, lastY, SCREEN_WIDTH - 10, 30)];
        issueDateValueTextField.text = VEInfo.issueDate;
        [scr addSubview:issueDateValueTextField];
        lastY = lastY + issueDateValueTextField.bounds.size.height + 3;
    }
    
    for (UIView *subView in self.view.subviews) {
        for (id controll in subView.subviews)
        {
            if ([controll isKindOfClass:[UITextField class]])
            {
                [controll setBackgroundColor:ZSColorWhite];
                [controll setDelegate:self];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
 

@end