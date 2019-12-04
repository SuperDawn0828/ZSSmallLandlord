//
//  ESResultViewController.h
//  EXOCR
//
//  Created by mac on 15/11/5.
//  Copyright © 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankInfo.h"

@protocol ESEditDelegate <NSObject>
- (void)didEndEdit:(NSString*)str from:(id)sender;
- (void)didBackfrom:(id)sender;
@end

@interface ESResultViewController : UIViewController
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

@property (nonatomic, weak) id<ESEditDelegate> delegate;

@property (nonatomic, strong)BankInfo *bankInfo;

@end
