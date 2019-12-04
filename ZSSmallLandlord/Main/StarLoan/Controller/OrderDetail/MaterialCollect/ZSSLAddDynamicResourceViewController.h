//
//  ZSSLAddDynamicResourceViewController.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/5/15.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  金融产品动态资料列表base类

#import "ZSBaseViewController.h"

@interface ZSSLAddDynamicResourceViewController : ZSBaseViewController
@property (nonatomic,copy  )NSString *prdDocsId;   //产品资料ID
@property (nonatomic,assign)BOOL     isShowAdd;    //是否显示加号
@property (nonatomic,strong)Handles *SLDocToModel; //资料类型model
@end
