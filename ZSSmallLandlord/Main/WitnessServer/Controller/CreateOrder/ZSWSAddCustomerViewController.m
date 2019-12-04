//
//  ZSWSAddCustomerViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ZSWSAddCustomerViewController.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "ZSWSPersonListViewController.h"
#import "ZSInputOrSelectView.h"
#import "IDCardViewController.h"
#import "ZSWSChooseProvinceViewController.h"
#import "IdInfo.h"
#import "DictManager.h"
#import "ZSWSPageController.h"
#import "PYPhotoBrowseView.h"

#define pageFlowViewHEIGHT (ZSWIDTH - 75)/1.58+24+40//pageFlowView高

typedef NS_ENUM(NSUInteger, alertViewTag)
{
    deletePersonTag   = 0,     //删除人员信息
    changeMarryTag    = 1998,  //修改婚姻状况
    noticeTag         = 9,     //信息不回保存提示
    scanTag           = 11,    //扫描
    openCameraFailTag = 1,     //相机打开失败
    noRecheckTag      = 1992,  //是否重新查征信
};

typedef NS_ENUM(NSUInteger, actionSheetwTag)
{
    marryStateTag    = 1992,   //婚姻状况/是否为共有人/与贷款人关系
    bigDataStateTag  = 1998,   //大数据风控
    bankReferenceTag = 2000,   //央行征信
    IDcardFrontTag   = 0,      //身份证正面
    IDcardBackTag    = 1,      //身份证反面
    authorizationTag = 2,      //授权书
};

@interface ZSWSAddCustomerViewController ()<UITextFieldDelegate,UITextViewDelegate,NewPagedFlowViewDelegate,NewPagedFlowViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZSActionSheetViewDelegate,ZSInputOrSelectViewDelegate,ZSAlertViewDelegate,IDCamCotrllerDelegate,ZSPickerViewDelegate>
@property(nonatomic,strong)UIScrollView             *scrollview;          //scrollview
@property(nonatomic,strong)NewPagedFlowView         *pageFlowView;        //滚动图
@property(nonatomic,strong)NSMutableArray           *imageArray;          //顶部三张身份证图片数组
@property(nonatomic,strong)UILabel                  *indicateLabel;       //提示label
@property(nonatomic,strong)NSArray                  *indicateArray;       //提示label显示的文字
@property(nonatomic,assign)NSInteger                buttonInteger;        //顶部身份证照片选中的哪一张
@property(nonatomic,strong)UIView                   *currentTapView;      //顶部身份证照片选中的哪一张view
@property(nonatomic,strong)ZSInputOrSelectView      *nameView;            //姓名
@property(nonatomic,strong)ZSInputOrSelectView      *IDcardView;          //身份证号
@property(nonatomic,strong)UILabel                  *idCardLabelVaild;   //身份证号有效期label
@property(nonatomic,copy  )NSString                 *string_iDcardVaild;  //身份证号有效期label
@property(nonatomic,strong)ZSInputOrSelectView      *phoneNumView;        //手机号
@property(nonatomic,strong)ZSInputOrSelectView      *marryView;           //婚姻状况/是否为共有人/与贷款人关系
@property(nonatomic,strong)ZSInputOrSelectView      *bigDataView;         //大数据风控
@property(nonatomic,strong)ZSInputOrSelectView      *bankReferenceView;   //央行征信
@property(nonatomic,strong)ZSInputOrSelectView      *provinceView;        //省市区
@property(nonatomic,strong)ZSInputOrSelectView      *detailAddressView;   //详细地址
@property(nonatomic,copy  )NSString                 *marryLabelNotice;    //根据不同人员信息的提示
@property(nonatomic,assign)NSInteger                numOfRow;             //创建订单时,担保人配偶3行,其余4行;编辑的时候可以添加省市区,担保人配偶7行,其余8行
@property(nonatomic,copy  )NSString                 *urlFront;            //身份证正面照片
@property(nonatomic,copy  )NSString                 *urlBack;             //身份证背面照片
@property(nonatomic,copy  )NSString                 *urlAuthor;           //授权书照片
@property(nonatomic,copy  )NSString                 *currentProID;        //当前选中的省id,用于接口请求
@property(nonatomic,copy  )NSString                 *currentCitID;        //当前选中的城市id,用于接口请求
@property(nonatomic,copy  )NSString                 *currentAreID;        //当前选中的区id,用于接口请求
@property(nonatomic,copy  )NSString                 *currentProName;      //当前选中的省名称,用于刷新上个页面数据
@property(nonatomic,copy  )NSString                 *currentCitName;      //当前选中的城市名称,用于刷新上个页面数据
@property(nonatomic,copy  )NSString                 *currentAreName;      //当前选中的区名称,用于刷新上个页面数据
@property(nonatomic,copy  )NSString                 *currentMarrayState;  //记录当前婚姻状况,用于判断将婚姻从已婚修改至其他情况的判断
@property(nonatomic,assign)NSInteger                i_phoneNumber;        //用来设置输入手机号做空格用
@property(nonatomic,assign)BOOL                     isChangeAnyData;      //返回提示信息未保存
@end

@implementation ZSWSAddCustomerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self setUIWithRoleType];
    [self setLeftBarButtonItem];//返回按钮
    [self initScrollView];//创建view
    [DictManager InitDict];//初始化判断 bundleIdentifier是否和静态库一致
    //Data
    [self fillInData];
    [NOTI_CENTER addObserver:self selector:@selector(changePhotoFormat) name:@"KSUpdatePhotos" object:nil];//提前通知图片格式转换
}

#pragma mark 返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.isChangeAnyData)
    {
        [self leftAction];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)leftAction
{
    if (self.isChangeAnyData)
    {
        ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"退出后信息将不会被保存" sureTitle:@"确定" cancelTitle:@"取消"];
        alert.tag = noticeTag;
        alert.delegate = self;
        [alert show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showBackNotice
{
    ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"退出后信息将不会被保存" sureTitle:@"确定" cancelTitle:@"取消"];
    alert.tag = noticeTag;
    alert.delegate = self;
    [alert show];
}

#pragma mark 创建view
- (void)initScrollView
{
    //整体竖着的scroll
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-60)];
    self.scrollview.contentSize = CGSizeMake(ZSWIDTH, pageFlowViewHEIGHT+10+CellHeight*self.numOfRow+74);
    self.scrollview.bounces = NO;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollview];
    //三张图片
    for (int i=0; i<3; i++) {
        UIImage *slideimage = [UIImage imageNamed:[NSString stringWithFormat:@"identification_photo0%d.png",i]];
        [self.imageArray addObject:slideimage];
    }
    [self AddpageFlowView];//顶部身份证照片等
    [self AddBottomMessageView];//底部的人员相关文字信息
}

- (void)AddpageFlowView
{
    self.pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0 -15, ZSWIDTH, pageFlowViewHEIGHT)];
    self.pageFlowView.backgroundColor = ZSViewBackgroundColor;
    self.pageFlowView.delegate = self;
    self.pageFlowView.dataSource = self;
    self.pageFlowView.minimumPageAlpha = 0.1;//透明比例
    self.pageFlowView.minimumPageScale = 0.85;//缩放比例
    self.pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    self.pageFlowView.isOpenAutoScroll = YES;//是否开启自动滚动,
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowViewHEIGHT-5 , ZSWIDTH, 4)];
    self.pageFlowView.pageControl = pageControl;
    pageControl.currentPageIndicatorTintColor = ZSColor(255, 107, 97);//灰点
    pageControl.pageIndicatorTintColor = ZSColor(194,194,194); //红点
    [self.scrollview addSubview:pageControl];
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [bottomScrollView addSubview:self.pageFlowView];
    [self.scrollview addSubview:bottomScrollView];
    //刷新
    [self.pageFlowView reloadData];
    //三个提示label
    [self.scrollview addSubview:self.indicateLabel];
}

- (void)AddBottomMessageView//底部的人员相关文字信息
{
    //姓名
    self.nameView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, pageFlowViewHEIGHT+10, ZSWIDTH, CellHeight) withInputAction:@"姓名 *" withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDefault];
    self.nameView.inputTextFeild.delegate = self;
    [self.nameView.inputTextFeild addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.scrollview addSubview:self.nameView];
  
    //身份证号
    self.IDcardView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.nameView.bottom, ZSWIDTH, CellHeight) withInputAction:@"身份证号 *" withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    self.IDcardView.inputTextFeild.delegate = self;
    [self.IDcardView.inputTextFeild addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.scrollview addSubview:self.IDcardView];
  
    //手机号
    NSString *phoneString = [self.title isEqualToString:@"贷款人信息"] ? @"手机号 *" : @"手机号";
    self.phoneNumView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.IDcardView.bottom, ZSWIDTH, CellHeight) withInputAction:phoneString withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeNumberPad];
    self.phoneNumView.inputTextFeild.delegate = self;
    [self.phoneNumView.inputTextFeild addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.scrollview addSubview:self.phoneNumView];
    self.i_phoneNumber = 0;
   
    //婚姻状况/与贷款人关系/是否为共有人
    if (![self.title isEqualToString:@"担保人配偶"]) {
        self.marryView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.phoneNumView.bottom, ZSWIDTH, CellHeight) withClickAction:[NSString stringWithFormat:@"%@ *",self.marryLabelNotice]];
        self.marryView.delegate = self;
        [self.scrollview addSubview:self.marryView];
    }
  
    //大数据风控
    CGFloat y = self.marryView ? self.marryView.bottom : self.phoneNumView.bottom;
    self.bigDataView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, y, ZSWIDTH, CellHeight) withClickAction:@"大数据风控 *"];
    self.bigDataView.delegate = self;
    [self.scrollview addSubview:self.bigDataView];
    if (self.isFromAdd) {
        self.bigDataView.rightLabel.text = @"查询";//默认显示查询
        self.bigDataView.rightLabel.textColor = ZSColorListRight;
    }
 
    //央行征信
    self.bankReferenceView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.bigDataView.bottom, ZSWIDTH, CellHeight) withClickAction:@"央行征信 *"];
    self.bankReferenceView.delegate = self;
    [self.scrollview addSubview:self.bankReferenceView];
  
    //省市区
    if (self.isFromEditor) {
        self.provinceView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.bankReferenceView.bottom, ZSWIDTH, CellHeight) withClickAction:@"省市区"];
        self.provinceView.delegate = self;
        [self.scrollview addSubview:self.provinceView];
        //详细地址
        self.detailAddressView = [[ZSInputOrSelectView alloc]initTextViewWithFrame:CGRectMake(0, self.provinceView.bottom, ZSWIDTH, CellHeight) withInputAction:@"详细地址" withRightTitle:@"请输入详细地址信息" withKeyboardType:UIKeyboardTypeDefault];
        self.detailAddressView.inputTextView.delegate = self;
        [self.scrollview addSubview:self.detailAddressView];
        //textView内容变化时调用
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ValueChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
  
    //保存
    [self configuBottomButtonWithTitle:@"保存" OriginY:pageFlowViewHEIGHT+CellHeight*self.numOfRow+15+10];
    [self setBottomBtnEnable:NO];//默认不可点击
    [self.scrollview addSubview:self.bottomBtn];
}

#pragma mark 根据角色设置UI
- (void)setUIWithRoleType
{
    if ([self.title isEqualToString:@"贷款人信息"])
    {
        self.marryLabelNotice = @"婚姻状况";
        self.numOfRow = self.isFromAdd ? 6 : 8;
    }
    else if ([self.title isEqualToString:@"贷款人配偶信息"])
    {
        self.marryLabelNotice = @"是否为共有人";
        self.numOfRow = 6;
    }
    else if ([self.title isEqualToString:@"共有人信息"])
    {
        self.marryLabelNotice = @"与贷款人关系";
        self.numOfRow = 6;
    }
    else if ([self.title isEqualToString:@"担保人信息"])
    {
        self.marryLabelNotice = @"婚姻状况";
        self.numOfRow = 6;
    }
    else if ([self.title isEqualToString:@"担保人配偶信息"])
    {
        self.numOfRow = 5;
        self.marryView.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark /*--------------------------------数据处理-------------------------------------------*/
#pragma mark 编辑人员信息的时候是有数据的--数据填充
- (void)fillInData
{
    //编辑人员信息
    if (self.isFromEditor && global.wsCustInfo.name.length)
    {
        //根据订单状态判断是否可编辑:征信查询提交前所有所有信息都可以进行修改，征信查询提交后，身份证正面、身份证反面、姓名、身份证号不允许进行编辑
        if (global.wsOrderDetail.projectInfo.orderState.intValue != 1) {
            self.nameView.inputTextFeild.userInteractionEnabled = NO;
            self.IDcardView.inputTextFeild.userInteractionEnabled = NO;
        }
        //手机号
        if ([self.title isEqualToString:@"贷款人信息"]) {
            self.phoneNumView.leftLabel.attributedText = [@"手机号" addStar];//主贷人手机号为必填
        }else{
            self.phoneNumView.leftLabel.text = @"手机号";//其他角色手机号为非必填
            [self configureRightNavItemWithTitle:nil withNormalImg:@"head_delete_n" withHilightedImg:@"head_delete_n"];//删除人员角色按钮
        }
        self.marryView.leftLabel.attributedText = [self.marryLabelNotice addStar];
        //身份证正面照
        if (global.wsCustInfo.identityPos) {
            if (global.wsCustInfo.identityPos.length) {
                [self.imageArray replaceObjectAtIndex:0 withObject:[self imageWithData:global.wsCustInfo.identityPos]];
                self.urlFront = global.wsCustInfo.identityPos;
            }
        }
        //身份证反面照
        if (global.wsCustInfo.identityBak) {
            if (global.wsCustInfo.identityBak.length) {
                [self.imageArray replaceObjectAtIndex:1 withObject:[self imageWithData:global.wsCustInfo.identityBak]];
                self.urlBack = global.wsCustInfo.identityBak;
            }
        }
        //授权书
        if (global.wsCustInfo.authorizeImg) {
            if (global.wsCustInfo.authorizeImg.length) {
                [self.imageArray replaceObjectAtIndex:2 withObject:[self imageWithData:global.wsCustInfo.authorizeImg]];
                self.urlAuthor = global.wsCustInfo.authorizeImg;
            }
        }
        [self.pageFlowView reloadData];
        //姓名
        if (global.wsCustInfo.name) {
            self.nameView.inputTextFeild.text = global.wsCustInfo.name;
        }
        //身份证号
        if (global.wsCustInfo.identityNo) {
            self.IDcardView.inputTextFeild.text = global.wsCustInfo.identityNo;
        }
        //手机号
        if (global.wsCustInfo.cellphone) {
            if (global.wsCustInfo.cellphone.length) {
                self.phoneNumView.inputTextFeild.text = [ZSTool addTheBlankSpace:global.wsCustInfo.cellphone];
            }
        }
        //婚姻状况/与贷款人关系/是否为共有人
        if ([self.title isEqualToString:@"担保人配偶"]) {
            [self.marryView removeFromSuperview];
            self.marryView  = nil;
            [self resetViewFrame];
        }
        self.marryView.rightLabel.textColor = ZSColorListRight;
        self.marryView.rightLabel.text = [NSString setRelationByRelation:global.wsCustInfo];
        if (global.wsCustInfo.releation) {
            if ([global.wsCustInfo.releation intValue] == 1 || [global.wsCustInfo.releation intValue] == 5) {//婚姻状况
                if (global.wsCustInfo.beMarrage) {
                    self.currentMarrayState = [ZSGlobalModel getMarrayStateWithCode:global.wsCustInfo.beMarrage];
                }
            }
        }
        //是否查询大数据风控
        if (global.wsCustInfo.isRiskData) {
            if (global.wsCustInfo.isRiskData.length) {
                self.bigDataView.rightLabel.text = [ZSGlobalModel getBigDataStateWithCode:global.wsCustInfo.isRiskData];
                self.bigDataView.rightLabel.textColor = ZSColorListRight;
                //1.提交征信之前,订单创建人可随意修改; 提交征信之后,不查询可以修改至查询
                if (![global.wsOrderDetail.projectInfo.orderState isEqualToString:@"待提交征信查询"] && ![global.wsOrderDetail.projectInfo.orderState isEqualToString:@"1"])
                {
                    if (![global.wsCustInfo.isRiskData isEqualToString:@"1"]) {
                        self.bigDataView.delegate = self;//不查询可以修改至查询
                    }else {
                        self.bigDataView.delegate = nil;
                    }
                }
            }
        }
        //是否查询央行征信
        if (global.wsCustInfo.isBankCredit) {
            if (global.wsCustInfo.isBankCredit.length) {
                self.bankReferenceView.rightLabel.text = [ZSGlobalModel getBigDataStateWithCode:global.wsCustInfo.isBankCredit];
                self.bankReferenceView.rightLabel.textColor = ZSColorListRight;
                if ([self.bankReferenceView.rightLabel.text isEqualToString:@"查询"]) {
                    self.indicateArray = [NSArray arrayWithObjects:@"身份证正面(必填)",@"身份证反面(必填)",@"征信授权书(必填)",nil];
                }else{
                    self.indicateArray = [NSArray arrayWithObjects:@"身份证正面(必填)",@"身份证反面(必填)",@"征信授权书",nil];
                }
                //1.提交征信之前,订单创建人可随意修改; 提交征信之后,不查询可以修改至查询
                if (![global.wsOrderDetail.projectInfo.orderState isEqualToString:@"待提交征信查询"] && ![global.wsOrderDetail.projectInfo.orderState isEqualToString:@"1"])
                {
                    if (![global.wsCustInfo.isBankCredit isEqualToString:@"1"]) {
                        self.bankReferenceView.delegate = self;//不查询可以修改至查询
                    }else {
                        self.bankReferenceView.delegate = nil;
                    }
                }
            }
        }
        //省市区
        if (global.wsCustInfo.province) {
            if (global.wsCustInfo.province.length) {
                self.provinceView.rightLabel.text = [NSString stringWithFormat:@"%@ %@ %@",global.wsCustInfo.province,global.wsCustInfo.city,global.wsCustInfo.area];
                self.provinceView.rightLabel.textColor = ZSColorListRight;
                self.currentProID = global.wsCustInfo.provinceId;
                self.currentCitID = global.wsCustInfo.cityId;
                self.currentAreID = global.wsCustInfo.areaId;
                self.currentProName = global.wsCustInfo.province;
                self.currentCitName = global.wsCustInfo.city;
                self.currentAreName = global.wsCustInfo.area;
            }else{
                self.provinceView.rightLabel.text = KPlaceholderChoose;
                self.provinceView.rightLabel.textColor = ZSColorAllNotice;
            }
        }
        //详细地址
        if (global.wsCustInfo.address) {            
            if (global.wsCustInfo.address.length) {
                self.detailAddressView.inputTextView.text = global.wsCustInfo.address;
                self.detailAddressView.placeholderLabel.hidden = YES;
                //单行右对齐, 多行左对齐
                NSString *string_Q = SafeStr(global.wsCustInfo.address);
                CGSize size = CGSizeMake(ZSWIDTH-115-16,1000);
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil];
                CGSize labelsize = [string_Q boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|
                                    NSStringDrawingUsesLineFragmentOrigin  |
                                    NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
                if (labelsize.height > 17.900391) {//不要问我这个数字怎么来的,当行的时候打印啊哈哈哈哈哈哈哈哈哈
                    self.detailAddressView.inputTextView.textAlignment = NSTextAlignmentLeft;
                }
                if (labelsize.height > CellHeight) {
                    self.detailAddressView.height = labelsize.height+20;
                    self.detailAddressView.inputTextView.height = self.detailAddressView.height;
                    self.detailAddressView.lineView.top = self.detailAddressView.height-0.5;
                }
                //重设其他view的frame
                [self resetViewFrame];
            }else{
                self.detailAddressView.placeholderLabel.hidden = NO;
            }
        }
        //除主贷人以外,隐藏省市区和详细地址
        if (self.numOfRow != 8) {
            self.provinceView.hidden = YES;
            self.detailAddressView.hidden = YES;
            self.bottomBtn.top = pageFlowViewHEIGHT+CellHeight*self.numOfRow+15+10;
        }
        //检测底部按钮点击
        [self CheckBottomBtnClick];
    }
}

- (UIImage *)imageWithData:(NSString *)urlString
{
    NSData *dataPos = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?w=300",APPDELEGATE.zsImageUrl,urlString]]];
    UIImage *imagePos = [UIImage imageWithData:dataPos];
    if (imagePos == nil) {
        imagePos = defaultImage_rectangle;
    }
    return imagePos;
}

#pragma mark 删除人员信息
- (void)RightBtnAction:(UIButton*)sender
{
    NSString *noticeString;
    if ([self.title isEqualToString:@"担保人信息"])
    {
        noticeString =  [self checkMyMate] ? @"删除后信息将无法恢复，是否确认删除?" : @"删除后信息将无法恢复，同时卖方配偶信息会一并删除，是否确认删除?";
    }
    else {
        noticeString = @"删除后信息将无法恢复，是否确认删除?";
    }
    
    ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:noticeString sureTitle:@"确定" cancelTitle:@"取消"];
    alert.delegate = self;
    alert.tag = deletePersonTag;
    [alert show];
}

#pragma mark ZSAlertViewDelegate -- 确认按钮响应
- (void)AlertView:(ZSAlertView *)alert
{
    if (alert.tag == openCameraFailTag) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    else if (alert.tag == deletePersonTag){//删除人员信息接口调用
        NSMutableDictionary *parameterDict = @{
                                               @"orderNo":global.wsCustInfo.orderId,
                                               @"custNo":global.wsCustInfo.tid
                                               }.mutableCopy;
        __weak typeof(self) weakSelf = self;
        [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getDeleteCustomer] SuccessBlock:^(NSDictionary *dic) {
            //通知订单详情刷新
            [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
            //删除成功返回人员列表页
            [weakSelf backAction];
        } ErrorBlock:^(NSError *error) {
        }];
    }
    else if (alert.tag == changeMarryTag){//修改婚姻状况
        [self createOrder];
    }
    else if (alert.tag == noticeTag){//返回信息不回保存
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (alert.tag == scanTag){//扫描失败
        [self imagePicker];
    }
}

- (void)backAction
{
//    NSLog(@"子控制器:%@",self.navigationController.viewControllers);
    NSArray *array = self.navigationController.viewControllers;
    if ([array[array.count-2] isKindOfClass:[ZSWSPersonListViewController class]]) {//如果上个控制器为人员列表
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:array.count-2] animated:YES];
    }else if([array[array.count-3] isKindOfClass:[ZSWSPageController class]]){//如果上上个控制器为人员列表
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:array.count-3] animated:YES];
    }else{
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:array.count-2] animated:YES];
    }
}

#pragma mark 保存--创建订单
- (void)bottomClick:(UIButton *)sender
{
    //先开启点击事件,点击的时候提示没上传征信授权书,和安卓保持一致
    if ([self.bankReferenceView.rightLabel.text isEqualToString:@"查询"]) {
        if (!self.urlAuthor) {
            [ZSTool showMessage:@"请上传征信授权书" withDuration:DefaultDuration];
            return;
        }
    }
    //再次判断一下身份证号
    if (![ZSTool checkUserIDCard:self.IDcardView.inputTextFeild.text]) {
        [ZSTool showMessage:@"请输入正确的身份证号" withDuration:DefaultDuration];
        return;
    }
    //主贷人再次判断一下手机号
    if ([self.title isEqualToString:@"贷款人信息"] && ![ZSTool isMobileNumber:self.phoneNumView.inputTextFeild.text]){
        [ZSTool showMessage:@"请输入正确的手机号" withDuration:DefaultDuration];
        return;
    }
    //如果填了手机号就判断一下手机号
    if (self.phoneNumView.inputTextFeild.text.length>0 && ![ZSTool isMobileNumber:self.phoneNumView.inputTextFeild.text]){
        [ZSTool showMessage:@"请输入正确的手机号" withDuration:DefaultDuration];
        return;
    }
    //判断婚姻状况是否从已婚修改成其他
    if ([self.currentMarrayState isEqualToString:@"已婚"] && ![self.marryView.rightLabel.text isEqualToString:@"已婚"]) {
        if ([self.title isEqualToString:@"贷款人信息"]) {
            if (![self checkMyMate]) {
                NSString *sting = [NSString stringWithFormat:@"您已将婚姻状况改为%@,配偶信息将被清除,是否确认变更?",self.marryView.rightLabel.text];
                ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:sting sureTitle:@"确认" cancelTitle:@"取消"];
                alert.delegate = self;
                alert.tag = changeMarryTag;
                [alert show];
                return;
            }
        }
        if ([self.title isEqualToString:@"担保人信息"]) {
            if (![self checkBondsmanMate]) {
                NSString *sting = [NSString stringWithFormat:@"您已将婚姻状况改为%@,配偶信息将被清除,是否确认变更?",self.marryView.rightLabel.text];
                ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:sting sureTitle:@"确认" cancelTitle:@"取消"];
                alert.delegate = self;
                alert.tag = changeMarryTag;
                [alert show];
                return;
            }
        }
    }
//    //提示是否查询征信
//    if (global.wsOrderDetail.projectInfo.orderState.intValue != 1 && !self.isFromEditor && ![self.title isEqualToString:@"贷款人信息"]) {
//        NSString *sting = [NSString stringWithFormat:@"已新增%@“%@(%@)”信息，是否查询征信?",self.title,self.nameView.inputTextFeild.text,self.IDcardView.inputTextFeild.text];
//        ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:sting sureTitle:@"查询" cancelTitle:@"不查询"];
//        alert.delegate = self;
//        alert.tag = noRecheckTag;
//        [alert show];
//        return;
//    }
    //数据请求--提交人员信息
    [self createOrder];
}

- (void)createOrder
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@"提交中"];
    [ZSRequestManager requestWithParameter:[self getCreateUserParamter] url:[ZSURLManager getAddOrEditorCustomer] SuccessBlock:^(NSDictionary *dic){
        //存值
        global.wsOrderDetail = [ZSWSOrderDetailModel yy_modelWithDictionary:dic[@"respData"]];
        NSArray *array = dic[@"respData"][@"custInfo"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                global.wsCustInfo = [CustInfo yy_modelWithJSON:dict];
            }
        }
        //通知所有列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        //通知订单详情刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
        //页面跳转
        if (weakSelf.isFromAdd) {
            if (weakSelf.isFromOrderdetail) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                ZSWSPersonListViewController *addListVC = [[ZSWSPersonListViewController alloc]init];
                addListVC.TypeOfself = addCustomer;//页面类型
                addListVC.orderIDString = global.wsCustInfo.orderId;//订单id
                [weakSelf.navigationController pushViewController:addListVC animated:YES];
            }
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 创建订单请求的参数
- (NSMutableDictionary *)getCreateUserParamter
{
    NSMutableDictionary *parameter = @{
                                       @"name":self.nameView.inputTextFeild.text,
                                       @"identityNo":self.IDcardView.inputTextFeild.text,
                                       }.mutableCopy;
    //身份证正面
    [parameter setObject:self.urlFront forKey:@"identityPosUrl"];
    //身份证背面
    [parameter setObject:self.urlBack forKey:@"identityBakUrl"];
    //授权书
    if (self.urlAuthor) {
        [parameter setObject:self.urlAuthor forKey:@"authorizeImgUrl"];
    }else{
        [parameter setObject:@"" forKey:@"authorizeImgUrl"];
    }
    //手机号
    [parameter setObject:![self.phoneNumView.inputTextFeild.text isEqualToString:KPlaceholderInput] ? [ZSTool filteringTheBlankSpace:self.phoneNumView.inputTextFeild.text] : @"" forKey:@"cellphone"];
    //订单id
    [parameter setObject:self.orderIDString ? self.orderIDString : @"" forKey:@"orderNo"];
    //人员id
    if (self.isFromAdd) {
        [parameter setObject:@"" forKey:@"tid"];
    }else{
        [parameter setObject:global.wsCustInfo.tid ? global.wsCustInfo.tid : @"" forKey:@"tid"];
    }
    //省份id
    [parameter setObject:self.currentProID ? self.currentProID : @"" forKey:@"provinceId"];
    //城市id
    [parameter setObject:self.currentCitID ? self.currentCitID : @"" forKey:@"cityId"];
    //区id
    [parameter setObject:self.currentAreID ? self.currentAreID : @"" forKey:@"areaId"];
    //详细地址
    if (self.detailAddressView.inputTextView.text.length > 0) {
        [parameter setObject:self.detailAddressView.inputTextView.text forKey:@"address"];
    }else{
        [parameter setObject:@"" forKey:@"address"];
    }
    //婚姻状况(贷款人和担保人的选项) 1未婚 2已婚 3离异 4丧偶
    if ([self.title isEqualToString:@"贷款人信息"] || [self.title isEqualToString:@"担保人信息"]) {
        [parameter setObject:[ZSGlobalModel getMarrayCodeWithState:self.marryView.rightLabel.text] forKey:@"beMarrage"];
    }else{
        [parameter setObject:@"" forKey:@"beMarrage"];
    }
    //与贷款人的关系(共有人的选项) 0直系亲属 1配偶 2朋友
    if ([self.title isEqualToString:@"共有人信息"]) {
        if ([self.marryView.rightLabel.text isEqualToString:@"直系亲属"]) {
            [parameter setObject:@"0" forKey:@"lenderReleation"];
        }
        if ([self.marryView.rightLabel.text isEqualToString:@"配偶"]) {
            [parameter setObject:@"1" forKey:@"lenderReleation"];
        }
        if ([self.marryView.rightLabel.text isEqualToString:@"朋友"]) {
            [parameter setObject:@"2" forKey:@"lenderReleation"];
        }
    }else{
        [parameter setObject:@"" forKey:@"lenderReleation"];
    }
    //人员角色 1贷款人 2配偶 3配偶&共有人 4共有人 5担保人 6担保人配偶
    [parameter setObject:[ZSGlobalModel getReleationCodeWithState:self.title] forKey:@"releation"];
    //是否为共有人(配偶的选项) 0是 1否
    if ([self.title isEqualToString:@"贷款人配偶信息"]) {
        if ([self.marryView.rightLabel.text isEqualToString:@"是"]) {
            [parameter setObject:@"0" forKey:@"idendity"];
            [parameter setObject:@"3" forKey:@"releation"];
        }
        if ([self.marryView.rightLabel.text isEqualToString:@"否"]) {
            [parameter setObject:@"1" forKey:@"idendity"];
            [parameter setObject:@"2" forKey:@"releation"];
        }
    }else{
        [parameter setObject:@"" forKey:@"idendity"];
    }
    //是否查询银行征信 0不查询 1查询
    [parameter setObject:[ZSGlobalModel getBigDataCodeWithState:self.bankReferenceView.rightLabel.text] forKey:@"bankrCredit"];
    //是否查询大数据风控 0不查询 1查询
    [parameter setObject:[ZSGlobalModel getBigDataCodeWithState:self.bankReferenceView.rightLabel.text] forKey:@"isBigDataCreditInfo"];
    //身份证有效期时间
    if (self.string_iDcardVaild) {
        [parameter setObject:self.string_iDcardVaild forKey:@"identityExpiredDate"];
    }else{
        [parameter setObject:@"" forKey:@"identityExpiredDate"];
    }
    return parameter;
}

#pragma mark /*--------------------------------底部输入框相关-------------------------------------------*/
#pragma mark 监听输入框状态
- (void)textFieldTextChange:(UITextField *)textField
{
    self.isChangeAnyData = YES;//用于返回提示信息未保存

    //用于给手机号插入空格
    if (textField == self.phoneNumView.inputTextFeild) {
        if (textField.text.length > self.i_phoneNumber) {
            if (textField.text.length == 4 || textField.text.length == 9 ) {//输入
                NSMutableString * str = [[NSMutableString alloc ] initWithString:textField.text];
                [str insertString:@" " atIndex:(textField.text.length-1)];
                textField.text = str;
            }if (textField.text.length >= 13 ) {//输入完成
                textField.text = [textField.text substringToIndex:13];
                [textField resignFirstResponder];
            }
            self.i_phoneNumber = textField.text.length;
            
        }else if (textField.text.length < self.i_phoneNumber){//删除
            if (textField.text.length == 4 || textField.text.length == 9) {
                textField.text = [NSString stringWithFormat:@"%@",textField.text];
                textField.text = [textField.text substringToIndex:(textField.text.length-1)];
            }
            self.i_phoneNumber = textField.text.length;
        }
    }
    
    [self CheckBottomBtnClick];//修改底部按钮状态
}

#pragma mark textField--限制输入的字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"]){ return YES;}
    
    //限制输入表情
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
        return NO;
    }
    //判断键盘是不是九宫格键盘
    if ([ZSTool isNineKeyBoard:string] ){
        return YES;
    }else{
        //限制输入表情
        if ([ZSTool stringContainsEmoji:string]) {
            return NO;
        }
    }

    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];//得到输入框的内容
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    if (self.nameView.inputTextFeild == textField){
        //姓名长度限制40
        if ([toBeString length] > 40) {
            textField.text = [toBeString substringToIndex:40];
            return NO;
        }
    }
    //手机号长度显示11(俩空格占位)
    if (self.phoneNumView.inputTextFeild == textField){
        if ([toBeString length] > 13) {
            textField.text = [toBeString substringToIndex:13];
            return NO;
        }
    }
    if (self.IDcardView.inputTextFeild == textField){
        self.IDcardView.inputTextFeild.text = [self.IDcardView.inputTextFeild.text uppercaseString];
        //身份证号长度显示18
        if ([toBeString length] > 18) {
            textField.text = [toBeString substringToIndex:18];
            return NO;
        }
    }
    return YES;
}

#pragma mark 键盘收回触发--判断输入是否正确
- ( void )textFieldDidEndEditing:( UITextField *)textField
{
    if (self.IDcardView.inputTextFeild == textField){
        self.IDcardView.inputTextFeild.text  = [self.IDcardView.inputTextFeild.text uppercaseString];
        if (![ZSTool checkUserIDCard:self.IDcardView.inputTextFeild.text]) {
            [ZSTool showMessage:@"请输入正确的身份证号" withDuration:DefaultDuration];
        }
    }
    if ([self.title isEqualToString:@"贷款人信息"]) {//只有添加贷款人信息的时候才需要验证手机号
        if (self.phoneNumView.inputTextFeild == textField){
            self.phoneNumView.inputTextFeild.text  = [self.phoneNumView.inputTextFeild.text uppercaseString];
            if (![ZSTool isMobileNumber:self.phoneNumView.inputTextFeild.text]) {
                [ZSTool showMessage:@"请输入正确的手机号" withDuration:DefaultDuration];
            }
        }
    }
}

#pragma mark textView内容变化时调用 (因为在封装的view里面she代理不好使,至今拎出来在外面写)
- (void)ValueChange:(NSNotification *)obj
{
    UITextView *textView = obj.object;
    CGRect textviewRect = textView.frame;
    textviewRect.size.height = textView.contentSize.height;
    textView.frame = textviewRect;
    //隐藏placeholer
    self.detailAddressView.placeholderLabel.hidden = [@(self.detailAddressView.inputTextView.text.length) boolValue];
    //根据输入文字的高度判断输入框的高度
    if (textviewRect.size.height > CellHeight) {
        self.detailAddressView.height = textviewRect.size.height;
    }else{
        self.detailAddressView.height = CellHeight;
    }
    //设置分割线的位置
    self.detailAddressView.lineView.top = self.detailAddressView.height-0.5;
    //解决复制粘贴的坑
    [self.detailAddressView.inputTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    //重设其他view的frame
    [self resetViewFrame];
}

#pragma mark textView--先判断是否填写表情
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //限制输入表情
    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
        return NO;
    }
    //判断键盘是不是九宫格键盘
    if ([ZSTool isNineKeyBoard:text] ){
        return YES;
    }else{
        //限制输入表情
        if ([ZSTool stringContainsEmoji:text]) {
            return NO;
        }
    }
    
    //不允许输入空格
    NSString *tem = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![text isEqualToString:tem]) {
        return NO;
    }
    
    //最多只能输入50个子
    if (range.location > 50) {
        return NO;
    }
    return YES;
}

- (void)textDidChange:(NSNotification *)notification {
    // 根据字符数量显示或者隐藏placeholderLabel
    self.detailAddressView.placeholderLabel.hidden = [@(self.detailAddressView.inputTextView.text.length) boolValue];
}

#pragma mark ZSInputOrSelectViewDelegate---"请选择"按钮的响应事件
- (void)clickBtnAction:(ZSInputOrSelectView *)view
{
    //隐藏键盘
    [self.nameView.inputTextFeild resignFirstResponder];
    [self.IDcardView.inputTextFeild resignFirstResponder];
    [self.phoneNumView.inputTextFeild resignFirstResponder];
    
    //婚姻状况/是否为共有人/与贷款人关系
    if (view == self.marryView) {
        //如果列表已经有两个共有人,配偶不允许修改成共有人
        if (!self.isFromAdd && [self.title isEqualToString:@"配偶信息"] && ![self checkCurrentPartOwnerCount]) {
            [ZSTool showMessage:@"共有人数量已达到上限" withDuration:DefaultDuration];
            return;
        }
        ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:[self getActionsheetArray]];
        actionsheet.delegate = self;
        actionsheet.tag = marryStateTag;
        [actionsheet show:[self getActionsheetArray].count];
    }
    //大数据风控
    else if (view == self.bigDataView) {
        //如果已经选择查询,则不允许修改,还是根据值去判断吧
        ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:@[@"查询",@"不查询"]];
        actionsheet.delegate = self;
        actionsheet.tag = bigDataStateTag;
        [actionsheet show:2];
    }
    //央行征信
    else if (view == self.bankReferenceView) {
        ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:@[@"查询",@"不查询"]];
        actionsheet.delegate = self;
        actionsheet.tag = bankReferenceTag;
        [actionsheet show:2];
    }
    //省市区选择
    else {
//        NSLog(@"选择省市区");
        ZSWSChooseProvinceViewController *addProvince = [[ZSWSChooseProvinceViewController alloc]init];
        [self.navigationController pushViewController:addProvince animated:NO];
        //省市区页返回的数据
        __block NSString *string;
        addProvince.provinceModel = ^(ZSProvinceModel *provinceModel){
            string = provinceModel.name;
            self.currentProID = provinceModel.ID;//用于接口请求
            self.currentProName = provinceModel.name;//用于上个页面的数据刷新
        };
        addProvince.cityModel = ^(ZSProvinceModel *cityModel){
            string = [NSString stringWithFormat:@"%@ %@",string,cityModel.name];
            self.currentCitID = cityModel.ID;//用于接口请求
            self.currentCitName = cityModel.name;//用于上个页面的数据刷新
        };
        addProvince.areaModel = ^(ZSProvinceModel *areaModel) {
            string = [NSString stringWithFormat:@"%@ %@",string,areaModel.name];
            self.provinceView.rightLabel.text = string;
            self.provinceView.rightLabel.textColor = ZSColorListRight;
            self.currentAreID = areaModel.ID;//用于接口请求
            self.currentAreName = areaModel.name;//用于上个页面的数据刷新
        };
    }
}

#pragma mark 检测列表中共有人的数量
- (BOOL)checkCurrentPartOwnerCount
{
    //先复制数组
    NSMutableArray *array_new = [NSMutableArray arrayWithArray:global.wsOrderDetail.custInfo];
    for (int i = 0; i<global.wsOrderDetail.custInfo.count; i++) {
        CustInfo *info = global.wsOrderDetail.custInfo[i];
        if ([info.releation intValue]==4) {
            [array_new removeObject:info];
            for (int j = 0; j < array_new.count; j++) {//有共有人的时候判断还有没有其他共有人
                CustInfo *newInfo = array_new[j];
                if ([newInfo.releation intValue]==4) {
                    return NO;
                }
            }
        }
    }
    return YES;
}

#pragma mark 检测列表中是否有主贷人配偶
- (BOOL)checkMyMate
{
    for (int i = 0; i<global.wsOrderDetail.custInfo.count; i++) {
        CustInfo *info = global.wsOrderDetail.custInfo[i];
        if ([info.releation intValue]==2 || [info.releation intValue]==3) {
            return NO;
        }
    }
    return YES;
}

#pragma mark 检测列表中是否有担保人配偶
- (BOOL)checkBondsmanMate
{
    for (int i = 0; i<global.wsOrderDetail.custInfo.count; i++) {
        CustInfo *info = global.wsOrderDetail.custInfo[i];
        if ([info.releation intValue]==6) {
            return NO;
        }
    }
    return YES;
}

#pragma mark 婚姻选择框弹出来的选项
- (NSArray *)getActionsheetArray
{
    NSArray *array;
    if ([self.marryLabelNotice isEqualToString:@"婚姻状况"]) {
        array = @[@"未婚",@"已婚",@"离异",@"丧偶"];
    }else if ([self.marryLabelNotice isEqualToString:@"是否为共有人"]) {
        if (![self checkCurrentPartOwnerCount]) {
            array = @[@"否"];
        }else{
            array = @[@"是",@"否"];
        }
    }else if ([self.marryLabelNotice isEqualToString:@"与贷款人关系"]) {
        array = @[@"直系亲属",@"朋友"];
    }
    return array;
}

#pragma mark ZSActionSheetViewDelegate--选择扫描/拍照/查看大图--选择婚姻状况/是否为共有人/与贷款人关系--选择大数据风控--选择央行征信
- (void)SheetView:(ZSActionSheetView *)sheetView btnClick:(NSInteger)tag;
{
    //身份证正面
    if (sheetView.tag == IDcardFrontTag)
    {
        if (tag == 0) {
            [self IDFront:YES];
        }else if (tag == 1) {
            [self camera];
        }else if (tag == 2){
            [self imagePicker];
        }else{
            [self showBigImage];
        }
    }
    //身份证反面
    else if (sheetView.tag == IDcardBackTag)
    {
        if (tag == 0) {
            [self IDFront:NO];
        }else if (tag == 1) {
            [self camera];
        }else if (tag == 2){
            [self imagePicker];
        }else{
            [self showBigImage];
        }
    }
    //征信授权书
    else if (sheetView.tag == authorizationTag)
    {
        if (tag == 0) {
            [self camera];
        }else if (tag == 1) {
            [self imagePicker];
        }else{
            [self showBigImage];
        }
    }
    //婚姻状况/是否为共有人/与贷款人关系
    else if (sheetView.tag == marryStateTag)
    {
        self.marryView.rightLabel.text = [self getActionsheetArray][tag];
        self.marryView.rightLabel.textColor = ZSColorListRight;
        self.isChangeAnyData = YES;//用于返回提示信息未保存
    }
    //大数据风控
    else if (sheetView.tag == bigDataStateTag)
    {
        self.bigDataView.rightLabel.text = tag == 0 ? @"查询" : @"不查询";
        self.bigDataView.rightLabel.textColor = ZSColorListRight;
        self.isChangeAnyData = YES;//用于返回提示信息未保存
    }
    //央行征信
    else if (sheetView.tag == bankReferenceTag)
    {
        self.bankReferenceView.rightLabel.textColor = ZSColorListRight;
        if (tag == 0) {
            self.indicateArray = [NSArray arrayWithObjects:@"身份证正面(必填)",@"身份证反面(必填)",@"征信授权书(必填)",nil];
            self.bankReferenceView.rightLabel.text = @"查询";
            if (self.buttonInteger == 2) {
                self.indicateLabel.text = @"征信授权书(必填)";
            }
        }
        if (tag == 1) {
            self.indicateArray = [NSArray arrayWithObjects:@"身份证正面(必填)",@"身份证反面(必填)",@"征信授权书",nil];
            self.bankReferenceView.rightLabel.text = @"不查询";
            if (self.buttonInteger == 2) {
                self.indicateLabel.text = @"征信授权书";
            }
        }
        self.isChangeAnyData = YES;//用于返回提示信息未保存
    }
    
    [self CheckBottomBtnClick];//检测底部按钮状态
}

#pragma mark /*--------------------------------顶部身份证相关-------------------------------------------*/
- (NSMutableArray *)imageArray
{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (UILabel *)indicateLabel//起始页身份证正面
{
    if (_indicateLabel == nil) {
        _indicateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,pageFlowViewHEIGHT-30, ZSWIDTH, 15)];
        _indicateLabel.textColor = ZSColorAllNotice;
        _indicateLabel.font = [UIFont systemFontOfSize:14];
        _indicateLabel.textAlignment = NSTextAlignmentCenter;
        _indicateLabel.text = @"身份证正面(必填)";
    }
    return _indicateLabel;
}

- (NSArray *)indicateArray//每张图片下面的提示
{
    if (_indicateArray == nil) {
        _indicateArray = [NSArray arrayWithObjects:@"身份证正面(必填)",@"身份证反面(必填)",@"征信授权书",nil];
    }
    return _indicateArray;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView
{
    return CGSizeMake((ZSWIDTH - 75), (ZSWIDTH - 75) /1.58);
}

- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView
{
    return self.imageArray.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(50, 0, ZSWIDTH - 75, (ZSWIDTH - 75) /1.58)];
        bannerView.layer.cornerRadius = 10.0f;  //带弧形
        bannerView.layer.masksToBounds = YES;   //是否超出
    }
    bannerView.mainImageView.image = self.imageArray[index];
    return bannerView;
}

#pragma mark 选择要输入的身份证图片
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView
{
    self.buttonInteger = pageNumber;
    if (pageNumber>=0 && pageNumber<3) {
        self.indicateLabel.text = [self.indicateArray objectAtIndex:pageNumber];
    }
}

#pragma mark 选择要输入的身份证图片--第几页
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex
{
    self.currentTapView = subView;//用于显示大图
    [self.view endEditing:YES];
    self.buttonInteger = subIndex;
    if (!self.isFromAdd && global.wsCustInfo.name.length)
    {
        //根据订单状态判断是否可编辑:征信查询提交前所有所有信息都可以进行修改，征信查询提交后，身份证正面、身份证反面、姓名、身份证号不允许进行编辑
        if (global.wsOrderDetail.projectInfo.orderState.intValue != 1) {
            if (subIndex == 2) {//授权照片还是可以编辑的
                [self setArrayWithAction:subIndex];
            }else{//其他的就只允许查看大图
                [self showBigImage];
            }
        }else{
            [self setArrayWithAction:subIndex];
        }
    }else{
        [self setArrayWithAction:subIndex];
    }
}

- (void)setArrayWithAction:(NSInteger)subIndex
{
    //当前图片存在的时候可以点击查看大图
    if (subIndex == 0) {
        if (self.urlFront) {
            [self showPhoto:@[@"扫描",@"拍照",@"从手机相册选择",@"查看大图"] winth:subIndex];
        }else{
            [self showPhoto:@[@"扫描",@"拍照",@"从手机相册选择"] winth:subIndex];
        }
    }else if (subIndex == 1) {
        if (self.urlBack) {
            [self showPhoto:@[@"扫描",@"拍照",@"从手机相册选择",@"查看大图"] winth:subIndex];
        }else{
            [self showPhoto:@[@"扫描",@"拍照",@"从手机相册选择"] winth:subIndex];
        }
    }else if (subIndex == 2) {
        if (self.urlAuthor) {
            [self showPhoto:@[@"拍照",@"从手机相册选择",@"查看大图"] winth:subIndex];
        }else{
            [self showPhoto:@[@"拍照",@"从手机相册选择"] winth:subIndex];
        }
    }
}

- (void)showPhoto:(NSArray *)array winth:(NSInteger)subIndex
{
    ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:array];
    actionsheet.delegate = self;
    actionsheet.tag = subIndex;
    [actionsheet show:array.count];
}

#pragma mark 查看大图
- (void)showBigImage
{
    // 1. 创建photoBroseView对象
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
    // 2. 根据图片url传递数组
    if (global.wsCustInfo.identityPos.length && global.wsCustInfo.identityBak.length && global.wsCustInfo.authorizeImg) {
        photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,global.wsCustInfo.identityPos],[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,global.wsCustInfo.identityBak],[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,global.wsCustInfo.authorizeImg]].mutableCopy;
    }else{
        NSMutableArray *array_imgUrl = [[NSMutableArray alloc]init];
        if (self.urlFront) {
            [array_imgUrl addObject:[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.urlFront]];
        }
        if (self.urlBack) {
            [array_imgUrl addObject:[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.urlBack]];
        }
        if (self.urlAuthor) {
            [array_imgUrl addObject:[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.urlAuthor]];
        }
        photoBroseView.imagesURL = array_imgUrl.mutableCopy;
    }
    photoBroseView.showFromView = self.currentTapView;
    photoBroseView.hiddenToView = self.currentTapView;
    //当前点击的index和数组个数及图片位置做个匹配
    if (self.buttonInteger == 0)
    {
        photoBroseView.currentIndex = 0;
    }
    else if (self.buttonInteger == 1)
    {
        if (photoBroseView.imagesURL.count == 1){
            photoBroseView.currentIndex = 0;
        }else if (photoBroseView.imagesURL.count == 2){
            if (self.urlFront) {
                photoBroseView.currentIndex = 1;
            }else if (self.urlAuthor) {
                photoBroseView.currentIndex = 0;
            }
        }else if(photoBroseView.imagesURL.count == 3){
            photoBroseView.currentIndex = 1;
        }
    }
    else if (self.buttonInteger == 2)
    {
        if (photoBroseView.imagesURL.count == 1){
            photoBroseView.currentIndex = 0;
        }else if(photoBroseView.imagesURL.count == 2){
            photoBroseView.currentIndex = 1;
        }else if(photoBroseView.imagesURL.count == 3){
            photoBroseView.currentIndex = 2;
        }
    }
    // 3.显示(浏览)
    [photoBroseView show];
}

#pragma mark 扫描身份证识别
- (void)IDFront:(BOOL)yesORno
{
    [self.view endEditing:YES];
    IDCardViewController *IDCardController = [[IDCardViewController alloc] init];
    IDCardController.IDCamDelegate = self;
    IDCardController.bShouldFront = yesORno;
    [self.navigationController pushViewController:IDCardController animated:YES];
}

#pragma mark IDCamCotrllerDelegate -- 扫描身份证信息回调
- (void)didEndRecIDWithResult:(IdInfo *)idInfo from:(id)sender
{
    self.isChangeAnyData = YES;//用于返回提示信息未保存

    if (idInfo.type != 0)
    {
        if (idInfo.type == 1) {//身份证正面
            if (idInfo.faceImg != nil) {
                //获取图片url
                NSData *data = UIImageJPEGRepresentation(idInfo.frontFullImg, [ZSTool configureRandomNumber]);
                [self getImageUrl:data withIndex:0 isNeedUpload:NO];
                //页面数据填充
                [self.imageArray replaceObjectAtIndex:0 withObject:idInfo.frontFullImg];
                [self.pageFlowView reloadData];
                self.nameView.inputTextFeild.text = idInfo.name;
                self.IDcardView.inputTextFeild.text = idInfo.code;
                [ZSTool showMessage:@"姓名及身份证号已自动获取，请注意核对与证件信息是否一致！！！" withDuration:2.0];
                [self CheckBottomBtnClick];//检测底部按钮状态
            }else{
                self.buttonInteger = 0;
                [self performSelector:@selector(ScanFail) withObject:nil afterDelay:0.1f];//扫描失败
            }
        }else{//身份证反面
            if (idInfo.backFullImg != nil) {
                //获取图片url
                NSData *data = UIImageJPEGRepresentation(idInfo.backFullImg, [ZSTool configureRandomNumber]);
                [self getImageUrl:data withIndex:1 isNeedUpload:NO];
                //页面数据填充
                [self.imageArray replaceObjectAtIndex:1 withObject:idInfo.backFullImg];
                [self.pageFlowView reloadData];
            }else{
                self.buttonInteger = 1;
                [self performSelector:@selector(ScanFail) withObject:nil afterDelay:0.1f];//扫描失败
            }
            //移除判断身份证有效期的label
            [self removeNoticeOfValidityIDCard];
            //判断身份证有效期
            NSString *vaildStr = [NSString calcDays:idInfo.valid];
            self.string_iDcardVaild = [NSString dateChange:idInfo.valid];
            if (![vaildStr isEqualToString:@"有效"]) {
                [self createNoticeOfValidityIDCard:vaildStr];
            }
        }
    }
}

#pragma mark 判断身份证有效期(创建)
- (void)createNoticeOfValidityIDCard:(NSString *)vaildStr
{
    self.IDcardView.height = 60;
    self.IDcardView.lineView.bottom = 59.5;
    self.IDcardView.inputTextFeild.top = 15;
    self.IDcardView.inputTextFeild.height = 15;
    self.IDcardView.inputTextFeild.textColor = ZSColorRed;
    self.idCardLabelVaild = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, ZSWIDTH-30, 30)];
    self.idCardLabelVaild.textAlignment = NSTextAlignmentRight;
    self.idCardLabelVaild.textColor = ZSColorRed;
    self.idCardLabelVaild.font = [UIFont systemFontOfSize:12];
    self.idCardLabelVaild.text = vaildStr;
    [self.IDcardView addSubview:self.idCardLabelVaild];
    [self resetViewFrame];
}

#pragma mark 判断身份证有效期(移除)
- (void)removeNoticeOfValidityIDCard
{
    if (self.idCardLabelVaild) {
        self.idCardLabelVaild.text = @"";
        [self.idCardLabelVaild removeFromSuperview];
        self.idCardLabelVaild = nil;
        self.IDcardView.height = CellHeight;
        self.IDcardView.lineView.bottom = CellHeight-0.5;
        self.IDcardView.inputTextFeild.top = 0;
        self.IDcardView.inputTextFeild.height = CellHeight;
        self.IDcardView.inputTextFeild.textColor = ZSColorListRight;
        [self resetViewFrame];
    }
}

#pragma mark 重设其他view的frame
- (void)resetViewFrame
{
    self.IDcardView.top = self.nameView.bottom;
    self.phoneNumView.top = self.IDcardView.bottom;
    self.marryView.top = self.phoneNumView.bottom;
    if (self.marryView) {
        self.bigDataView.top = self.marryView.bottom;
    }else{
        self.bigDataView.top = self.phoneNumView.bottom;
    }
    self.bankReferenceView.top = self.bigDataView.bottom;
    self.provinceView.top = self.bankReferenceView.bottom;
    self.detailAddressView.top = self.provinceView.bottom;
    //底部按钮
    if (self.idCardLabelVaild) {
        //身份证有效期占位
        if (self.provinceView) {
            self.bottomBtn.top = pageFlowViewHEIGHT+CellHeight*(self.numOfRow-1)+(60-CellHeight)+self.detailAddressView.height+15+10;
        }else{
            self.bottomBtn.top = pageFlowViewHEIGHT+CellHeight*self.numOfRow+(60-CellHeight)+self.detailAddressView.height+15+10;
        }
    }else{
        if (self.provinceView) {
            self.bottomBtn.top = pageFlowViewHEIGHT+CellHeight*(self.numOfRow-1)+self.detailAddressView.height+15+10;
        }else{
            self.bottomBtn.top = pageFlowViewHEIGHT+CellHeight*self.numOfRow+self.detailAddressView.height+15+10;
        }
    }
    self.scrollview.contentSize = CGSizeMake(ZSWIDTH,self.bottomBtn.bottom+25);
}

#pragma mark扫描失败
- (void)ScanFail
{
    ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"扫描失败，请手动选择照片并填写客户信息" cancelTitle:@"取消" sureTitle:@"确定"];
    alert.delegate = self;
    alert.tag = scanTag;
    [alert show];
}

#pragma mark选中拍照
- (void)camera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;//先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark 从手机相册选择
- (void)imagePicker
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark 拍照或选择相册后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.isChangeAnyData = YES;//用于返回提示信息未保存

    UIImage *Photoimage  = info[UIImagePickerControllerOriginalImage];
    UIImage *imagerotate = [UIImage fixOrientation:Photoimage];      //修正图片方向
    if (Photoimage != nil) {
        [self.imageArray replaceObjectAtIndex:self.buttonInteger withObject:imagerotate];
        NSData *data = UIImageJPEGRepresentation(Photoimage, [ZSTool configureRandomNumber]);
        [self getImageUrl:data withIndex:self.buttonInteger isNeedUpload:YES];
        //移除判断身份证有效期的label
        if (self.buttonInteger == 1) {
            [self removeNoticeOfValidityIDCard];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 获取到图片上传,返回图片url
- (void)getImageUrl:(NSData *)data withIndex:(NSInteger)index isNeedUpload:(BOOL)isNeed
{
    //UI变动
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)self.pageFlowView.cells[index];
    [LSProgressHUD showToView:bannerView.mainImageView message:@"上传中..."];
    if (index == 0) {
        [self performSelector:@selector(scrollToPageOne) withObject:nil afterDelay:0.75];
    }
    else if (index == 1) {
        [self performSelector:@selector(scrollToPageTwo) withObject:nil afterDelay:0.75];
    }
    //1.先上传到ZImg服务器获取到URL
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager uploadImageWithNativeAPI:data SuccessBlock:^(NSDictionary *dic) {
        NSString *dataUrl = [NSString stringWithFormat:@"%@",dic[@"MD5"]];
        //添加成功后滚动
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (index == 0)
            {
                //2.在上传URL到自己的服务器做图像识别
                if (isNeed == YES) {
                    [weakSelf uploadImageUrl:dataUrl];
                }
                weakSelf.urlFront = dataUrl;//用于接口参数
                [weakSelf CheckBottomBtnClick];//检测底部按钮状态
            }
            else if (index== 1){
                weakSelf.urlBack = dataUrl;
                [weakSelf CheckBottomBtnClick];//检测底部按钮状态
            }
            else if (index == 2){
                weakSelf.urlAuthor = dataUrl;
                [weakSelf CheckBottomBtnClick];//检测底部按钮状态
            }
        });
        [weakSelf.pageFlowView reloadData];//刷新顶部的三张照片
        [LSProgressHUD hideForView:bannerView.mainImageView];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:bannerView.mainImageView];
        [ZSTool showMessage:@"图片上传失败,请重试" withDuration:DefaultDuration];
    }];
}

- (void)scrollToPageOne
{
    [self.pageFlowView indexpage:1];//用于滑到下一页
}

- (void)scrollToPageTwo
{
    [self.pageFlowView indexpage:2];//用于滑到下一页
}

- (void)uploadImageUrl:(NSString *)dataUrl
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"url":dataUrl,
                                  @"ocrType":@"idCard",
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getOCRRecognitionURL] SuccessBlock:^(NSDictionary *dic) {
        //如果有身份证和姓名信息,并给与提示
        if (dic[@"respMap"]) {
            NSString *stringName = SafeStr(dic[@"respMap"][@"name"]);
            NSString *stringNum = SafeStr(dic[@"respMap"][@"idCardNo"]);
            if (stringName.length) {
                weakSelf.nameView.inputTextFeild.text = stringName;
            }
            if (stringNum.length) {
                weakSelf.IDcardView.inputTextFeild.text = stringNum;
            }
            if (stringName.length || stringNum.length) {
                [ZSTool showMessage:@"姓名及身份证号已自动获取，请注意核对与证件信息是否一致！！！" withDuration:2.0];
                [weakSelf CheckBottomBtnClick];//检测底部按钮状态
            }
        }
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 图片格式转换(避免点击的时候进入编辑页面太慢了)
- (void)changePhotoFormat
{
    //身份证正面照
    if (global.wsCustInfo.identityPos) {
        [self imageWithData:global.wsCustInfo.identityPos];
    }
    //身份证反面照
    if (global.wsCustInfo.identityBak) {
        [self imageWithData:global.wsCustInfo.identityBak];
    }
    //授权书
    if (global.wsCustInfo.authorizeImg) {
        [self imageWithData:global.wsCustInfo.authorizeImg];
    }
}

#pragma mark 根据情况判断底部按钮可否点击
- (void)CheckBottomBtnClick
{
    //1.输入框都有值
    if (self.nameView.inputTextFeild.text.length>0 && self.IDcardView.inputTextFeild.text.length>0) {
        //1.1主贷人 手机号必填,其他不适
        if ([self.title isEqualToString:@"贷款人信息"]) {
            if (self.phoneNumView.inputTextFeild.text.length>0) {
                //2.图片url都有值
                if (self.urlFront && self.urlBack) {
                    if ([self.bankReferenceView.rightLabel.text isEqualToString:@"查询"]) {
                        if (self.urlAuthor) {
                            //3.除开担保人配偶,有婚姻状况/是否为共有人/与贷款人关系
                            [self checkBottomBtnState];
                        }
                        else{
                            [self setBottomBtnEnable:NO];//不可点击
                            self.bottomBtn.userInteractionEnabled = YES;//先开启点击事件,点击的时候提示没上传征信授权书,和安卓保持一致
                        }
                    }else{
                        //3.除开担保人配偶,有婚姻状况/是否为共有人/与贷款人关系
                        [self checkBottomBtnState];
                    }
                }
            }
            else
            {
                [self setBottomBtnEnable:NO];//不可点击
            }
        }
        else
        {
            //2.图片url都有值
            if (self.urlFront && self.urlBack) {
                if ([self.bankReferenceView.rightLabel.text isEqualToString:@"查询"]) {
                    if (self.urlAuthor) {
                        //3.除开担保人配偶,有婚姻状况/是否为共有人/与贷款人关系
                        [self checkBottomBtnState];
                    }
                    else{
                        [self setBottomBtnEnable:NO];//不可点击
                        self.bottomBtn.userInteractionEnabled = YES;//先开启点击事件,点击的时候提示没上传征信授权书,和安卓保持一致
                    }
                }else{
                    //3.除开担保人配偶,有婚姻状况/是否为共有人/与贷款人关系
                    [self checkBottomBtnState];
                }
            }
        }
    }
    else
    {
        [self setBottomBtnEnable:NO];//不可点击
    }
}

- (void)checkBottomBtnState
{
    if ([self.title isEqualToString:@"贷款人信息"])
    {
        if (self.urlFront &&
            self.urlBack &&
            self.urlAuthor &&
            self.nameView.inputTextFeild.text.length>0 &&
            self.IDcardView.inputTextFeild.text.length>0 &&
            self.phoneNumView.inputTextFeild.text.length>0 && //主贷人 手机号必填
            ![self.marryView.rightLabel.text isEqualToString:KPlaceholderChoose] &&
            ![self.bigDataView.rightLabel.text isEqualToString:KPlaceholderChoose] &&
            ![self.bankReferenceView.rightLabel.text isEqualToString:KPlaceholderChoose])
        {
            [self setBottomBtnEnable:YES];//恢复点击
        }
        else{
            [self setBottomBtnEnable:NO];//不可点击
        }
    }
    else if ([self.title isEqualToString:@"贷款人配偶信息"] || [self.title isEqualToString:@"共有人信息"] || [self.title isEqualToString:@"担保人信息"])
    {
        if (self.urlFront &&
            self.urlBack &&
            self.urlAuthor &&
            self.nameView.inputTextFeild.text.length>0 &&
            self.IDcardView.inputTextFeild.text.length>0 &&
            ![self.marryView.rightLabel.text isEqualToString:KPlaceholderChoose] &&
            ![self.bigDataView.rightLabel.text isEqualToString:KPlaceholderChoose] &&
            ![self.bankReferenceView.rightLabel.text isEqualToString:KPlaceholderChoose])
        {
            [self setBottomBtnEnable:YES];//恢复点击
        }
        else{
            [self setBottomBtnEnable:NO];//不可点击
        }
    }
    else if ([self.title isEqualToString:@"担保人配偶信息"])
    {
        if (self.urlFront &&
            self.urlBack &&
            self.urlAuthor &&
            self.nameView.inputTextFeild.text.length>0 &&
            self.IDcardView.inputTextFeild.text.length>0 &&
            ![self.bigDataView.rightLabel.text isEqualToString:KPlaceholderChoose] &&
            ![self.bankReferenceView.rightLabel.text isEqualToString:KPlaceholderChoose])
        {
            [self setBottomBtnEnable:YES];//恢复点击
        }
        else{
            [self setBottomBtnEnable:NO];//不可点击
        }
    }
}

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
