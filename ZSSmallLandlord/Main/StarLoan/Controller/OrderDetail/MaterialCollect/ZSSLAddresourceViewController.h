//
//  ZSBaseAddResourceViewController.h
//  ZSSmallLandlord
//
//  Created by gengping on 2017/9/13.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  金融产品上传资料base类

#import "ZSBaseViewController.h"
#import "ZSSLDataCollectionView.h"

@interface ZSSLAddresourceViewController : ZSBaseViewController
{
    LSProgressHUD      *hud;
    BOOL               isShowHUD;
}
@property(nonatomic,assign)ZSAddResourceDataStyle     addDataStyle;        //添加按钮格式
@property(nonatomic,strong)ZSSLDataCollectionView     *dataCollectionView;
@property(nonatomic,strong)UIScrollView               *bgScrollView;       //滑动ScrollView
@property(nonatomic,strong)NSMutableArray             *itemNameArray;      //标题数组
@property(nonatomic,strong)NSMutableArray             *itemDataArray;      //值数组
@property(nonatomic,strong)NSMutableArray             *fileArray;          //请求数据数组
@property(nonatomic,strong)NSMutableArray             *textArray;          //请求文本数组
@property(nonatomic,copy  )NSString                   *otherCustNo;        //其他资料人员ID
@property(nonatomic,assign)CGFloat                    topSpace;            //collectionView居上高度
@property(nonatomic,strong)Handles                    *SLDocToModel;
@property(nonatomic,assign)BOOL                       isOnlyText;          //是否只上传文本
@property(nonatomic,assign)BOOL                       isShowAdd;           //是否显示加号
@property(nonatomic,assign)BOOL                       isFailure;           //是否有图片上传失败
@property(nonatomic,assign)BOOL                       isChanged;           //判断当前页面是否有操作,用于返回提示


#pragma mark /*--------------方法名-------------*/
#pragma mark 上传所有资料
- (void)uploadAllDatas;
#pragma mark 获取所有需要上传的资料的数组
- (NSMutableArray*)getNeedUploadFilesArray;
#pragma mark 根据不同的产品发不同的通知
- (void)postNotificationForProductType;
#pragma mark 各种资料视图
- (void)initCollectionView:(CGFloat)height;

#pragma mark /*--------------填充数据-------------*/
#pragma mark 准备数据
- (void)configureDataSource;
#pragma mark 加载订单完成和关闭情况的数据
- (void)configCloseAndCompletedata;

#pragma mark /*--------------请求参数-------------*/
#pragma mark 获取资料状态参数
- (NSMutableDictionary *)getMaterialsFilesParameter;

#pragma mark /*--------------接口网址-------------*/
#pragma mark 获取已上传资料的接口网址
- (NSString*)getMaterialsFilesURL;

#pragma mark /*--------------子类重写(必须)-------------*/
#pragma mark 资料上传
- (void)uploadTextDataAndImageData;

@end
