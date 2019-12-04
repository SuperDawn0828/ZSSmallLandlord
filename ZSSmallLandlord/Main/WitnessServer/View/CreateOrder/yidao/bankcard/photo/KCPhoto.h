//
//  KCPhoto.h
//  EXOCR
//
//  Created by mac on 15/9/21.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BankInfo.h"

@protocol KCPhotoDelegate <NSObject>
@required
- (void)didEndPhotoRecBANKWithResult:(BankInfo *)bankInfo Image:(UIImage *)image from:(id)sender;
@optional
- (void)didFinishPhotoRec;

@end

@interface KCPhoto : NSObject <UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property(nonatomic, weak)UIViewController *target;

- (void) photoReco;

@property (nonatomic, weak) id<KCPhotoDelegate> delegate;

@end
