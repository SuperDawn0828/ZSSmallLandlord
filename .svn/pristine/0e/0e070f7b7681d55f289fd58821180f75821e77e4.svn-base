//
//  ESCameraViewController.h
//  EaseReco
//
//  Created by wangchen on 4/2/15.
//  Copyright (c) 2015 wangchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankInfo.h"

@protocol ESCameraDelegate <NSObject>

- (void)didEndRecBANKWithResult:(BankInfo *)bankInfo from:(id)sender;
@end

@interface ESCameraViewController : UIViewController
{
    NSArray *supportBank;
}

@property (nonatomic, weak) id<ESCameraDelegate> delegate;

- (IBAction)back:(id)sender;
- (IBAction)light:(id)sender;
- (IBAction)logo:(id)sender;
- (IBAction)photo:(id)sender;
@property (nonatomic, strong)BankInfo *bankInfo2;

@end
