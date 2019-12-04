//
//  ZSOrderDetailModel.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/10.
//  Copyright © 2018年 maven. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CustomersModel,OrderModel,WarrantImg,AgentPrecredit;

@interface ZSPCOrderDetailModel : NSObject

@property (nonatomic , strong)  AgentPrecredit              * agentPrecredit; //预授信报告

@property (nonatomic , strong)  NSArray<CustomersModel *>   * customers;   //人员信息列表

@property (nonatomic , strong)  OrderModel                  * order;       //订单信息,房产信息,贷款信息

@property (nonatomic , strong)  NSArray<WarrantImg *>       * warrantImg;  //不动产权证

@end



//预授信报告
@interface AgentPrecredit : NSObject
@property (nonatomic , copy  )  NSString                  * tid;                  //id
@property (nonatomic , copy  )  NSString                  * prdType;              //产品类型
@property (nonatomic , copy  )  NSString                  * orderId;              //订单id
@property (nonatomic , copy  )  NSString                  * custName;             //客户姓名
@property (nonatomic , copy  )  NSString                  * identityNo;           //身份证
@property (nonatomic , copy  )  NSString                  * evaluationAmount;     //房产评估价
@property (nonatomic , copy  )  NSString                  * canLoan;              //是否可贷 1可贷 2不可待
@property (nonatomic , copy  )  NSString                  * maxCreditLimit;       //最高可贷额
@property (nonatomic , copy  )  NSString                  * custQualification;    //用户资质 1A 2B 3C
@property (nonatomic , copy  )  NSString                  * remark;               //备注
@property (nonatomic , copy  )  NSString                  * createDate;           //预授信报告生成时间
@end


//人员信息
@interface CustomersModel : NSObject
@property (nonatomic , copy  )  NSString                  * tid;            //id
@property (nonatomic , copy  )  NSString                  * name;           //姓名
@property (nonatomic , copy  )  NSString                  * cellphone;      //手机号
@property (nonatomic , copy  )  NSString                  * identityNo;     //
@property (nonatomic , copy  )  NSString                  * birthdate;      //身份证号
@property (nonatomic , copy  )  NSString                  * sex;            //
@property (nonatomic , copy  )  NSString                  * identityPos;    //身份证正面
@property (nonatomic , copy  )  NSString                  * identityBak;    //身份证盘面
@property (nonatomic , copy  )  NSString                  * beMarrage;      //婚姻状况
@property (nonatomic , copy  )  NSString                  * houseRegisterMaster; //户口本户主页
@property (nonatomic , copy  )  NSString                  * houseRegisterPersonal; //户口本个人页
@property (nonatomic , copy  )  NSString                  * bankCredits;    //央行征信报告资料
@property (nonatomic , copy  )  NSString                  * releation;      //人员角色 1贷款人(贷款人) 2贷款人配偶(贷款人配偶) 3配偶&共有人 4共有人 5担保人 6担保人配偶 7卖方 8卖方配偶
@end


//订单信息
@interface OrderModel : NSObject
@property (nonatomic , copy  )  NSString                  * tid;                 //订单id
@property (nonatomic , copy  )  NSString                  * orderNo;             //订单号
@property (nonatomic , copy  )  NSString                  * createDate;          //创建时间
@property (nonatomic , copy  )  NSString                  * dataSrc;             //订单来源
@property (nonatomic , copy  )  NSString                  * agencyName;          //所属中介
@property (nonatomic , copy  )  NSString                  * agentUserId;
@property (nonatomic , copy  )  NSString                  * agentUserName;       //中介姓名
@property (nonatomic , copy  )  NSString                  * agencyContact;       //
@property (nonatomic , copy  )  NSString                  * agencyContactPhone;  //中介联系方式
@property (nonatomic , copy  )  NSString                  * preCreditUserPhone;  //审批员联系方式
@property (nonatomic , copy  )  NSString                  * projName;            //楼盘名称
@property (nonatomic , copy  )  NSString                  * houseNum;            //楼栋房号
@property (nonatomic , copy  )  NSString                  * insideArea;          //套内面积
@property (nonatomic , copy  )  NSString                  * coveredArea;         //建筑面积
@property (nonatomic , copy  )  NSString                  * housingFunction;     //房屋功能
@property (nonatomic , copy  )  NSString                  * warrantNo;           //权证号
@property (nonatomic , copy  )  NSString                  * orderState;          //订单状态
@property (nonatomic , copy  )  NSString                  * address;             //楼盘详细地址
@property (nonatomic , copy  )  NSString                  * provinceId;
@property (nonatomic , copy  )  NSString                  * province;
@property (nonatomic , copy  )  NSString                  * cityId;
@property (nonatomic , copy  )  NSString                  * city;
@property (nonatomic , copy  )  NSString                  * areaId;
@property (nonatomic , copy  )  NSString                  * area;
@property (nonatomic , copy  )  NSString                  * loanCityId;          //所在城市id
@property (nonatomic , copy  )  NSString                  * loanCity;            //所在城市名称
@property (nonatomic , copy  )  NSString                  * applyLoanAmount;     //申请贷款金额
@property (nonatomic , copy  )  NSString                  * contractAmount;      //合同总价
@property (nonatomic , copy  )  NSString                  * loanLimit;           //贷款年限
@property (nonatomic , copy  )  NSString                  * loanBank2;           //贷款银行
@property (nonatomic , copy  )  NSString                  * loanBankId2;         //贷款银行ID
@property (nonatomic , copy  )  NSString                  * loanRate;            //贷款利率
@property (nonatomic , copy  )  NSString                  * preCreditUserName;   //预授信操作人
@property (nonatomic , copy  )  NSString                  * preCreditUser;       //预授信操作人ID
@property (nonatomic , copy  )  NSString                  * createBy;            //派单接收人
@property (nonatomic , copy  )  NSString                  * distributeUser;      //派单操作人
@property (nonatomic , copy  )  NSString                  * distributeDate;      //派单日期
@property (nonatomic , copy  )  NSString                  * customerManagerName; //专属客户经理
@property (nonatomic , copy  )  NSString                  * customerManager;     //专属客户经理ID
@property (nonatomic , copy  )  NSString                  * customerManagerPhone;//专属客户经理手机
@end


//不动产权证
@interface WarrantImg : NSObject
@property (nonatomic , copy  )  NSString                  * tid;
@property (nonatomic , copy  )  NSString                  * serialNo;
@property (nonatomic , copy  )  NSString                  * docId;
@property (nonatomic , copy  )  NSString                  * category;
@property (nonatomic , copy  )  NSString                  * docType;
@property (nonatomic , copy  )  NSString                  * dataUrl;
@end
