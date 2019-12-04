//
//  ZSTextWithPhotosTableViewCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/5/17.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSPCOrderDetailPhotoCell.h"
#import "ZSSLDataCollectionView.h"

@interface ZSPCOrderDetailPhotoCell ()<ZSSLDataCollectionViewDelegate>
@property (nonatomic,strong) ZSSLDataCollectionView *dataCollectionView;
@property (nonatomic,strong) UILabel                *leftLabel;
@property (nonatomic,strong) UIView                 *lineView;
@end

@implementation ZSPCOrderDetailPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.backgroundColor = ZSColorWhite;
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    //datacollectionView
    self.dataCollectionView = [[ZSSLDataCollectionView alloc]init];
    self.dataCollectionView.frame = CGRectMake(0, 10, ZSWIDTH, self.height-20);
    self.dataCollectionView.delegate = self;
    self.dataCollectionView.myCollectionView.scrollEnabled = NO;
    self.dataCollectionView.addDataStyle = ZSAddResourceDataCountless;//添加照片的形式
    self.dataCollectionView.titleNameArray = [[NSMutableArray alloc]initWithObjects:@"随便传什么只要数组不为空就可以", nil];
    self.dataCollectionView.isShowAdd = NO;
    self.dataCollectionView.hidden = YES;
    self.dataCollectionView.myCollectionView.hidden = YES;
    [self addSubview :self.dataCollectionView];
    
    //提示label(用于盖住collectionView的header)
    self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight)];
    self.leftLabel.font = [UIFont systemFontOfSize:15];
    self.leftLabel.textColor = ZSColorListLeft;
    self.leftLabel.backgroundColor = ZSColorWhite;
    [self addSubview:self.leftLabel];
}

#pragma mark 赋值
- (void)setModel:(ZSDynamicDataModel *)model
{
    _model = model;
    
    //提示label
    if (model.isNecessary.intValue == 0) {
        self.leftLabel.text = [NSString stringWithFormat:@"    %@",model.fieldMeaning];
    }
    else {
        NSString *titleString = [NSString stringWithFormat:@"    %@ *",model.fieldMeaning];
        NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:titleString];
        [mutableStr addAttribute:NSForegroundColorAttributeName value:ZSColorRed range:NSMakeRange(titleString.length-1, 1) ];
        self.leftLabel.attributedText = mutableStr;
    }
    
    if (model.rightData.length)
    {
        self.dataCollectionView.hidden = NO;
        self.dataCollectionView.myCollectionView.hidden = NO;
        
        //给collectionview赋值
        NSMutableArray *dataArray = @[].mutableCopy;
        NSArray *array = [model.rightData componentsSeparatedByString:@","];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZSWSFileCollectionModel *fileModel = [[ZSWSFileCollectionModel alloc]init];
            fileModel.dataUrl = array[idx];
            fileModel.dataId = @"";
            [dataArray addObject:fileModel];
        }];
        NSMutableArray *itemDataArray = [[NSMutableArray alloc]initWithObjects:dataArray,nil];
        self.dataCollectionView.itemArray = itemDataArray;
        [self.dataCollectionView.myCollectionView reloadData];
        [self.dataCollectionView layoutSubviews];
        self.dataCollectionView.height = self.dataCollectionView.myCollectionView.height;
        //刷新当前cell的高度
        if (_delegate && [_delegate respondsToSelector:@selector(sendCurrentCellHeight:withIndex:)]){
            [_delegate sendCurrentCellHeight:self.dataCollectionView.myCollectionView.height
                                   withIndex:self.currentIndex];
        }
    }
    //啥都没,隐藏
    else
    {
        self.dataCollectionView.hidden = YES;
        self.dataCollectionView.myCollectionView.hidden = YES;
    }
}

#pragma mark /*-------------------------------ZSSLDataCollectionViewDelegate-------------------------------------------*/
//重置collview高度代理
- (void)refershDataCollectionViewHegiht
{
    [self.dataCollectionView layoutSubviews];
    self.dataCollectionView.height = self.dataCollectionView.myCollectionView.height;
    
    //刷新当前cell的高度
    if (_delegate && [_delegate respondsToSelector:@selector(sendCurrentCellHeight:withIndex:)]){
        [_delegate sendCurrentCellHeight:self.dataCollectionView.myCollectionView.height
                               withIndex:self.currentIndex];
    }
}

@end
