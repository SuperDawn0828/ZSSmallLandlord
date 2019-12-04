//
//  ZSStarLoanAddCustomerViewController.h.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/27.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ZSBaseAddCustomerViewController.h"
#import "ZSStarLoanPageController.h"
#import "ZSSLPageController.h"
#import "ZSSLPersonListViewController.h"
#import "ZSSLAddresourceViewController.h"
#import "TZImagePickerController.h"

#define pageFlowViewHEIGHT (ZSWIDTH - 75)/1.58+24+40//pageFlowView高

typedef NS_ENUM(NSUInteger, alertViewTag) {
    deletePersonTag   = 0,     //删除人员信息
    changeMarryTag    = 1998,  //修改婚姻状况
    noticeTag         = 9,     //信息不回保存提示
    scanTag           = 11,    //扫描
    openCameraFailTag = 1,     //相机打开失败
    hasnoPhoneNum     = 2,     //已有订单添加人没有填写手机号
    revalidationPhone = 3,     //修改手机号后是否重新验证
};

typedef NS_ENUM(NSUInteger, actionSheetwTag) {
    marryStateTag    = 1992,   //婚姻状况
    bigDataStateTag  = 1998,   //大数据风控
    IDcardFrontTag   = 0,      //身份证正面
    IDcardBackTag    = 1,      //身份证反面
};

@interface ZSBaseAddCustomerViewController ()<UITextFieldDelegate,UITextViewDelegate,NewPagedFlowViewDelegate,NewPagedFlowViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZSActionSheetViewDelegate,ZSInputOrSelectViewDelegate,ZSAlertViewDelegate,IDCamCotrllerDelegate,ZSPickerViewDelegate,TZImagePickerControllerDelegate>
//本页面
@property(nonatomic,strong)UIScrollView             *scrollview;          //scrollview
@property(nonatomic,strong)NewPagedFlowView         *pageFlowView;        //滚动图
@property(nonatomic,strong)NSMutableArray           *imageArray;          //顶部两张身份证图片数组
@property(nonatomic,strong)UILabel                  *indicateLabel;       //指示label
@property(nonatomic,assign)NSInteger                buttonInteger;        //顶部身份证照片选中的哪一张
@property(nonatomic,strong)UIView                   *currentTapView;      //顶部身份证照片选中的哪一张view
@property(nonatomic,strong)ZSInputOrSelectView      *nameView;            //姓名
@property(nonatomic,strong)ZSInputOrSelectView      *IDcardView;          //身份证号
@property(nonatomic,strong)UILabel                  *idCardLabelVaild;    //身份证号有效期label
@property(nonatomic,copy  )NSString                 *string_iDcardVaild;  //身份证号有效期label
@property(nonatomic,strong)ZSInputOrSelectView      *phoneNumView;        //手机号
@property(nonatomic,strong)ZSInputOrSelectView      *marryView;           //婚姻状况
@property(nonatomic,strong)ZSInputOrSelectView      *bigDataView;         //大数据风控
//@property(nonatomic,strong)ZSInputOrSelectView      *bankReferenceView;   //央行征信
//@property(nonatomic,strong)ZSInputOrSelectView      *residenceView;       //户口本
@property(nonatomic,copy  )NSString                 *marryLabelNotice;    //根据不同人员信息的提示
@property(nonatomic,assign)NSInteger                numOfRow;             //创建订单时,担保人配偶3行,其余4行;编辑的时候可以添加省市区,担保人配偶5行,其余6行
@property(nonatomic,copy  )NSString                 *urlFront;            //身份证正面照片
@property(nonatomic,copy  )NSString                 *urlBack;             //身份证背面照片
@property(nonatomic,copy  )NSString                 *currentMarrayState;  //记录当前婚姻状况,用于判断将婚姻从已婚修改至其他情况的判断
@property(nonatomic,assign)NSInteger                i_phoneNumber;        //用来设置输入手机号做空格用
@property(nonatomic,copy  )NSString                 *isChangePhone;       //是否修改了手机号,修改过再提交就需要重查有关手机的征信
@property(nonatomic,assign)BOOL                     editorMessageChange;  //编辑人员信息时,修改了婚姻状况或者大数据风控
@property(nonatomic,assign)BOOL                     isChangeAnyData;      //返回提示信息未保存
@end

@implementation ZSBaseAddCustomerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self setLeftBarButtonItem];//返回按钮
    [self setMarryLabelNoticeString];
    [self initScrollView];//创建view
    [DictManager InitDict];//初始化判断 bundleIdentifier是否和静态库一致
    //Data
    [self fillInData];
    [self fillInDataWithOnline];
}

#pragma mark /*--------------------------------------返回按钮提示事件--------------------------------------*/
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

#pragma mark /*--------------------------------------创建view--------------------------------------*/
- (void)setMarryLabelNoticeString
{
    if ([self.title isEqualToString:@"贷款人信息"] ||
        [self.title isEqualToString:@"担保人信息"] ||
        [self.title isEqualToString:@"卖方信息"] ||
        [self.title isEqualToString:@"买方信息"])
    {
        self.marryLabelNotice = @"婚姻状况";
        self.numOfRow = 5;
    }
    else if ([self.title isEqualToString:@"共有人信息"])
    {
        self.marryLabelNotice = @"与贷款人关系";
        self.numOfRow = 5;
    }
    else
    {
        self.numOfRow = 4;
    }
}

- (void)initScrollView
{
    //整体竖着的scroll
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-60)];
    self.scrollview.contentSize = CGSizeMake(ZSWIDTH, pageFlowViewHEIGHT + 10 + CellHeight * self.numOfRow + 74);
    self.scrollview.bounces = NO;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollview];
    
    //两张图片
    for (int i=0; i<2; i++) {
        UIImage *slideimage = [UIImage imageNamed:[NSString stringWithFormat:@"identification_photo0%d.png",i]];
        [self.imageArray addObject:slideimage];
    }
    
    //顶部身份证照片等
    [self AddpageFlowView];
    
    //底部的人员相关文字信息
    [self AddBottomMessageView];
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
    
    //两个提示label
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
    [self.scrollview addSubview:self.phoneNumView ];
    self.i_phoneNumber = 0;
    
    //婚姻状况/与共有人关系
    if ([self.title isEqualToString:@"贷款人信息"] ||
        [self.title isEqualToString:@"共有人信息"] ||
        [self.title isEqualToString:@"卖方信息"] ||
        [self.title isEqualToString:@"买方信息"] ||
        [self.title isEqualToString:@"担保人信息"])
    {
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
    
    //    //央行征信报告
    //    self.bankReferenceView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.bigDataView.bottom, ZSWIDTH, CellHeight) withClickAction:@"央行征信报告"];
    //    self.bankReferenceView.delegate = self;
    //    self.bankReferenceView.rightLabel.text = @"待上传";
    //    [self.scrollview addSubview:self.bankReferenceView];
    //
    //    //户口本
    //    self.residenceView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.bankReferenceView.bottom, ZSWIDTH, CellHeight) withClickAction:@"户口本"];
    //    self.residenceView.delegate = self;
    //    self.residenceView.rightLabel.text = @"待上传";
    //    [self.scrollview addSubview:self.residenceView];
    
    //保存按钮
    [self configuBottomButtonWithTitle:@"保存" OriginY:self.bigDataView.bottom+15];
    [self setBottomBtnEnable:NO];//默认不可点击
    [self.scrollview addSubview:self.bottomBtn];
}

#pragma mark /*--------------------------------------数据处理--------------------------------------*/
#pragma mark 编辑人员信息的时候是有数据的--数据填充
- (void)fillInData
{
    //编辑人员信息时,除贷款人以外显示删除按钮
    if (self.isFromEditor && ![self.title isEqualToString:@"贷款人信息"])
    {
        [self configureRightNavItemWithTitle:nil withNormalImg:@"head_delete_n" withHilightedImg:@"head_delete_n"];//删除人员角色按钮
    }
    
    if (self.isFromEditor && global.bizCustomers.name.length)
    {
        //订单提交之前可以修改任何信息,提交之后姓名和身份证号不允许修改
        if ([self checkOrderState]) {
            self.nameView.inputTextFeild.userInteractionEnabled = YES;
            self.IDcardView.inputTextFeild.userInteractionEnabled = YES;
        }
        else{
            self.nameView.inputTextFeild.userInteractionEnabled = NO;
            self.IDcardView.inputTextFeild.userInteractionEnabled = NO;
        }
        
        //身份证正面
        if (global.bizCustomers.identityPos) {
            [self.imageArray replaceObjectAtIndex:0 withObject:[self imageWithData:global.bizCustomers.identityPos]];
            self.urlFront = global.bizCustomers.identityPos;
        }
        //身份证反面照
        if (global.bizCustomers.identityBak) {
            [self.imageArray replaceObjectAtIndex:1 withObject:[self imageWithData:global.bizCustomers.identityBak]];
            self.urlBack = global.bizCustomers.identityBak;
        }
        [self.pageFlowView reloadData];
        //姓名
        if (global.bizCustomers.name) {
            self.nameView.inputTextFeild.text = global.bizCustomers.name;
        }
        //身份证号
        if (global.bizCustomers.identityNo) {
            self.IDcardView.inputTextFeild.text = global.bizCustomers.identityNo;
        }
        //手机号
        if (global.bizCustomers.cellphone) {
            if (global.bizCustomers.cellphone.length) {
                self.phoneNumView.inputTextFeild.text = [ZSTool addTheBlankSpace:global.bizCustomers.cellphone];
            }
        }
        //婚姻状况/与贷款人关系
        self.marryView.leftLabel.attributedText = [self.marryLabelNotice addStar];
        if ([self.marryView.leftLabel.text containsString:@"婚姻状况"]) {
            if (global.bizCustomers.beMarrage) {
                self.marryView.rightLabel.textColor = ZSColorListRight;
                self.marryView.rightLabel.text = [ZSGlobalModel getMarrayStateWithCode:global.bizCustomers.beMarrage];
                self.currentMarrayState = [ZSGlobalModel getMarrayStateWithCode:global.bizCustomers.beMarrage];
            }
        }
        else
        {
            if (global.bizCustomers.lenderReleation) {
                self.marryView.rightLabel.textColor = ZSColorListRight;
                self.marryView.rightLabel.text = [ZSGlobalModel getRelationshipStateWithCode:global.bizCustomers.lenderReleation];
            }
        }
        //大数据风控
        if (global.bizCustomers.isRiskData) {
            if (global.bizCustomers.isRiskData.length) {
                self.bigDataView.rightLabel.text = [ZSGlobalModel getBigDataStateWithCode:global.bizCustomers.isRiskData];
                self.bigDataView.rightLabel.textColor = ZSColorListRight;
                //1.订单创建人在提交订单之前(暂存状态)是可以随意更改大数据风控的（提交订单之后查询不能更改，不查询可以改为查询）
                //1.1(订单创建人）并且（非暂存状态）
                if ([self checkOrderState]) {
                    //不查询大数据风控可以改为查询,查询大数据风控不可以更改
                    self.bigDataView.delegate = [global.bizCustomers.isRiskData isEqualToString:@"1"] ? nil : self;
                }
            }
        }
        //检测底部按钮点击
        [self CheckBottomBtnClick];
    }
}

- (void)fillInDataWithOnline
{
    if (self.isFromWeiXin || self.isFromOfficial) {
        //姓名
        if (global.bizCustomers.name) {
            self.nameView.inputTextFeild.text = global.bizCustomers.name;
        }
        //身份证号
        if (global.bizCustomers.identityNo) {
            self.IDcardView.inputTextFeild.text = global.bizCustomers.identityNo;
        }
        //手机号
        if (global.bizCustomers.cellphone) {
            if (global.bizCustomers.cellphone.length) {
                self.phoneNumView.inputTextFeild.text = [ZSTool addTheBlankSpace:global.bizCustomers.cellphone];
            }
        }
    }
}

//订单提交之前可以修改任何信息,提交之后姓名和身份证号不允许修改
- (BOOL)checkOrderState
{
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan]) {
        if ([global.slOrderDetails.isOrder isEqualToString:@"1"] && [global.slOrderDetails.spdOrder.orderState isEqualToString:@"暂存"])
        {
            return YES;
        }
        else{
            return NO;
        }
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor]) {
        if ([global.rfOrderDetails.isOrder isEqualToString:@"1"] && [global.rfOrderDetails.redeemOrder.orderState isEqualToString:@"暂存"])
        {
            return YES;
        }
        else{
            return NO;
        }
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan]) {
        if ([global.mlOrderDetails.isOrder isEqualToString:@"1"] && [global.mlOrderDetails.dydOrder.orderState isEqualToString:@"暂存"])
        {
            return YES;
        }
        else{
            return NO;
        }
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        if ([global.elOrderDetails.isOrder isEqualToString:@"1"] && [global.elOrderDetails.easyOrder.orderState isEqualToString:@"暂存"])
        {
            return YES;
        }
        else{
            return NO;
        }
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire]) {
        if ([global.chOrderDetails.isOrder isEqualToString:@"1"] && [global.chOrderDetails.cwfqOrder.orderState isEqualToString:@"暂存"])
        {
            return YES;
        }
        else{
            return NO;
        }
    }
    //代办业务
    else {
        if ([global.abOrderDetails.isOrder isEqualToString:@"1"] && [global.abOrderDetails.insteadOrder.orderState isEqualToString:@"暂存"])
        {
            return YES;
        }
        else{
            return NO;
        }
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

#pragma mark /*--------------------------------------删除人员--------------------------------------*/
- (void)RightBtnAction:(UIButton*)sender
{
    NSString *noticeString;
    if ([self.title isEqualToString:@"卖方信息"] ||
        [self.title isEqualToString:@"买方信息"] ||
        [self.title isEqualToString:@"担保人信息"])
    {
        noticeString =  [self checkMyMate] ? @"删除后信息将无法恢复，是否确认删除?" : @"删除后信息将无法恢复，同时配偶信息会一并删除，是否确认删除?";
    }
    else {
        noticeString = @"删除后信息将无法恢复，是否确认删除?";
    }
    
    ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:noticeString sureTitle:@"确定" cancelTitle:@"取消"];
    alert.delegate = self;
    alert.tag = deletePersonTag;
    [alert show];
}

#pragma mark 删除人员成功后返回相应页面
- (void)backActionOfDeletePerson
{
    NSArray *array = self.navigationController.viewControllers;
    if ([[ZSGlobalModel getOrderState:self.prdType] isEqualToString:@"暂存"]) {
        //上上个页面为订单详情列表
        if (array.count > 3){
            if ([array[array.count-3] isKindOfClass:[ZSSLPersonListViewController class]]){
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:array.count-3] animated:YES];
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    else
    {
        //上上个页面为订单详情列表
        if ([array[array.count-3] isKindOfClass:[ZSSLPageController class]]){
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:array.count-3] animated:YES];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark /*--------------------------------------保存订单--------------------------------------*/
- (void)bottomClick:(UIButton *)sender
{
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
    //如果是创建订单或者新增人员信息,没填手机号给与提示
    if (self.isFromAdd && self.phoneNumView.inputTextFeild.text.length==0) {
        ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"未填写手机号，系统将只查询部分大数据风控信息，是否确认提交？" sureTitle:@"确认提交" cancelTitle:@"补充手机"];
        alert.delegate = self;
        alert.tag = hasnoPhoneNum;
        [alert show];
        return;
    }
    //如果填了手机号就判断一下手机号
    if (self.phoneNumView.inputTextFeild.text.length>0 && ![ZSTool isMobileNumber:self.phoneNumView.inputTextFeild.text]){
        [ZSTool showMessage:@"请输入正确的手机号" withDuration:DefaultDuration];
        return;
    }
    //如果是修改订单信息,之前有手机号,现在删除手机了就不能提交,必须填
    if (self.isFromEditor) {
        if (global.bizCustomers.cellphone.length && self.phoneNumView.inputTextFeild.text.length == 0) {
            [ZSTool showMessage:@"请输入手机号" withDuration:DefaultDuration];
            return;
        }
    }
    //如果是修改订单信息,之前有手机号并且大数据风控为"查询",并且手机号进行了变更
    if (self.isFromEditor)
    {
        if (global.bizCustomers.isRiskData.intValue == 1) {
            if (global.bizCustomers.cellphone.length &&
                self.phoneNumView.inputTextFeild.text.length > 0 &&
                ![[ZSTool filteringTheBlankSpace:self.phoneNumView.inputTextFeild.text] isEqualToString:global.bizCustomers.cellphone] ) {
                ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"手机号出现变动，是否重新验证手机实名信息？"  cancelTitle:@"暂不验证" sureTitle:@"立即验证"];
                alert.delegate = self;
                alert.tag = revalidationPhone;
                [alert show];
                return;
            }
        }
    }
    //判断婚姻状况是否从已婚修改成其他
    if ([self.currentMarrayState isEqualToString:@"已婚"] && ![self.marryView.rightLabel.text isEqualToString:@"已婚"])
    {
        if ([self.title isEqualToString:@"贷款人信息"] ||
            [self.title isEqualToString:@"卖方信息"] ||
            [self.title isEqualToString:@"买方信息"] ||
            [self.title isEqualToString:@"担保人信息"] )
        {
            if (![self checkMyMate]) {
                NSString *sting = [NSString stringWithFormat:@"您已将婚姻状况改为%@,配偶信息将被清除,是否确认变更?",self.marryView.rightLabel.text];
                ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:sting sureTitle:@"确定" cancelTitle:@"取消"];
                alert.delegate = self;
                alert.tag = changeMarryTag;
                [alert show];
                return;
            }
        }
    }
    //数据请求--提交人员信息
    [self createOrder];
}

#pragma mark 检测列表中是否有配偶
- (BOOL)checkMyMate
{
    NSArray<BizCustomers *> *bizCustomers;
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        bizCustomers = global.slOrderDetails.bizCustomers;
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        bizCustomers = global.rfOrderDetails.bizCustomers;
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        bizCustomers = global.mlOrderDetails.bizCustomers;
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        bizCustomers = global.elOrderDetails.bizCustomers;
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        bizCustomers = global.chOrderDetails.bizCustomers;
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        bizCustomers = global.abOrderDetails.bizCustomers;
    }
    
    if ([self.title isEqualToString:@"贷款人信息"])
    {
        for (int i = 0; i < bizCustomers.count; i++) {
            BizCustomers *info = bizCustomers[i];
            if ([info.releation intValue] == 2 || [info.releation intValue] == 3) {
                return NO;
            }
        }
        return YES;
    }
    else if ([self.title isEqualToString:@"担保人信息"])
    {
        for (int i = 0; i < bizCustomers.count; i++) {
            BizCustomers *info = bizCustomers[i];
            if ([info.releation intValue] == 6) {
                return NO;
            }
        }
        return YES;
    }
    else if ([self.title isEqualToString:@"卖方信息"])
    {
        for (int i = 0; i < bizCustomers.count; i++) {
            BizCustomers *info = bizCustomers[i];
            if ([info.releation intValue] == 8) {
                return NO;
            }
        }
        return YES;
    }
    else if ([self.title isEqualToString:@"买方信息"])
    {
        for (int i = 0; i < bizCustomers.count; i++) {
            BizCustomers *info = bizCustomers[i];
            if ([info.releation intValue] == 10) {
                return NO;
            }
        }
        return YES;
    }
    else
    {
        return YES;
    }
}

#pragma mark ZSAlertViewDelegate
//确认按钮响应
- (void)AlertView:(ZSAlertView *)alert
{
    //相机打开失败
    if (alert.tag == openCameraFailTag)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    //修改婚姻状况
    //不填写手机直接上传
    else if (alert.tag == changeMarryTag || alert.tag == hasnoPhoneNum)
    {
        [self createOrder];
    }
    //返回信息不回保存
    else if (alert.tag == noticeTag)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    //扫描失败
    else if (alert.tag == scanTag)
    {
        [self imagePicker];
    }
    //修改手机号后是否重新验证
    else if (alert.tag == revalidationPhone)
    {
        self.isChangePhone = @"1";
        [self createOrder];
    }
    //删除人员信息接口调用
    else if (alert.tag == deletePersonTag)
    {
        NSMutableDictionary *parameterDict = @{
                                               @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                               @"custId":global.bizCustomers.tid,
                                               @"prdType":self.prdType
                                               }.mutableCopy;
        __weak typeof(self) weakSelf  = self;
        [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getDeleteMate] SuccessBlock:^(NSDictionary *dic) {
            //通知星速贷订单详情刷新(提交订单之前)
            [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailForNoSumbitNotification object:nil];
            //通知星速贷订单详情刷新(已提交订单)
            [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
            //通知所有列表刷新
            [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
            //删除成功返回订单详情
            [weakSelf backActionOfDeletePerson];
        } ErrorBlock:^(NSError *error) {
        }];
    }
}

//取消按钮响应的方法
- (void)AlertViewCanCleClick:(ZSAlertView *)alert;
{
    //修改手机号后是否重新验证
    if (alert.tag == revalidationPhone)
    {
        self.isChangePhone = @"2";
        [self createOrder];
    }
    //已有订单添加人没有填写手机号
    else if (alert.tag == hasnoPhoneNum)
    {
        [self.phoneNumView.inputTextFeild becomeFirstResponder];
    }
}

#pragma mark 创建订单
- (void)createOrder
{
    __weak typeof(self) weakSelf  = self;
    [LSProgressHUD showToView:self.view message:@"提交中"];
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        [ZSRequestManager requestWithParameter:[self getCreateUserParamter] url:[ZSURLManager getStarLoanAddOrEditorCustomer] SuccessBlock:^(NSDictionary *dic)
         {
             //存值(用于返回上个页面)
             global.slOrderDetails = [ZSSLOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
             //通知星速贷订单详情刷新(提交订单之前)
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailForNoSumbitNotification object:nil];
             //通知星速贷订单详情刷新(已提交订单)
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
             //通知所有列表刷新
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
             //页面跳转
             [weakSelf backActionOfCreateOrder];
             [LSProgressHUD hideForView:weakSelf.view];
         } ErrorBlock:^(NSError *error) {
             [LSProgressHUD hideForView:weakSelf.view];
         }];
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        [ZSRequestManager requestWithParameter:[self getCreateUserParamter] url:[ZSURLManager getRedeemFloorAddOrEditorCustomer] SuccessBlock:^(NSDictionary *dic)
         {
             //存值(用于返回上个页面)
             global.rfOrderDetails = [ZSRFOrderDetailsModel yy_modelWithDictionary:dic[@"respData"]];
             //通知赎楼宝订单详情刷新(提交订单之前)
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailForNoSumbitNotification object:nil];
             //通知赎楼宝订单详情刷新(已提交订单)
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
             //通知所有列表刷新
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
             //页面跳转
             [weakSelf backActionOfCreateOrder];
             [LSProgressHUD hideForView:weakSelf.view];
         } ErrorBlock:^(NSError *error) {
             [LSProgressHUD hideForView:weakSelf.view];
         }];
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        [ZSRequestManager requestWithParameter:[self getCreateUserParamter] url:[ZSURLManager getMortgageLoanAddOrEditorCustomer] SuccessBlock:^(NSDictionary *dic)
         {
             //存值(用于返回上个页面)
             global.mlOrderDetails = [ZSMLOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
             //通知抵押贷订单详情刷新(提交订单之前)
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailForNoSumbitNotification object:nil];
             //通知抵押贷订单详情刷新(已提交订单)
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
             //通知所有列表刷新
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
             //页面跳转
             [weakSelf backActionOfCreateOrder];
             [LSProgressHUD hideForView:weakSelf.view];
         } ErrorBlock:^(NSError *error) {
             [LSProgressHUD hideForView:weakSelf.view];
         }];
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        [ZSRequestManager requestWithParameter:[self getCreateUserParamter] url:[ZSURLManager getEasyLoanAddOrEditorCustomer] SuccessBlock:^(NSDictionary *dic)
         {
             //存值(用于返回上个页面)
             global.elOrderDetails = [ZSELOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
             //通知融易贷订单详情刷新(提交订单之前)
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailForNoSumbitNotification object:nil];
             //通知融易贷订单详情刷新(已提交订单)
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
             //通知所有列表刷新
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
             //页面跳转
             [weakSelf backActionOfCreateOrder];
             [LSProgressHUD hideForView:weakSelf.view];
         } ErrorBlock:^(NSError *error) {
             [LSProgressHUD hideForView:weakSelf.view];
         }];
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        [ZSRequestManager requestWithParameter:[self getCreateUserParamter] url:[ZSURLManager getCarHireAddOrEditorCustomer] SuccessBlock:^(NSDictionary *dic)
         {
             //存值(用于返回上个页面)
             global.chOrderDetails = [ZSCHOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
             //通知车位分期订单详情刷新(提交订单之前)
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailForNoSumbitNotification object:nil];
             //通知车位分期订单详情刷新(已提交订单)
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
             //通知所有列表刷新
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
             //页面跳转
             [weakSelf backActionOfCreateOrder];
             [LSProgressHUD hideForView:weakSelf.view];
         } ErrorBlock:^(NSError *error) {
             [LSProgressHUD hideForView:weakSelf.view];
         }];
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        [ZSRequestManager requestWithParameter:[self getCreateUserParamter] url:[ZSURLManager getAngencyBusinessAddOrEditorCustomer] SuccessBlock:^(NSDictionary *dic)
         {
             //存值(用于返回上个页面)
             global.abOrderDetails = [ZSABOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
             //通知订单详情刷新(提交订单之前)
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailForNoSumbitNotification object:nil];
             //通知订单详情刷新(已提交订单)
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
             //通知所有列表刷新
             [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
             //页面跳转
             [weakSelf backActionOfCreateOrder];
             [LSProgressHUD hideForView:weakSelf.view];
         } ErrorBlock:^(NSError *error) {
             [LSProgressHUD hideForView:weakSelf.view];
         }];
    }
}

#pragma mark 创建订单/编辑成功后返回相应页面
- (void)backActionOfCreateOrder
{
    NSArray *array = self.navigationController.viewControllers;
    NSString *orderState = [ZSGlobalModel getOrderState:self.prdType];
    
    //1.创建
    if (self.isFromAdd)
    {
        //如果是(暂存状态)并且是创建人是(主贷人)情况下
        if ([orderState isEqualToString:@"暂存"])
        {
            if ([self.title isEqualToString:@"贷款人信息"])
            {
                ZSSLPersonListViewController *vc = [[ZSSLPersonListViewController alloc]init];
                vc.isFromCreatOrder = YES;
                vc.orderState = @"暂存";
                vc.orderIDString = [ZSGlobalModel getOrderID:self.prdType];
                vc.prdType = self.prdType;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            //上个页面为订单详情列表
            if ([array[array.count-2] isKindOfClass:[ZSSLPageController class]]){
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:array.count-2] animated:YES];
            }
            //上上个控制器为星速贷订单列表
            else if ([array[array.count-3] isKindOfClass:[ZSStarLoanPageController class]]){
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:array.count-3] animated:YES];
            }
            else if (array.count > 4){
                //上上上个控制器为星速贷订单列表
                if ([array[array.count-4] isKindOfClass:[ZSStarLoanPageController class]]){
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:array.count-4] animated:YES];
                }
            }
            else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    //2.编辑
    if (self.isFromEditor)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 创建订单请求的参数
- (NSMutableDictionary *)getCreateUserParamter
{
    NSMutableDictionary *parameter = @{
                                       @"name":self.nameView.inputTextFeild.text,
                                       @"identityNo":self.IDcardView.inputTextFeild.text,
                                       @"identityPosUrl":self.urlFront,
                                       @"identityBakUrl":self.urlBack}.mutableCopy;
    //订单号
    if (self.isFromAdd) {
        if (![self.title isEqualToString:@"贷款人信息"]) {
            [parameter setObject:self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType]  forKey:@"serialNo"];
        }
    }
    else if (self.isFromEditor) {
        [parameter setObject:self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType]  forKey:@"serialNo"];
    }
    //人员id
    if (self.isFromAdd) {
        [parameter setObject:@"" forKey:@"custNo"];
    }else{
        [parameter setObject:global.bizCustomers.tid ? global.bizCustomers.tid : @"" forKey:@"custNo"];
    }
    //人员角色
    [parameter setObject:[ZSGlobalModel getReleationCodeWithState:self.title] forKey:@"releation"];
    //手机号
    if (![self.phoneNumView.inputTextFeild.text isEqualToString:KPlaceholderInput]) {
        [parameter setObject:[ZSTool filteringTheBlankSpace:self.phoneNumView.inputTextFeild.text] forKey:@"cellphone"];
    }
    //婚姻状况 1未婚 2已婚 3离异 4丧偶
    if ([self.title isEqualToString:@"贷款人信息"] ||
        [self.title isEqualToString:@"卖方信息"] ||
        [self.title isEqualToString:@"买方信息"] ||
        [self.title isEqualToString:@"担保人信息"])
    {
        NSString *beMarry = [ZSGlobalModel getMarrayCodeWithState:self.marryView.rightLabel.text];
        [parameter setObject:beMarry forKey:@"beMarrage"];
    }else{
        [parameter setObject:@"" forKey:@"beMarrage"];
    }
    //与贷款人关系 1朋友 2直系亲属
    if ([self.title isEqualToString:@"共有人信息"]) {
        [parameter setObject:[ZSGlobalModel getRelationshipCodeWithState:self.marryView.rightLabel.text] forKey:@"lenderReleation"];
    }else{
        [parameter setObject:@"" forKey:@"lenderReleation"];
    }
    //是否查询大数据风控 0不查询 1查询
    [parameter setObject:[ZSGlobalModel getBigDataCodeWithState:self.bigDataView.rightLabel.text] forKey:@"isBigDataCreditInfo"];
    //是否重新验证手机号的大数据风控 1立即验证 2暂不验证
    if (self.isChangePhone) {
        if (self.isChangePhone.intValue == 1) {
            [parameter setObject:@"1" forKey:@"phoneVerify"];
        }else{
            [parameter setObject:@"2" forKey:@"phoneVerify"];
        }
    }
    else{
        [parameter setObject:@"" forKey:@"phoneVerify"];
    }
    //订单来源 1中介 2线下 3微信 4官网
    if (self.orderIDString) {
        [parameter setObject:@"" forKey:@"dataSrc"];
        [parameter setObject:@"" forKey:@"agencyId"];//中介id
        [parameter setObject:@"" forKey:@"applyId"];//申请id
    }
    else if (self.onlineOrderIDString)
    {
        if (self.isFromWeiXin) {
            [parameter setObject:@"3" forKey:@"dataSrc"];
        }else if (self.isFromOfficial) {
            [parameter setObject:@"4" forKey:@"dataSrc"];
        }
        [parameter setObject:self.onlineOrderIDString forKey:@"applyId"];
        [parameter setObject:@"" forKey:@"agencyId"];
    }
    else
    {
        if (self.mediumID) {
            [parameter setObject:@"1" forKey:@"dataSrc"];
            [parameter setObject:self.mediumID forKey:@"agencyId"];
        }else{
            [parameter setObject:@"2" forKey:@"dataSrc"];
            [parameter setObject:@"" forKey:@"agencyId"];
        }
        [parameter setObject:@"" forKey:@"applyId"];
    }
    //中介联系人名字
    if (self.mediumName) {
        [parameter setObject:self.mediumName forKey:@"agencyContact"];
    }else{
        [parameter setObject:@"" forKey:@"agencyContact"];
    }
    //中介联系人方式
    if (self.mediumPhone) {
        [parameter setObject:self.mediumPhone forKey:@"agencyContactPhone"];
    }else{
        [parameter setObject:@"" forKey:@"agencyContactPhone"];
    }
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
        //姓名长度显示40
        if ([toBeString length] > 40) {
            textField.text = [toBeString substringToIndex:40];
            return NO;
        }
    }
    //手机号长度显示11(空格占俩位)
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

#pragma mark ZSInputOrSelectViewDelegate---选择婚姻状况---选择大数据风控
- (void)clickBtnAction:(ZSInputOrSelectView *)view
{
    //隐藏键盘
    [self.nameView.inputTextFeild resignFirstResponder];
    [self.IDcardView.inputTextFeild resignFirstResponder];
    [self.phoneNumView.inputTextFeild resignFirstResponder];
    
    //婚姻状况/与贷款人关系
    if (view == self.marryView)
    {
        ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:[self getActionsheetArray]];
        actionsheet.delegate = self;
        actionsheet.tag = marryStateTag;
        [actionsheet show:[self getActionsheetArray].count];
    }
    //大数据风控
    else if (view == self.bigDataView)
    {
        //如果已经选择查询,则不允许修改,还是根据值去判断吧
        ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:@[@"查询",@"不查询"]];
        actionsheet.delegate = self;
        actionsheet.tag = bigDataStateTag;
        [actionsheet show:2];
    }
    //    //央行征信报告
    //    else if (view == self.bankReferenceView)
    //    {
    //
    //    }
    //    //户口本
    //    else if (view == self.residenceView)
    //    {
    //        ZSSLAddresourceViewController *receiveVC = [[ZSSLAddresourceViewController alloc]init];
    //        receiveVC.title           = @"户口本";
    //        receiveVC.isShowAdd       = YES;
    //        receiveVC.addDataStyle    = ZSAddResourceDataTwo; //户口本两个加号
    //        receiveVC.lastVCType      = ZSFromAddCustomerWitnHostMan;
    //        [self.navigationController pushViewController:receiveVC animated:YES];
    //    }
}

- (void)SheetView:(ZSActionSheetView *)sheetView btnClick:(NSInteger)tag
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
    //婚姻状况
    else if (sheetView.tag == marryStateTag)
    {
        self.marryView.rightLabel.text = [self getActionsheetArray][tag];
        self.marryView.rightLabel.textColor = ZSColorListRight;
        self.editorMessageChange = YES;
        self.isChangeAnyData = YES;//用于返回提示信息未保存
    }
    //大数据风控
    else if (sheetView.tag == bigDataStateTag)
    {
        self.bigDataView.rightLabel.text = tag == 0 ? @"查询" : @"不查询";
        self.bigDataView.rightLabel.textColor = ZSColorListRight;
        self.editorMessageChange = YES;
        self.isChangeAnyData = YES;//用于返回提示信息未保存
    }
    
    //检查底部按钮
    [self CheckBottomBtnClick];
}

- (NSArray *)getActionsheetArray
{
    NSArray *array;
    if ([self.marryLabelNotice isEqualToString:@"婚姻状况"]) {
        array = [ZSGlobalModel getMarrayStateArray];
    }else if ([self.marryLabelNotice isEqualToString:@"与贷款人关系"]) {
        array = [ZSGlobalModel getRelationshipStateArray];
    }
    return array;
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

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView
{
    return CGSizeMake((ZSWIDTH - 75), (ZSWIDTH - 75) /1.58);
}

#pragma mark NewPagedFlowView Datasource
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
    if (pageNumber>=0 && pageNumber<2) {
        NSArray *pageNumberArray=[NSArray arrayWithObjects:@"身份证正面(必填)",@"身份证反面(必填)",nil];
        self.indicateLabel.text= [pageNumberArray objectAtIndex:pageNumber];
    }
}

#pragma mark 选择要输入的身份证图片--第几页
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex
{
    self.currentTapView = subView;//用于显示大图
    [self.view endEditing:YES];
    self.buttonInteger = subIndex;
    if (!self.isFromAdd && global.bizCustomers.name.length)
    {
        //订单提交之前可以修改任何信息,提交之后不允许修改照片,只能查看大图
        if ([self checkOrderState]) {
            [self setArrayWithAction:subIndex];
        }
        else{
            [self showBigImage];
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
    if (global.bizCustomers.identityPos.length && global.bizCustomers.identityBak.length) {
        photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,global.bizCustomers.identityPos],[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,global.bizCustomers.identityBak]].mutableCopy;
    }else{
        if (self.urlFront && self.urlBack) {
            photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.urlFront],[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.urlBack]].mutableCopy;
        }
        if (self.urlFront && !self.urlBack) {
            photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.urlFront]].mutableCopy;
        }
        if (!self.urlFront && self.urlBack) {
            photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.urlBack]].mutableCopy;
        }
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
        }else{
            photoBroseView.currentIndex = 1;
        }
    }
    // 3.显示(浏览)
    [photoBroseView show];
}

#pragma mark /*--------------------------------身份证有效期-------------------------------------------*/
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
    //底部按钮
    if (self.idCardLabelVaild) {
        //身份证有效期占位
        self.bottomBtn.top = pageFlowViewHEIGHT + CellHeight*self.numOfRow + (60-CellHeight) + 15 + 10;
    }else{
        self.bottomBtn.top = pageFlowViewHEIGHT + CellHeight*self.numOfRow + 15 + 10;
    }
    self.scrollview.contentSize = CGSizeMake(ZSWIDTH,self.bottomBtn.bottom+25);
}


#pragma mark /*--------------------------------身份证扫描-------------------------------------------*/
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
    
    //    NSLog(@"身份证识别成功:%d",idInfo.type);
    if (idInfo.type != 0)
    {
        //身份证正面
        if (idInfo.type == 1) {
            if (idInfo.faceImg != nil) {
                //获取图片url
                NSData *data = UIImageJPEGRepresentation(idInfo.frontFullImg,[ZSTool configureRandomNumber]);
                [self uploadFrontImageData:data withOcrIdentify:NO];
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
        }
        //身份证反面
        else
        {
            if (idInfo.backFullImg != nil) {
                //获取图片url
                NSData *data = UIImageJPEGRepresentation(idInfo.backFullImg, [ZSTool configureRandomNumber]);
                [self uploadReverseImageData:data];
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
    //    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //    picker.delegate = self;
    //    [self presentViewController:picker animated:YES completion:nil];
    
#pragma mark 用系统原生的不提示相册权限, 还是改成第三方吧
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.delegate = self;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.isSelectOriginalPhoto = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    //照片数据处理
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self dealWithImage:photos[0]];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark 拍照或选中相册的回调结果
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dealWithImage:info[UIImagePickerControllerOriginalImage]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 照片数据处理
- (void)dealWithImage:(UIImage *)Photoimage
{
    //用于返回提示未保存信息
    self.isChangeAnyData = YES;
    
    //图片处理
    if (Photoimage != nil) {
        //修正图片方向
        UIImage *imagerotate = [UIImage fixOrientation:Photoimage];
        NSData *data = UIImageJPEGRepresentation(imagerotate, [ZSTool configureRandomNumber]);
        //照片回显
        [self.imageArray replaceObjectAtIndex:self.buttonInteger withObject:imagerotate];
        if (self.buttonInteger == 0) {
            [self uploadFrontImageData:data withOcrIdentify:YES];
        }
        else if (self.buttonInteger == 1) {
            [self removeNoticeOfValidityIDCard];//移除判断身份证有效期的label
            [self uploadReverseImageData:data];
        }
    }
}

#pragma mark /*--------------------------------图片上传-------------------------------------------*/
#pragma mark 上传照片(身份证正面) 分成两个方法调用,上传成功回调里面的操作才不会有问题
- (void)uploadFrontImageData:(NSData *)data withOcrIdentify:(BOOL)isNeedUpload
{
    //UI变动
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)self.pageFlowView.cells[0];
    [LSProgressHUD showToView:bannerView.mainImageView message:@"上传中..."];
    [self performSelector:@selector(scrollToPageOne) withObject:nil afterDelay:0.75];
    
    //1.先上传到ZImg服务器获取到URL
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager uploadImageWithNativeAPI:data SuccessBlock:^(NSDictionary *dic) {
        NSString *dataUrl = [NSString stringWithFormat:@"%@",dic[@"MD5"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //2.在上传URL到自己的服务器做图像识别
            if (isNeedUpload == YES) {
                [weakSelf uploadImageUrl:dataUrl];
            }
            weakSelf.urlFront = dataUrl;//用于接口参数
            [weakSelf CheckBottomBtnClick];//检测底部按钮状态
        });
        [weakSelf.pageFlowView reloadData];//刷新顶部的三张照片
        [LSProgressHUD hideForView:bannerView.mainImageView];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:bannerView.mainImageView];
        [ZSTool showMessage:@"图片上传失败,请重试" withDuration:DefaultDuration];
    }];
}

#pragma mark 上传照片(身份证反面)
- (void)uploadReverseImageData:(NSData *)data
{
    //UI变动
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)self.pageFlowView.cells[1];
    [LSProgressHUD showToView:bannerView.mainImageView message:@"上传中..."];
    
    //1.先上传到ZImg服务器获取到URL
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager uploadImageWithNativeAPI:data SuccessBlock:^(NSDictionary *dic) {
        NSString *dataUrl = [NSString stringWithFormat:@"%@",dic[@"MD5"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.urlBack = dataUrl;
            [weakSelf CheckBottomBtnClick];//检测底部按钮状态
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

- (void)uploadImageUrl:(NSString *)dataUrl
{
    NSMutableDictionary *dict = @{
                                  @"url":dataUrl,
                                  @"ocrType":@"idCard",
                                  }.mutableCopy;
    __weak typeof(self) weakSelf  = self;
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

#pragma mark 根据情况判断底部按钮可否点击
- (void)CheckBottomBtnClick
{
    if ([self.title isEqualToString:@"贷款人信息"])
    {
        if (self.urlFront &&
            self.urlBack &&
            self.nameView.inputTextFeild.text.length>0 &&
            self.IDcardView.inputTextFeild.text.length>0 &&
            self.phoneNumView.inputTextFeild.text.length>0 && //主贷人 手机号必填
            ![self.marryView.rightLabel.text isEqualToString:KPlaceholderChoose] &&
            ![self.bigDataView.rightLabel.text isEqualToString:KPlaceholderChoose])
        {
            [self setBottomBtnEnable:YES];//恢复点击
        }
        else{
            [self setBottomBtnEnable:NO];//不可点击
        }
    }
    else if ([self.title isEqualToString:@"担保人信息"] ||
             [self.title isEqualToString:@"卖方信息"] ||
             [self.title isEqualToString:@"共有人信息"] ||
             [self.title isEqualToString:@"买方信息"])
    {
        if (self.urlFront &&
            self.urlBack &&
            self.nameView.inputTextFeild.text.length>0 &&
            self.IDcardView.inputTextFeild.text.length>0 &&
            ![self.marryView.rightLabel.text isEqualToString:KPlaceholderChoose] &&
            ![self.bigDataView.rightLabel.text isEqualToString:KPlaceholderChoose])
        {
            [self setBottomBtnEnable:YES];//恢复点击
        }
        else{
            [self setBottomBtnEnable:NO];//不可点击
        }
    }
    else if ([self.title isEqualToString:@"贷款人配偶信息"] ||
             [self.title isEqualToString:@"担保人配偶信息"] ||
             [self.title isEqualToString:@"卖方配偶信息"] ||
             [self.title isEqualToString:@"买方配偶信息"])
    {
        if (self.urlFront &&
            self.urlBack &&
            self.nameView.inputTextFeild.text.length>0 &&
            self.IDcardView.inputTextFeild.text.length>0 &&
            ![self.bigDataView.rightLabel.text isEqualToString:KPlaceholderChoose])
        {
            [self setBottomBtnEnable:YES];//恢复点击
        }
        else{
            [self setBottomBtnEnable:NO];//不可点击
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

