//
//  ZSWSDataCollectionView.h
//  ZSMoneytocar
//
//  Created by 武 on 2017/5/19.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSWSFileCollectionModel.h"
#import "ZSAddResourceModel.h"

@class ZSWSDataCollectionView;
@class ZSDataCell;

@protocol ZSWSDataCollectionViewDelegate <NSObject>

@optional

- (void)previewBigImage;//预览大图

- (void)didSelectedImage;//添加照片

- (void)refershDataCollectionViewHegiht;//重置高度

- (void)judeBottomBtnEnabled;//判断底部按钮是否可点击

- (void)getBankerInfoWithBankerModel:(BankRepay *)bankModel;//上传银行卡获取银行卡信息

- (void)showProgress:(NSString *)progressString;//显示上传进度

- (void)judePictureUploadingFailure:(BOOL)isFailure;//判断是否有图片上传失败

@end

@interface ZSWSDataCollectionView : UIView

@property (nonatomic,strong)NSIndexPath *indexPath;

//每行显示的单元格个数,默认显示4个
@property (nonatomic,assign)int countOfRow;

//两个单元格的间距,默认是10
@property (nonatomic,assign)float  spacing;

//是否显示表头(就是title),默认显示
@property (nonatomic,assign) BOOL  isShowTitle ;

//表头标题名称
@property (nonatomic,copy  )NSMutableArray *titleNameArray;

//数据源数组
@property (nonatomic,strong)NSMutableArray *itemArray;

//资料细分类id
@property (nonatomic,strong)NSMutableArray *biztemplateItemidArray;

//资料类型
@property (nonatomic,copy  )NSString       *dataCategory;

//被删除的(已上传的)资料的id数组
@property (nonatomic,strong)NSMutableArray *deletdataIDArray ;

////是否有拍摄视频功能,默认为YES
//@property (nonatomic,assign) BOOL   canVideo;

@property (nonatomic,strong)UICollectionView *myCollectionView;

//当前选中的索引
@property (nonatomic,strong)NSIndexPath     *currentIndexPath;

@property (nonatomic,weak)id <ZSWSDataCollectionViewDelegate> delegate ;

//判断此时是否可操作(因为有时候是不能操作上传的),默认是YES
@property (nonatomic,assign)BOOL               selectEnable;

@property (nonatomic,strong)NSMutableArray     *preViewImages;//预览大图数组.(里面添加的是资料对象)

@property (nonatomic,assign) BOOL              isShowAdd;//是否显示添加功能，默认YES

/* 每种资料样式初始化数据源的方式都不一样(都是大数组套小数组格式)。如果小数组为空 ,当样式为ZSAddResourceDataOne时则向里面添加一个空的fileModel。 当样式为ZSAddResourceDataTwo时，向里面添加两个空的fileModel.当样式为ZSAddResourceDataCountless时，不想里面添加空数组
 *
 */
@property (nonatomic,assign) ZSAddResourceDataStyle  addDataStyle;//添加按钮格式

@property (nonatomic,strong) UIButton *bottomBtn;       //底部按钮

@property (nullable, nonatomic, copy) NSString *docId;  //当前的资料iD

@property (nonatomic,assign) BOOL  isShowDelete;           //是否显示删除功能,默认是yes

@property (nonatomic,assign) BOOL   isRightLabelShow;      //右边按钮展示

@property (nonatomic,assign) BOOL   isShowOnly;            //是否来自拍照时的仅仅展示

@property (nonatomic,assign) BOOL   canCut;                //是否能剪切,默认能

@property (nonatomic,assign) BOOL   showCorver;            //显示封面,

@property (nonatomic,assign) BOOL   bool_isFromBanker;     //是否是来自收款银行卡/还款银行卡两项资料

//底部按钮是否可点击
- (void)setBottomBtnEnable:(BOOL)enable;

//获取collectionView坐标
- (CGFloat)resetCollectionViewFrame;

@end
