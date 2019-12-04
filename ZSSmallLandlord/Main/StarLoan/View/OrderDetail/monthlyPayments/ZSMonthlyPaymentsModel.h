//
//  ZSMonthlyPaymentsModel.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/13.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class repayDetails;
@interface ZSMonthlyPaymentsModel : NSObject
@property(nonatomic,copy  )NSString *totalRepay;
@property(nonatomic,strong)NSArray <repayDetails *> *repayDetails;
@end

@interface repayDetails : NSObject
@property(nonatomic,copy  )NSString *sequence;
@property(nonatomic,copy  )NSString *repayAmount;
@end

NS_ASSUME_NONNULL_END
