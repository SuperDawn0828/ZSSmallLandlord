//
//  VECardViewController.h
//  idcard
//
//  Created by hxg on 14-10-10.
//  Copyright (c) 2014年 hxg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeCardInfo.h"

@protocol VECamCotrllerDelegate <NSObject>
- (void)didEndRecVEWithResult:(VeCardInfo* ) VEInfo from:(id)sender;
@end

@interface VECardViewController : ZSBaseViewController
{
    UIView         *_cameraView;
    unsigned char* _buffer;
    UILabel *plateNoLabel; //号牌号码
    UILabel *vehicleTypeLabel; //车辆类型
    UILabel *ownerLabel; //所有人
    UILabel *addressLabel; //住址
    UILabel *modelLabel; //品牌型号
    UILabel *useCharacterLabel; //使用性质
    UILabel *engineNoLabel; //发动机号
    UILabel *VINLabel; //车辆识别代码
    UILabel *registerDateLabel; //注册日期
    UILabel *issueDateLabel; //发证日期
}
- (IBAction)backAc:(id)sender;
- (IBAction)lightAc:(id)sender;
- (IBAction)photo:(id)sender;

@property (nonatomic, weak) id<VECamCotrllerDelegate> VECamDelegate;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic)BOOL             verify;
@end
