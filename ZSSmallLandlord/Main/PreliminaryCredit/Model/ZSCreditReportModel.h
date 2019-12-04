//
//  ZSCreditReportModel.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/7/18.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSCreditReportModel : NSObject
@property (nonatomic , copy  )  NSString                  * canLoan;              //是否可贷 1可贷 2不可待
@property (nonatomic , copy  )  NSString                  * custQualification;    //用户资质 1A 2B 3C 4D D类为不可贷款
@property (nonatomic , copy  )  NSString                  * evaluationAmount;     //房产评估价
@property (nonatomic , copy  )  NSString                  * maxCreditLimit;       //最高可贷额
@property (nonatomic , copy  )  NSString                  * loanBankId;           //贷款银行
@property (nonatomic , copy  )  NSString                  * loanRate;             //贷款利率
@property (nonatomic , copy  )  NSString                  * remark;               //备注
@property (nonatomic , copy  )  NSString                  * customerManager;      //专属客户经理ID
@end
