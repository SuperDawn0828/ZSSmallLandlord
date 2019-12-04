//
//  ZSWSAddResourceController.h
//  ZSSmallLandlord
//
//  Created by 武 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  首页--订单列表--订单详情--资料收集--添加资料


#import "ZSBaseViewController.h"
#import "ZSWSDataCollectionView.h"

@class ZSWSFileCollectionModel;

@interface ZSWSAddResourceController : ZSBaseViewController

@property(nonatomic,strong)ZSWSDataCollectionView   *dataCollectionView;

@property(nonatomic,assign)ZSAddResourceDataStyle   addDataStyle;         //添加按钮格式

@property(nonatomic,strong)DocInfo                  *docInfoModel;        //新房见证资料类型model

@property(nonatomic,strong)NSMutableArray           *itemNameArray;       //标题数组

@property(nonatomic,strong)NSMutableArray           *itemDataArray;       //值数组

@property(nonatomic,strong)NSMutableArray           *fileArray;           //请求数据数组

@property(nonatomic,strong)UIScrollView             *bgScrollView;        //滑动ScrollView

@property(nonatomic,assign)CGFloat                  topSpace;             //collectionView居上高度

@property(nonatomic,copy  )NSString                 *otherCustNo;         //其他资料人员ID

@property(nonatomic,assign)BOOL                     isOnlyText;           //是否只上传文本

@property(nonatomic,assign)BOOL                     isShowAdd;            //是否显示加号


@end
