//
//  ZSDynamicDataModel.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/5/17.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  动态资料列表model

#import <Foundation/Foundation.h>
#import "ZSWSFileCollectionModel.h"
#import "ZSPCOrderDetailModel.h"

@class Options;
@interface ZSDynamicDataModel : NSObject
@property (nonatomic,copy  )NSString   *prdDocsId;     //产品资料ID
@property (nonatomic,copy  )NSString   *fieldName;     //需要上传的数据
@property (nonatomic,copy  )NSString   *fieldMeaning;  //需要填写资料的资料名
@property (nonatomic,copy  )NSString   *fieldUnit;     //单位
@property (nonatomic,copy  )NSString   *orderBy;       //排序(当前资料在tableview的第几行)
@property (nonatomic,copy  )NSString   *isNecessary;   //是否是必填 0否 1是
@property (nonatomic,copy  )NSString   *fieldType;     //展示类型  1文本 2多行文本 3图片 4数字 5日期 6日期+时间 7单选,
@property (nonatomic,copy  )NSString   *tid;
@property (nonatomic,strong)NSArray    <Options *>*options;
//本地的数据
@property (nonatomic,copy  )NSString   *rightData;//右侧数据
@property (nonatomic,assign)CGFloat    cellHeight;//高度
@property (nonatomic,strong)NSArray    *imageDataArray;//本地图片资源
@property (nonatomic,strong)NSArray    *collectionviewUploadArray;//已经上传的图片数组(央行征信报告用)
@property (nonatomic,strong)NSString   *prdType;
@end


@interface Options : NSObject
@property (nonatomic,copy  )NSString   *tid;
@property (nonatomic,copy  )NSString   *fieldId;
@property (nonatomic,copy  )NSString   *optionText;
@property (nonatomic,copy  )NSString   *optionValue;
@property (nonatomic,copy  )NSString   *createDate;
@property (nonatomic,copy  )NSString   *updateDate;
@property (nonatomic,copy  )NSString   *version;
@property (nonatomic,copy  )NSString   *state;
@end
