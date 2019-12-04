//
//  ZSHomeHeaderView.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/29.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSHomeHeaderView.h"
#import "ZSHomeCarouselView.h"
#import "ZSHomeToolButton.h"

#define carouselViewHeight ZSWIDTH/2
#define toolBtnsViewHeight 200
#define noticeLabelHeight  32

@interface ZSHomeHeaderView  ()<ZSHomeCarouselViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) NSArray *imgArray;
@property (nonatomic,strong) NSArray *nameArray;
@property (nonatomic,strong) ZSHomeCarouselView *carouselView; //轮播图
@property (nonatomic,strong) UIView             *prdBgView;    //产品模块
@property (nonatomic,strong) UIScrollView       *prdBgscroll;
@property (nonatomic,strong) UIPageControl      *prdPageCtrl;
@property (nonatomic,strong) UILabel            *noticeLabel;  //小房主快讯
@end

@implementation ZSHomeHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //小工具
        [self configureToolBtnsView];
    }
    return self;
}

#pragma mark /*---------------------------------轮播图---------------------------------*/
- (void)fillInCarouselViewData:(NSArray *)array
{
    self.carouselView = [[ZSHomeCarouselView alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, carouselViewHeight)];
    self.carouselView.delegate = self;
    self.carouselView.currentPageColor = ZSColorWhite;
    self.carouselView.pageColor = ZSColorAlpha(0,0,0,0.5);
    [self addSubview:self.carouselView];
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.carouselView.height-10, ZSWIDTH, 10)];
    imgview.image = [UIImage imageNamed:@"home_bg_n"];
    [self.carouselView addSubview:imgview];
    
    //图片数据
    if (array.count > 0) {
        NSMutableArray *newArray = [[NSMutableArray alloc]init];
        for (ZSHomeCarouselModel *model in array) {
            [newArray addObject:model.carouselUrl];
        }
        self.carouselView.imagesArray = newArray;
    }
    else
    {
        self.carouselView.imagesArray = @[[UIImage imageNamed:@"home_bg_n_default"]];
    }
}

- (void)carouselView:(ZSHomeCarouselView *)carouselView indexOfClickedImageBtn:(NSUInteger )index
{
    if (_delegate && [_delegate respondsToSelector:@selector(indexOfClickedImageBtn:)]) {
        [_delegate indexOfClickedImageBtn:index];
    }
}

#pragma mark /*---------------------------------产品模块---------------------------------*/
- (void)configureToolBtnsView
{
    //底色
    self.prdBgView = [[UIView alloc]initWithFrame:CGRectMake(0, carouselViewHeight, ZSWIDTH, toolBtnsViewHeight)];
    self.prdBgView.backgroundColor = ZSColorWhite;
    [self addSubview:self.prdBgView];
    
    //scroll
    self.prdBgscroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 180)];
    self.prdBgscroll.backgroundColor = ZSColorWhite;
    self.prdBgscroll.bounces = NO;
    self.prdBgscroll.showsHorizontalScrollIndicator = NO;
    self.prdBgscroll.contentSize = CGSizeMake(ZSWIDTH * 2 , 0);//一页显示8个
    self.prdBgscroll.delegate = self;
    self.prdBgscroll.pagingEnabled = YES;
    [self.prdBgView addSubview:self.prdBgscroll];
    
    //page
    self.prdPageCtrl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 180, ZSWIDTH, 20)];
    self.prdPageCtrl.numberOfPages = 2;
    self.prdPageCtrl.currentPage  = 0; //默认第一页页数为0
    self.prdPageCtrl.pageIndicatorTintColor = ZSColorLine;//未选中的颜色
    self.prdPageCtrl.currentPageIndicatorTintColor = ZSColorAllNotice;//选中时的颜色
    [self.prdPageCtrl addTarget:self action:@selector(pageControlValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.prdBgView addSubview:self.prdPageCtrl];
    
    //数据
    _imgArray = @[@"home_starspeedloan_n",@"home_foreclousure_n",@"home_roommortgage_n",@"home_agency_business_n",@"home_onlineapplication_n",@"home_中介端跟进",@"home_witnessdesk_n",@"home_easyLoan",@"home_weixinshenqing",@"home_easyLoan"];
#pragma mark 预生产不显示几个贷款的老大爷
    if ([APPDELEGATE.zsurlHead isEqualToString:KPreProductionUrl] || [APPDELEGATE.zsurlHead isEqualToString:KPreProductionUrl_port])
    {
        _nameArray = @[@"赎楼宝",@"代办业务",@"预授信评估",@"中介端跟进",@"车位分期",@"新房见证"];
    }
    else
    {
        _nameArray = @[@"星速贷",@"赎楼宝",@"抵押贷",@"代办业务",@"预授信评估",@"中介端跟进",@"新房见证",@"融易贷",@"微信申请",@"车位分期"];
    }
    
    //创建按钮
    CGFloat Width_Space = 0;//2个按钮之间的间距
    CGFloat Button_Width = ZSWIDTH/4;//按钮宽度
    CGFloat Button_height = 90;//按钮高度
    for (int i = 0 ; i < _nameArray.count; i++)
    {
        NSInteger index;
        NSInteger page;
        ZSHomeToolButton *toolBtn;
        if (i < 8)
        {
            index = i % 4;
            page = i / 4;
            toolBtn = [[ZSHomeToolButton alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space), page  * (Button_height + Width_Space), Button_Width, Button_height)];
        }
        else
        {
            index = (i-8) % 4;
            page = (i-8) / 4;
            toolBtn = [[ZSHomeToolButton alloc]initWithFrame:CGRectMake(ZSWIDTH + index * (Button_Width + Width_Space), page  * (Button_height + Width_Space), Button_Width, Button_height)];
        }
        [toolBtn addTarget:self action:@selector(toolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        toolBtn.tag = i;
        toolBtn.backgroundColor = ZSColorWhite;
        [self.prdBgscroll addSubview:toolBtn];
        //数据填充
        toolBtn.imgview.image = [UIImage imageNamed:_imgArray[i]];
        toolBtn.label_text.text = _nameArray[i];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentPage = (int)(scrollView.contentOffset.x) / (int)ZSWIDTH;
    self.prdPageCtrl.currentPage = currentPage;//将上述的滚动视图页数重新赋给当前视图页数,进行分页
}

- (void)pageControlValueChange:(UIPageControl *)sender
{
    self.prdBgscroll.contentOffset = CGPointMake(sender.currentPage * ZSWIDTH, 0);
}

- (void)toolBtnClick:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(indexOfClickedToolsBtn:)]) {
        [_delegate indexOfClickedToolsBtn:_nameArray[sender.tag]];
    }
}

#pragma mark /*---------------------------------提示label---------------------------------*/
- (void)configureNoticeLabel
{
    if (self.noticeLabel) {
        return;
    }
    self.noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(GapWidth, 0, ZSWIDTH-GapWidth*2, 32)];
    self.noticeLabel.textColor = ZSPageItemColor;
    self.noticeLabel.text = @"未完成订单";
    self.noticeLabel.font = FontNotice;
    [self addSubview:self.noticeLabel];
}

#pragma mark 设置自己的高度
- (void)resetSelfHeight
{
    self.noticeLabel.frame = CGRectMake(GapWidth, self.prdBgView.bottom, ZSWIDTH-GapWidth*2, 32);
    
    self.height = ZSWIDTH/2 + self.prdBgView.height + self.noticeLabel.height;
}

@end
