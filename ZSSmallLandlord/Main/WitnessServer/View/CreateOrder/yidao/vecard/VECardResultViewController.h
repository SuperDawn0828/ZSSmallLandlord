//
//  IDCardResultController.h
//  EXOCR
//
//  Created by z on 15/7/27.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VeCardInfo.h"


@protocol VERstEditDelegate <NSObject>
- (void)didEndVERstEdit:(NSString*)str from:(id)sender;
- (void)didBackfromVERst:(id)sender;
@end


@interface VECardResultViewController : UIViewController<UITextFieldDelegate>  {
    UIImageView * fullImageView;
    
    UILabel * plateNoLable;
    UITextField * plateNoValue;
    UIImageView * faceImageView;
    
    UILabel * vehicleTypeLabel;
    UITextField * vehicleTypeValueTextField;
  
    UILabel * ownerLabel;
    UITextField * ownerValueTextField;
    
    UILabel * addressLabel;
    UITextField * addressTextField;
    
    UILabel * modelLabel;
    UITextField * modelTextField;
    
    UILabel * useCharacterLabel;
    UITextField * useCharacterTextField;
    
    UILabel * engineNoLabel;
    UITextField * engineNoTextField;
    
    UILabel * VINLabel;
    UITextField * VINValueTextField;
    
    UILabel * registerDateLabel;
    UITextField * registerDateValueTextField;
    
    UILabel * issueDateLabel;
    UITextField * issueDateValueTextField;
    
    
}

@property (nonatomic, weak) id<VERstEditDelegate> delegate;
@property (nonatomic) VeCardInfo * VEInfo;
@end
