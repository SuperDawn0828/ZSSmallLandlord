//
//  KCResultViewController.h
//  EXOCR
//
//  Created by mac on 15/11/5.
//  Copyright © 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../BankInfo.h"

@interface KCResultViewController : UIViewController
{
    UIImageView * cardImageView;
    
    UILabel * bankNameLable;
    UITextField * bankNameValue;
    
    UILabel * cardNameLabel;
    UITextField * cardNameValue;
    
    UILabel * cardTypeLabel;
    UITextField * cardTypeValue;
    
    UITextView * cardNumView;
    
    UILabel * validLabel;
    UITextField * validValue;
    
    UIButton *okBtn;
}

@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong)BankInfo *bankInfo;

@end
