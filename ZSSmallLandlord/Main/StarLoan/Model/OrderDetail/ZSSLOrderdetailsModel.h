//
//  ZSSLOrderdetailsModel.h
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/30.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SpdOrderStates,BizCustomers,SpdOrder,BizCreditCustomers,OrderRelation;

@interface ZSSLOrderdetailsModel : NSObject

@property (nonatomic , strong)  NSArray<SpdOrderStates *>   * spdOrderStates;     //订单进度

@property (nonatomic , strong)  NSArray<BizCustomers *>     * bizCustomers;       //人员信息

@property (nonatomic , strong)  SpdOrder       * spdOrder;                        //贷款信息和房产信息

@property (nonatomic , strong)  OrderRelation   *orderRelation;                   //关联订单(不存在的时候可以创建其他订单,存在的时候查看相关订单)

@property (nonatomic , copy  )  NSString   *approvalState;                        //当前节点可操作状态（0:不可操作\2:审批\1:提交资料）

@property (nonatomic , copy  )  NSString   *isOrder;                              //是否是订单创建人 (0:不是 1:是)

@property (nonatomic , copy  )  NSString   *curNodeName;                          //节点名称

@property (nonatomic , copy  )  NSString   *createByTel;                          //创建人电话

@property (nonatomic , copy  )  NSString   *agencyName;                           //中介名称

@property (nonatomic , copy  )  NSString   *isCredit;                             //是否查询大数据风控 1需要查询 2不需要查询 这是针对订单的,后台配置了就差,不配置就不查

@property (nonatomic , copy  )  NSString   *todoUserTel;                          //当前催办的电话

@end



@interface OrderRelation : NSObject
@property (nonatomic , copy  )  NSString   *tid;
@property (nonatomic , copy  )  NSString   *prdType1; //被转订单的产品类型
@property (nonatomic , copy  )  NSString   *orderId1; //被转订单的id
@property (nonatomic , copy  )  NSString   *prdType2; //转好订单的产品类型
@property (nonatomic , copy  )  NSString   *orderId2; //转好订单的id
@property (nonatomic , copy  )  NSString   *createDate;
@property (nonatomic , copy  )  NSString   *updateDate;
@property (nonatomic , copy  )  NSString   *version;
@property (nonatomic , copy  )  NSString   *state;
@property (nonatomic , copy  )  NSString   *orderState;//订单状态
@end


@interface BizCustomers :NSObject

@property (nonatomic , assign)  NSInteger  state;

@property (nonatomic , copy  )  NSString   *identityPos;     //身份证正面

@property (nonatomic , copy  )  NSString   *identityBak;     //身份证反面

@property (nonatomic , copy  )  NSString   *cellphone;       //手机号

@property (nonatomic , assign)  NSInteger  version;

@property (nonatomic , copy  )  NSString   *createBy;

@property (nonatomic , assign)  NSString   *createDate;      //订单创建时间

@property (nonatomic , assign)  NSInteger  updateDate;

@property (nonatomic , copy  )  NSString   *beMarrage;        //婚姻状态 2为已婚

@property (nonatomic , copy  )  NSString   *tid;             //id

@property (nonatomic , copy  )  NSString   *custNo;          //id(用于编辑的时候传递人员id,与其他无关)

@property (nonatomic , copy  )  NSString   *name;            //姓名

@property (nonatomic , copy  )  NSString   *identityNo;      //身份证号

@property (nonatomic , copy  )  NSString   *lenderReleation; //与贷款人关系 1朋友 2直系亲属

@property (nonatomic , copy  )  NSString   *isCredit;        //是否查询大数据风控 1需要查询 2不需要查询 (从订单详情塞过来的,跟着订单走的)

@property (nonatomic , copy  )  NSString   *isRiskData;      //是否查询大数据风控 1查询 2不查询

@property (nonatomic , strong)  NSArray    <BizCreditCustomers *>   * bizCreditCustomers;

@property (nonatomic , copy  )  NSString   *fail_serviceCodes;//有值的时候显示大数据风控"刷新"按钮

@property (nonatomic , copy  )  NSString   *releation;        //人员角色 1贷款人 2贷款人配偶 3配偶&共有人 4共有人 5担保人 6担保人配偶 7卖方 8卖方配偶 9买方 10买方配偶

@property (nonatomic , copy  )  NSString   *sex;

@property (nonatomic , copy  )  NSString   *birthdate;

@property (nonatomic , assign)  BOOL       showDown;

@property (nonatomic , assign)  BOOL       showUp;

@end


@interface BizCreditCustomers :NSObject

@property (nonatomic , assign)  NSString  *state;

@property (nonatomic , assign)  NSInteger  version;

@property (nonatomic , copy  )  NSString   *custNo;

@property (nonatomic , copy  )  NSString   *frontCreditSummary;

@property (nonatomic , copy  )  NSString   *frontCreditInfo;

@property (nonatomic , copy  )  NSString   *interactName;             //查询内容

@property (nonatomic , copy  )  NSString   *serialNo;

@property (nonatomic , copy  )  NSString   *trxId;

@property (nonatomic , copy  )  NSString   *creditSummary;

@property (nonatomic , copy  )  NSString   *creditInfo;

@property (nonatomic , assign)  NSString   *showType;         //0和1显示红色图标,2显示绿色图标

@property (nonatomic , assign)  NSString   *createDate;

@property (nonatomic , assign)  NSString   *updateDate;

@property (nonatomic , copy  )  NSString   *frontJsonStr;

@property (nonatomic , copy  )  NSString   *interactId;

@property (nonatomic , copy  )  NSString   *tid;

@property (nonatomic , copy  )  NSString   *jsonStr;

@property (nonatomic , copy  )  NSString   *createBy;

@end


@interface SpdOrderStates :NSObject

@property (nonatomic , copy  )  NSString   *create_date;   //节点创建时间

@property (nonatomic , copy  )  NSString   *process_date;  //流转时间

@property (nonatomic , copy  )  NSString   *sign_date;     //审批时间

@property (nonatomic , copy  )  NSString   *node_id;

@property (nonatomic , copy  )  NSString   *creator;       //定单创建人

@property (nonatomic , copy  )  NSString   *creator_role;  //定单创建人角色

@property (nonatomic , copy  )  NSString   *note_type;     //节点类型 AUD审批类 DOC提交资料 ADD添加备注

@property (nonatomic , copy  )  NSString   *remark;        //审批备注

@property (nonatomic , copy  )  NSString   *now_takes_time;//当前节点耗时时间

@property (nonatomic , copy  )  NSString   *order_state;

@property (nonatomic , copy  )  NSString   *result;        //审批意见,退单原因

@property (nonatomic , copy  )  NSString   *items;

@property (nonatomic , copy  )  NSString   *node;

@property (nonatomic , copy  )  NSString   *operator_tel;  //联系人电话

@property (nonatomic , assign)  BOOL       isOpen;         //（本地所用的，服务器没有这个数据）是否展开

@end


@interface SpdOrder :NSObject

@property (nonatomic , copy  )  NSString   *tid;                //订单Id

@property (nonatomic , assign)  NSInteger  updateDate;

@property (nonatomic , copy  )  NSString   *loanLimit;          //贷款年限

@property (nonatomic , copy  )  NSString   *contractAmount;     //合同总价

@property (nonatomic , copy  )  NSString   *loanBank2;

@property (nonatomic , copy  )  NSString   *loanAmount;         // 放款金额

@property (nonatomic , assign)  NSInteger  version;

@property (nonatomic , copy  )  NSString   *downpayAmount;      //首付总额

@property (nonatomic , copy  )  NSString   *loanCategory;       //贷款种类

@property (nonatomic , assign)  NSInteger  state;               //提交的订单被撤回,从通知列表进入该订单时显示缺省页

@property (nonatomic , copy  )  NSString   *loanType;           //还款方式

@property (nonatomic , assign)  NSInteger  dataSrc;             //客户来源 1中介 2线下 3微信 4官网 5中介APP

@property (nonatomic , copy  )  NSString   *agencyId;           //中介id

@property (nonatomic , copy  )  NSString   *agencyContact;      //中介联系人名字

@property (nonatomic , copy  )  NSString   *agencyContactPhone; //中介联系人电话

@property (nonatomic , copy  )  NSString   *activeNodeId;

@property (nonatomic , copy  )  NSString   *orderNo;

@property (nonatomic , copy  )  NSString   *createBy;

@property (nonatomic , copy  )  NSString   *updateBy;

@property (nonatomic , copy  )  NSString   *handlerId;

@property (nonatomic , assign)  NSInteger  createDate;

@property (nonatomic , copy  )  NSString   *orgId;

@property (nonatomic , copy  )  NSString   *orderState;      //订单状态

@property (nonatomic , copy  )  NSString   *houseNum;        //楼栋房号

@property (nonatomic , copy  )  NSString   *projName;        //楼盘名称

@property (nonatomic , copy  )  NSString   *housingFunction; //房屋功能

@property (nonatomic , copy  )  NSString   *warrantNo;       //权证号

@property (nonatomic , copy  )  NSString   *coveredArea;     //建筑面积

@property (nonatomic , copy  )  NSString   *loanRate;        //贷款利率

@property (nonatomic , copy  )  NSString   *insideArea;      //套内面积

@property (nonatomic , copy  )  NSString   *loanBankId2;     //银行id

@property (nonatomic , copy  )  NSString   *evaluePrice;     //评估单价

@property (nonatomic , copy  )  NSString   *evalueTotalPrice;//评估总价

@property (nonatomic , copy  )  NSString   *province;        //省份名称

@property (nonatomic , copy  )  NSString   *city;            //城市名称

@property (nonatomic , copy  )  NSString   *area;            //区名称

@property (nonatomic , copy  )  NSString   *address;         //详细地址

@property (nonatomic , copy  )  NSString   *provinceId;      //省份名称

@property (nonatomic , copy  )  NSString   *cityId;          //城市名称

@property (nonatomic , copy  )  NSString   *areaId;          //区名称

@property (nonatomic , copy  )  NSString   *fundSource;      // 放款资金来源 1 银行资金 2 自有资金

@property (nonatomic , copy  )  NSString   *loanBankId;      //贷款银行id

@property (nonatomic , copy  )  NSString   *loanBank;        //贷款银行

@property (nonatomic , copy  )  NSString   *loanleftAmount;  //按揭剩余金额

@property (nonatomic , copy  )  NSString   *advanceAmount;   //贷款金额

@property (nonatomic , copy  )  NSString   *repayBank;       //原按揭银行

@property (nonatomic , copy  )  NSString   *parkArea;       //车位面积

@end


