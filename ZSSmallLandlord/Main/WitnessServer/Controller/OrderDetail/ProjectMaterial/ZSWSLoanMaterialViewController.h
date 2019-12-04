//
//  ZSWSLoanMaterialViewController.h
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  首页--订单列表--订单详情--项目资料--按揭贷款资料

#import "ZSBaseViewController.h"

@interface ZSWSLoanMaterialViewController : ZSBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *contractPriceField; //合同总价

@property (weak, nonatomic) IBOutlet UITextField *loanAmountField;    //贷款金额

@property (weak, nonatomic) IBOutlet UITextField *downPaymentField;   //首付金额

@property (weak, nonatomic) IBOutlet UITextField *loanLimitField;     //贷款年限

@property (weak, nonatomic) IBOutlet UITextField *loanRateField; //贷款利率

@property (weak, nonatomic) IBOutlet UIButton *loanTypeBtn;      //还款方式

@property (weak, nonatomic) IBOutlet UIButton *loanCategoryBtn;  //贷款种类

@property (weak, nonatomic) IBOutlet UIButton *loanBankerBtn;    //贷款银行

@property (weak, nonatomic) IBOutlet UILabel  *loanBankerLabel;  //贷款银行


@property(nonatomic,strong)ProjectInfo *projeftInfo;             //贷款信息model


@end
