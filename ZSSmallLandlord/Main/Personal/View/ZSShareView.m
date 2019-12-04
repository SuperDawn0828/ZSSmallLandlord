
//  ZSSharView.m
//  ZSSmallLandlord
//
//  Created by gengping on 2017/8/18.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSShareView.h"
#import "ZSShareViewCell.h"
#import "ZSWitnessServerPageController.h"

@interface ZSShareView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *collect_share;
@property (nonatomic,strong)UIView *backgroundView_black;
@property (nonatomic,strong)UIView *backgroundView_white;
@end

@implementation ZSShareView

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        [self configureCollectionView];
//    }
//    return self;
//}
- (instancetype)initWithFrame:(CGRect)frame withArray:(NSMutableArray *)titleArray{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureCollectionView:titleArray];
    }
    return self;
}

#pragma mark 首页collectionview
- (void)configureCollectionView:(NSMutableArray *)titleArray
{
    //黑底
    self.backgroundView_black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
    self.backgroundView_black.backgroundColor = ZSColorBlack;
    self.backgroundView_black.alpha = 0.3;
    [self addSubview:self.backgroundView_black];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self.backgroundView_black addGestureRecognizer:tap];
    //白底
    self.backgroundView_white = [[UIView alloc]initWithFrame:CGRectMake(0, ZSHEIGHT - ([self heightWithPicturesCount:titleArray.count] + 44), ZSWIDTH, [self heightWithPicturesCount:titleArray.count] + 44)];
    self.backgroundView_white.backgroundColor = ZSColorWhite;
    self.backgroundView_white.layer.cornerRadius = 3;
    self.backgroundView_white.alpha = 1;
    [self addSubview:self.backgroundView_white];
    
    //collection
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(ZSWIDTH/4, 130);
    self.collect_share = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, [self heightWithPicturesCount:titleArray.count]) collectionViewLayout:flowLayout];
    self.collect_share.dataSource = self;
    self.collect_share.delegate = self;
    self.collect_share.backgroundColor = ZSColorWhite;
    [self.collect_share registerClass:[ZSShareViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.backgroundView_white addSubview:self.collect_share];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.collect_share.bottom, self.width, 0.5)];
    lineView.backgroundColor = ZSColorLine;
    [self.backgroundView_white addSubview:lineView];
    //取消按钮
    self.view_title = [[UIView alloc]initWithFrame:CGRectMake(0, self.collect_share.bottom + 0.5, self.width, 44)];
    self.view_title.backgroundColor = ZSColorWhite;
    self.view_title.hidden = NO;
    [self.backgroundView_white addSubview:self.view_title];
    
    UIButton *btn_title = [[UIButton alloc] initWithFrame:CGRectMake(15,0,ZSWIDTH - 30, 44)];
    [btn_title setTitleColor:ZSPageItemColor forState:UIControlStateNormal];
    btn_title.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn_title setTitle:@"取消" forState:UIControlStateNormal];
    btn_title.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn_title addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view_title addSubview:btn_title];
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.backgroundView_white.frame = CGRectMake(0, ZSHEIGHT - ([self heightWithPicturesCount:self.titleArray.count] + 44), self.width, [self heightWithPicturesCount:self.titleArray.count] + 44);
//    self.collect_home.frame = CGRectMake(0, 0, self.width, [self heightWithPicturesCount:self.titleArray.count]);
//    self.view_title.frame =  CGRectMake(0, self.collect_share.bottom + 0.5, self.width, 44);
//
//}

#pragma mark UICollectionView---Delegate
//定义每个UICollectionView 纵向的间距,最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//跟tableview一样,两个必须实现的制表代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identify = @"cell";
    ZSShareViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.imgview.image = [UIImage imageNamed:self.imgViewArray[indexPath.row]];
    cell.label_text.text = self.titleArray[indexPath.row];
    return cell;
}

//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (_delegate && [_delegate respondsToSelector:@selector(currentSelectTiemTitle:)]){
        [self.delegate currentSelectTiemTitle:self.titleArray[indexPath.row]];
    }
}

#pragma mark show
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView_black.alpha = 0.5;
        self.backgroundView_white.alpha = 1;
    } completion:^(BOOL finished) {
        self.alpha = 1;
    }];
}

#pragma mark dismiss
- (void)dismiss{
    [UIView animateWithDuration:0.1 animations:^{
        self.backgroundView_white.alpha = 0;
        self.backgroundView_black.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.backgroundView_black removeFromSuperview];
    }];
}

//重设本身的高度 需要每行显示几张图以及图片总数
- (CGFloat)heightWithPicturesCount:(NSInteger)pictureNum {
    CGFloat height = 0;
    NSInteger lineNum = 4;
//    CGFloat clearance = 10;//间隙
//    CGFloat width = (ZSWIDTH-30- (lineNum-1)*clearance)/lineNum;//图片宽度
    int row;
    if (pictureNum/lineNum >=0 && pictureNum%lineNum == 0) {
        row = (int)(pictureNum/lineNum);
    }else
    {
        row = (int)(pictureNum/lineNum) + 1;
    }
//    height = row*(width+clearance) + 10;
    height = row*130 + 10;
    return height;
}

- (NSMutableArray *)titleArray {
    if (_titleArray == nil){
        _titleArray = [[NSMutableArray alloc]init];
    }
    return _titleArray;
}

- (NSMutableArray *)imgViewArray {
    if (_imgViewArray == nil){
        _imgViewArray = [[NSMutableArray alloc]init];
    }
    return _imgViewArray;
}
@end
