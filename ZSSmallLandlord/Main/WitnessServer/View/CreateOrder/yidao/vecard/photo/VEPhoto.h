//
//  VEPhoto.h
//  EXOCR
//
//  Created by mac on 15/9/21.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VeCardInfo;
@protocol VEPhotoDelegate <NSObject>
@required
- (void)didEndPhotoRecVEWithResult:(VeCardInfo *)veInfo from:(id)sender;
@optional
- (void)didFinishPhotoRec;
@end

@interface VEPhoto : NSObject <UIImagePickerControllerDelegate>

@property(nonatomic, weak)UIViewController *target;

- (void) photoReco;

@property (nonatomic, weak) id<VEPhotoDelegate> delegate;
@end
