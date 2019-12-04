//
//  ZSBaseAddCustomerViewController.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/12.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  金融产品添加客户信息

#import "ZSBaseViewController.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "ZSInputOrSelectView.h"
#import "IDCardViewController.h"
#import "IdInfo.h"
#import "DictManager.h"
#import "PYPhotoBrowseView.h"

@interface ZSBaseAddCustomerViewController : ZSBaseViewController
//上个页面传过来
@property(nonatomic,assign)BOOL                     isFromAdd;            //创建订单,现有订单添加人
@property(nonatomic,assign)BOOL                     isFromEditor;         //编辑人
@property(nonatomic,assign)BOOL                     isFromWeiXin;         //微信申请--微信
@property(nonatomic,assign)BOOL                     isFromOfficial;       //微信申请--官网
@property(nonatomic,copy  )NSString                 *mediumID;            //中介机构ID
@property(nonatomic,copy  )NSString                 *mediumName;          //中介机构联系人名字
@property(nonatomic,copy  )NSString                 *mediumPhone;         //中介机构联系人手机号
@property(nonatomic,copy  )NSString                 *onlineOrderIDString; //微信申请订单id
@end
