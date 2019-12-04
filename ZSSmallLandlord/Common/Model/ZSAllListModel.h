//
//  ZSUserMessageModel.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/8.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  所有订单列表的model

#import <Foundation/Foundation.h>

@interface ZSAllListModel : NSObject
@property(nonatomic,copy  )NSString *cust_no;                  //人员id
@property(nonatomic,copy  )NSString *identity_no;              //人员身份证
@property(nonatomic,copy  )NSString *cust_name;                //人员姓名
@property(nonatomic,copy  )NSString *prd_type;                 //产品类型
@property(nonatomic,copy  )NSString *create_date;              //订单创建时间
@property(nonatomic,copy  )NSString *remain_time;              //订单停留时间
@property(nonatomic,copy  )NSString *process_date;             //订单流转到当前节点的时间
@property(nonatomic,copy  )NSString *sign_date;                //订单审批时间
@property(nonatomic,copy  )NSString *complete_date;            //订单完成时间
@property(nonatomic,copy  )NSString *close_date;               //订单关闭时间
@property(nonatomic,copy  )NSString *tid;                      //订单id
@property(nonatomic,copy  )NSString *order_state_desc;         //订单状态(首页列表,审批列表,订单列表使用)
@property(nonatomic,copy  )NSString *order_state;              //订单状态(预授信评估列表,中介端跟进列表,派单列表使用)
@property(nonatomic,copy  )NSString *apply_precredit_date;     //提交预授信申请时间(预授信列表使用)
@property(nonatomic,copy  )NSString *submit_precredit_date;    //生成预授信报告时间(预授信列表使用)
@property(nonatomic,copy  )NSString *submit_loan_date;         //提交贷款时间(派单列表使用)
@property(nonatomic,assign)BOOL     isSelect;                  //是否选中(派单列表使用)
@property(nonatomic,copy  )NSString *submit_distribute_date;   //派单时间(派单列表使用)
@property(nonatomic,copy  )NSString *loan_bank;                //所属银行(审批列表用)
@property(nonatomic,copy  )NSString *province;                 //省份(审批列表用)
@property(nonatomic,copy  )NSString *city;                     //城市(审批列表用)
@property(nonatomic,copy  )NSString *area;                     //区域(审批列表用)
@property(nonatomic,copy  )NSString *create_by;                //订单创建人(审批列表用)
@property(nonatomic,copy  )NSString *agent_user_name;          //所属中介跟进人(中介端跟进列表用)
@property(nonatomic,copy  )NSString *agent_user_company;       //所属中介名称(中介端跟进列表用)
//本地数据
@property(nonatomic,copy  )NSString *state_result;             //订单类型 0待处理 1已处理  审批列表是服务器返回,其他列表是自己填的本地数据
@property(nonatomic,assign)NSInteger listType;                 //本地填充的数据,用于cell里面做不同列表的数据区分 1.预授信评估列表 2.派单列表 3.订单列表 4.审批列表 5.首页列表
@end
