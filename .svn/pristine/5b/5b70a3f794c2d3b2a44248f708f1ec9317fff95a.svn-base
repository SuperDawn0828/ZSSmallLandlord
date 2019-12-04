//
//  ZSWSOrderDetailModel.h
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/8.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSWSFileCollectionModel.h"

@class ProjectInfo,DocInfo,ScheduleInfo,Files,CustInfo,DocsDataList,ZSWSFileCollectionModel,BizCreditCustomers;
@interface ZSWSOrderDetailModel :NSObject
@property (nonatomic , strong) ProjectInfo                    * projectInfo; //项目资料
@property (nonatomic , strong) NSArray<ScheduleInfo *>        * scheduleInfo;//按揭进度
@property (nonatomic , strong) NSArray<CustInfo *>            * custInfo;    //人员详情
@property (nonatomic , strong) NSArray<DocInfo *>             * docInfo;     //资料收集
@property (nonatomic , copy  ) NSString                       *ifLoanApprove; //是否可以完成订单 0不允许完成
@property (nonatomic , copy  ) NSString                       *isCredit;     //是否查询大数据风控 1需要查询 2不需要查询 (这个值需要自己塞到人员列表里面去)
@end


@interface ProjectInfo :NSObject 
@property (nonatomic , copy  ) NSString              * orderState;    //订单状态  1待提交征信查询 2待反馈征信结果 3资料收集中 4银行审核中 5已放款 6已完成 7已关闭
@property (nonatomic , assign) NSInteger             serviceFee;
@property (nonatomic , copy  ) NSString              * tid;              //订单号
@property (nonatomic , assign) NSInteger             fedbackState;
@property (nonatomic , copy  ) NSString              * projName;         //项目名称
@property (nonatomic , copy  ) NSString              * projId;           //项目id
@property (nonatomic , copy  ) NSString              * updateDate;
@property (nonatomic , copy  ) NSString              * loanLimit;        //贷款年限
@property (nonatomic , copy  ) NSString              * contractAmount;   //合同总额
@property (nonatomic , copy  ) NSString              * loanBank;         //贷款银行
@property (nonatomic , copy  ) NSString              * loanBankId;       //贷款银行id
@property (nonatomic , assign) NSInteger             settleState;
@property (nonatomic , copy  ) NSString              * loanAmount;       //贷款金额
@property (nonatomic , assign) NSInteger             version;
@property (nonatomic , copy  ) NSString              * downpayAmount;    //首付金额
@property (nonatomic , assign) NSInteger             state;
@property (nonatomic , copy  ) NSString              * loanType;         //还款方式
@property (nonatomic , copy  ) NSString              * housingFunction;  //房屋功能
@property (nonatomic , copy  ) NSString              * contractNo;
@property (nonatomic , copy  ) NSString              * insideArea;       //预售套内面积
@property (nonatomic , copy  ) NSString              * createBy;
@property (nonatomic , copy  ) NSString              * updateBy;
@property (nonatomic , copy  ) NSString              * loanCategory;     //贷款种类
@property (nonatomic , copy  ) NSString              * orderNo;
@property (nonatomic , copy  ) NSString              * handlerId;        //订单处理人呢
@property (nonatomic , copy  ) NSString              * createDate;
@property (nonatomic , copy  ) NSString              * orgId;
@property (nonatomic , copy  ) NSString              * remark;
@property (nonatomic , copy  ) NSString              * coveredArea;      //预售建筑面积
@property (nonatomic , copy  ) NSString              * houseNum;         //楼栋房号
@property (nonatomic , copy  ) NSString              * loanRate;         //贷款利率
@end

@interface ScheduleInfo :NSObject
@property (nonatomic , assign) NSInteger             state;
@property (nonatomic , copy  ) NSString              * itemDate;
@property (nonatomic , assign) NSInteger             version;
@property (nonatomic , copy  ) NSString              * updateBy;
@property (nonatomic , copy  ) NSString              * createDate;//创建时间
@property (nonatomic , copy  ) NSString              * item;
@property (nonatomic , copy  ) NSString              * serialNo;
@property (nonatomic , copy  ) NSString              * creator;
@property (nonatomic , copy  ) NSString              * remark;
@property (nonatomic , copy  ) NSString              * updateDate;
@property (nonatomic , copy  ) NSString              * tid;
@property (nonatomic , copy  ) NSString              * createBy;
@end

@interface Files :NSObject

@end

@interface DocsDataList :NSObject
@property (nonatomic , copy  ) NSString              * docId;
@property (nonatomic , copy  ) NSString              * docType;
@property (nonatomic , assign) NSInteger             state;
@property (nonatomic , assign) NSInteger             version;
@property (nonatomic , copy  ) NSString              * updateBy;
@property (nonatomic , copy  ) NSString              * category;
@property (nonatomic , copy  ) NSString              * custNo;
@property (nonatomic , copy  ) NSString              * createDate;
@property (nonatomic , copy  ) NSString              * serialNo;
@property (nonatomic , copy  ) NSString              * subCategory;
@property (nonatomic , copy  ) NSString              * remark;
@property (nonatomic , copy  ) NSString              * updateDate;
@property (nonatomic , copy  ) NSString              * dataUrl;
@property (nonatomic , copy  ) NSString              * tid;
@property (nonatomic , copy  ) NSString              * createBy;
@end

@interface CustInfo :NSObject
@property (nonatomic , copy  ) NSString              * birthdate;        //出生日期
@property (nonatomic , copy  ) NSString              * provinceId;       //省份id
@property (nonatomic , copy  ) NSString              * orderId;          //订单ID
@property (nonatomic , copy  ) NSString              * remark;
@property (nonatomic , copy  ) NSString              * houseloanInf;     //房贷
@property (nonatomic , assign) NSInteger             state;
@property (nonatomic , copy  ) NSString              * address;          //详细地址
@property (nonatomic , copy  ) NSString              * otherInf;         //其他
@property (nonatomic , assign) NSInteger             version;
@property (nonatomic , copy  ) NSString              * updateDate;
@property (nonatomic , copy  ) NSString              * releation;        //角色信息 1贷款人,2贷款人配偶,3配偶&共有人,4共有人,5担保人,6担保人配偶
@property (nonatomic , copy  ) NSString              * identityNo;       //身份证
@property (nonatomic , copy  ) NSString              * fedbackState;
@property (nonatomic , copy  ) NSString              * consumeInf;       //消费贷款
@property (nonatomic , copy  ) NSString              * sex;              //性别
@property (nonatomic , copy  ) NSString              * area;             //区
@property (nonatomic , assign) NSInteger             custStatus;         //客户状态
@property (nonatomic , copy  ) NSString              * cellphone;        //手机号
@property (nonatomic , copy  ) NSString              * updateBy;
@property (nonatomic , copy  ) NSString              * beMarrage;          //婚姻状况 1未婚 2已婚 3离异 4丧偶
@property (nonatomic , copy  ) NSString              * name;             //姓名
@property (nonatomic , strong) NSArray<ZSWSFileCollectionModel *>  * docsDataList;
@property (nonatomic , copy  ) NSString              * idendity;         //是否为共有人 0是 1否
@property (nonatomic , copy  ) NSString              * createBy;
@property (nonatomic , copy  ) NSString              * city;             //城市
@property (nonatomic , copy  ) NSString              * identityPos;      //身份证正面照片
@property (nonatomic , copy  ) NSString              * tid;
@property (nonatomic , copy  ) NSString              * orderDate;        //订单创建时间
@property (nonatomic , copy  ) NSString              * cityId;           //城市id
@property (nonatomic , copy  ) NSString              * createDate;
@property (nonatomic , copy  ) NSString              * province;         //省份
@property (nonatomic , copy  ) NSString              * creditcardInf;    //信用卡
@property (nonatomic , copy  ) NSString              * mateId;           //配偶id,可做配对用
@property (nonatomic , copy  ) NSString              * authorizeImg;     //授权签字照片
@property (nonatomic , copy  ) NSString              * creditResult;     //银行反馈状态 0未反馈,1已反馈-通过,2已反馈-不通过
@property (nonatomic , copy  ) NSString              * identityBak;      //身份证反面照片
@property (nonatomic , copy  ) NSString              * areaId;           //区
@property (nonatomic , copy  ) NSString              * lenderReleation;  //与贷款人关系 0直系 1配偶 2朋友
@property (nonatomic , copy  ) NSString              * creditDate;       //银行征信反馈时间
@property (nonatomic , assign) BOOL                  isNotFeedback;      //用于列表"点击立即反馈"的按钮隐藏
@property (nonatomic , strong)  NSArray<BizCreditCustomers *>   * bizCreditCustomers; //大数据风控的数据
@property (nonatomic , copy  ) NSString              * isRiskData;       //是否查询大数据风控 1查询,其他不查询
@property (nonatomic , copy  ) NSString              * isBankCredit;     //是否查询央行征信  1查询,其他不查询
@property (nonatomic , copy  ) NSString              * fail_serviceCodes;//有值的时候显示大数据风控"刷新"按钮
@end


@interface DocInfo :NSObject
@property (nonatomic , copy  ) NSString              *docType;      //资料类型
@property (nonatomic , assign) NSInteger             state;
@property (nonatomic , copy  ) NSString              *docId;       //资料编号
@property (nonatomic , assign) NSInteger             version;
@property (nonatomic , copy  ) NSString              * updateBy;
@property (nonatomic , copy  ) NSString              * docName;     //资料名称
@property (nonatomic , copy  ) NSString              * createDate;
@property (nonatomic , assign) NSInteger             beCollect;     //是否收集到数据
@property (nonatomic , copy  ) NSString              * serialNo;
@property (nonatomic , copy  ) NSString              * remark;
@property (nonatomic , copy  ) NSString              * updateDate;
@property (nonatomic , assign) NSInteger             docFlag;       //资料收集标记
@property (nonatomic , copy  ) NSString              * tid;
@property (nonatomic , copy  ) NSString              * createBy;
@end






