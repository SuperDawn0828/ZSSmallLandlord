//
//  ZSWSFileCollectionModel.h
//  ZSMoneytocar
//
//  Created by 武 on 2017/5/22.
//   copyright © 2017年 Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSAddResourceModel.h"
@class Propitems,FileList,Itemtitle;

@interface ZSWSFileCollectionModel : NSObject

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, assign) NSInteger currentSectionIndex;  //当前cell属于哪个section,用于回显后图片上转(央行征信报告)

@property (nonatomic, assign) NSInteger currentIndex;         //本地相册的选择的图片数组索引,用于照片排序

@property (nonatomic,   copy) NSString *createDate;           //图片上传时间

@property (nonatomic,   copy) NSString *createByName;         //图片上传人姓名

@property (nonatomic,   copy) NSString *category;             //资料细分种类

@property (nonatomic,   copy) NSString *subCategory;          //新房见证用于区分(户主页和个人页)星速贷区分是贷款人还是配偶

@property (nonatomic,   copy) NSString *dataType;             //(.mp4 .jpg)

@property (nonatomic,   copy) NSString *videoPath;            //录制的视频路径

@property (nonatomic,   copy) NSString *dataUrl;              //线上地址

@property (nonatomic,   copy) NSString *_Nullable tid;        //线上的资料的tid

@property (nonatomic,   copy) NSString *_Nullable preUrl;     //预览大图的url地址（线上的需要拼接）

@property (nonatomic,   copy) NSString *thumbnailUrl;         //缩略图

@property (nonatomic,   copy) NSString *imageUrl;

@property (nonatomic,   copy) NSString *_Nullable docId;      //资料细分id

@property (nonatomic,   copy) NSString *_Nullable docName;    //资料类型

@property (nonatomic,   copy) NSString *custNo;               //人员Id

@property (nonatomic,   copy) NSString *photo;                //照片附件

@property (nonatomic, strong) UIImage  *_Nullable  image;     //本地拍摄的图片

@property (nullable, nonatomic, retain)NSData  *imageData;    //图片数据

@property (nonatomic, assign) BOOL     isNewImage;            //是否是新增图片

@property (nonatomic,   copy) NSString *subType;              //资料叶子类型,个人身份证正面、反面等

@property (nonatomic,   copy) NSString *docType;              //资料类型，户主页和个人页 //上传

@property (nonatomic,   copy) NSString *leafCategory;         //资料类型，户主页和个人页 //获取

@property (nonatomic,   copy) NSString *dataId;               //星速贷线上资料ID

@property (nonatomic, assign) BOOL     isFromAbum;            //是否来自相册

@property (nonatomic, strong) NSArray<SpdDocInfoVos *>   *spdDocInfoVos;

@property (nonatomic, strong) NSArray<Propitems *>       *propitems;


NS_ASSUME_NONNULL_END

@end


@interface Propitems :NSObject

NS_ASSUME_NONNULL_BEGIN
@property (nonatomic , strong)  NSArray<ZSWSFileCollectionModel *>   * fileList;

@property (nonatomic , strong)  Itemtitle   * itemtitle;
NS_ASSUME_NONNULL_END

@end

@interface FileList :NSObject

@property (nonatomic , assign)  NSInteger  updateDate;

@property (nonatomic , assign)  NSInteger  state;

@property (nonatomic , assign)  NSInteger  version;

@property (nonatomic , assign)  NSInteger  createDate;

NS_ASSUME_NONNULL_BEGIN
@property (nonatomic ,   copy)  NSString   *category;

@property (nonatomic ,   copy)  NSString   *docType;

@property (nonatomic ,   copy)  NSString   *dataUrl;

@property (nonatomic ,   copy)  NSString   *createBy;

@property (nonatomic ,   copy)  NSString   *serialNo;

@property (nonatomic ,   copy)  NSString   *tid;

@property (nonatomic ,   copy)  NSString   *docId;
NS_ASSUME_NONNULL_END

@end


@interface Itemtitle :NSObject

@property (nonatomic , assign)  NSInteger  updateDate;

@property (nonatomic , assign)  NSInteger  state;

@property (nonatomic , assign)  NSInteger  version;

@property (nonatomic , assign)  NSInteger  createDate;

NS_ASSUME_NONNULL_BEGIN
@property (nonatomic ,   copy)  NSString   *createBy;

@property (nonatomic ,   copy)  NSString   *collectTime;

@property (nonatomic ,   copy)  NSString   *updateBy;

@property (nonatomic ,   copy)  NSString   *orderno;

@property (nonatomic ,   copy)  NSString   *tid;
NS_ASSUME_NONNULL_END

@end

