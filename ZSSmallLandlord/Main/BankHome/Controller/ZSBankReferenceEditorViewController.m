//
//  ZSBankReferenceEditorViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSBankReferenceEditorViewController.h"
#import "ZSInputOrSelectView.h"
#import "ZSPhotoContainerView.h"
#import "ZSWSDataCollectionView.h"
#import "IQKeyboardManager.h"


#define itemWidth  (ZSWIDTH- (1+4)*10)/4
#define itemHeight (ZSWIDTH- (1+4)*10)/4

@interface ZSBankReferenceEditorViewController ()<ZSInputOrSelectViewDelegate,ZSActionSheetViewDelegate,ZSWSDataCollectionViewDelegate,UITextFieldDelegate>{
    UIImageView        *playImg;
    NSArray            *needUploadArray;//待上传的图片或视频对象）
    LSProgressHUD      *hud;
    CGFloat            keyboardHeight;//键盘高度
}

@property (nonatomic,strong)UIScrollView          *scroll_bg;
@property (nonatomic,strong)ZSInputOrSelectView   *view_name;        //姓名
@property (nonatomic,strong)ZSInputOrSelectView   *view_IDcard;      //身份证号
@property (nonatomic,strong)ZSPhotoContainerView  *view_photo;       //图片
@property (nonatomic,strong)ZSInputOrSelectView   *view_credit;      //征信结果
@property (nonatomic,strong)ZSInputOrSelectView   *view_creditRemark; //征信说明
@property (nonatomic,strong)ZSInputOrSelectView   *view_houseLoan;   //房贷
@property (nonatomic,strong)ZSInputOrSelectView   *view_VISAcard;    //信用卡
@property (nonatomic,strong)ZSInputOrSelectView   *view_consumerLoan;//消费贷
@property (nonatomic,strong)ZSInputOrSelectView   *view_else;        //其他
@property (nonatomic,strong)ZSWSDataCollectionView  *dataCollectionView;//照片

@property(nonatomic,strong)NSMutableArray *itemNameArray;//标题数组
@property(nonatomic,strong)NSMutableArray *itemDataArray;//值数组
@property(nonatomic,strong)NSMutableArray *fileArray;//请求数据数组
@end

@implementation ZSBankReferenceEditorViewController

#pragma mark 懒加载
- (NSMutableArray *)fileArray {
    if (_fileArray == nil){
        _fileArray = [[NSMutableArray alloc]init];
    }
    return _fileArray;
}

- (NSMutableArray *)itemDataArray {
    if (_itemDataArray == nil){
        _itemDataArray = [[NSMutableArray alloc]init];
    }
    return _itemDataArray;
}

- (NSMutableArray *)itemNameArray {
    if (_itemNameArray == nil){
        _itemNameArray = [[NSMutableArray alloc]init];
    }
    return _itemNameArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = self.isNotFeedback ? @"征信反馈" : @"征信结果";
    [self setLeftBarButtonItem];//返回按钮
    [self initViews];
    //Data
    [self judgeWhetherTheDataCanEdit];
    [self initData];
}

#pragma mark 判断数据是否可以编辑
- (void)judgeWhetherTheDataCanEdit
{
    if (!self.isNotFeedback) {
        self.view_credit.userInteractionEnabled = NO;
        self.view_creditRemark.userInteractionEnabled = NO;
        self.view_houseLoan.userInteractionEnabled = NO;
        self.view_VISAcard.userInteractionEnabled = NO;
        self.view_consumerLoan.userInteractionEnabled = NO;
        self.view_else.userInteractionEnabled = NO;
        self.dataCollectionView.isShowAdd = NO;
    }
}

#pragma mark 数据填充
- (void)initData
{
    if (global.wsCustInfo.name)
    {
        //姓名
        self.view_name.rightLabel.text = global.wsCustInfo.name;
        //身份证号
        self.view_IDcard.rightLabel.text = global.wsCustInfo.identityNo;
        //身份证照片
        NSArray *array = [[NSArray alloc]initWithObjects:global.wsCustInfo.identityPos, global.wsCustInfo.identityBak,global.wsCustInfo.authorizeImg,nil];
        [self.view_photo LoadImgs:array];
        //征信结果
        if (self.isNotFeedback == NO) {
            self.view_credit.rightImgView.hidden = YES;
            self.view_credit.rightLabel.right = ZSWIDTH-15;
        }else{
            self.view_credit.rightImgView.hidden = NO;
            self.view_credit.rightLabel.right = ZSWIDTH-30;
        }
        if (global.wsCustInfo.creditResult.intValue == 0) {
            if (self.isNotFeedback == NO) {
                self.view_credit.rightLabel.text = @"未反馈";
                self.view_credit.rightLabel.textColor = ZSColorListRight;
            }
        }else if (global.wsCustInfo.creditResult.intValue == 1) {
            self.view_credit.rightLabel.text = @"已反馈-通过";
            self.view_credit.rightLabel.textColor = ZSColorGreen;
        }else if (global.wsCustInfo.creditResult.intValue == 2) {

            self.view_credit.rightLabel.text = @"已反馈-不通过";
            self.view_credit.rightLabel.textColor = ZSColorRed;
        }
        //征信说明
        ////注意：再前两种方法中,UITextView在上下左右分别有一个8px的padding，需要将UITextView.contentSize.width减去16像素（左右的padding 2 x 8px）。同时返回的高度中再加上16像素（上下的padding），这样得到的才是UITextView真正适应内容的高度。如代码中 CGSizeMake(width -16.0, CGFLOAT_MAX)，return sizeToFit.height + 16.0。UILable中则不用
        CGSize size = CGSizeMake(ZSWIDTH-115-15-16,10000);
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil];
        if (global.wsCustInfo.remark.length > 0) {
            NSString *string = SafeStr(global.wsCustInfo.remark);
            CGSize labelsize = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
            self.view_creditRemark.inputTextView.text = string;
            self.view_creditRemark.placeholderLabel.hidden = YES;
            if (labelsize.height > 17.900391) {//不要问我这个数字怎么来的,当行的时候打印啊哈哈哈哈哈哈哈哈哈
                self.view_creditRemark.inputTextView.textAlignment = NSTextAlignmentLeft;
            }
            if (labelsize.height > CellHeight) {
                self.view_creditRemark.height = labelsize.height+20;
                self.view_creditRemark.inputTextView.height = self.view_creditRemark.height;
                self.view_creditRemark.lineView.top = self.view_creditRemark.height-0.5;
            }
            [self resetViewFrame];
        }else{
            if (self.isNotFeedback == NO){
                self.view_creditRemark.height = 0;
                self.view_creditRemark.hidden = YES;
                [self resetViewFrame];
            }
        }
        //房贷
        if (global.wsCustInfo.houseloanInf.length > 0) {
            NSString *string = SafeStr(global.wsCustInfo.houseloanInf);
            CGSize labelsize = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
            self.view_houseLoan.inputTextView.text = string;
            self.view_houseLoan.placeholderLabel.hidden = YES;
            if (labelsize.height > 17.900391) {//不要问我这个数字怎么来的,当行的时候打印啊哈哈哈哈哈哈哈哈哈
                self.view_houseLoan.inputTextView.textAlignment = NSTextAlignmentLeft;
            }
            if (labelsize.height > CellHeight) {
                self.view_houseLoan.height = labelsize.height+20;
                self.view_houseLoan.inputTextView.height = self.view_houseLoan.height;
                self.view_houseLoan.lineView.top = self.view_houseLoan.height-0.5;
            }
            [self resetViewFrame];
        }else{
            if (self.isNotFeedback == NO){
                self.view_houseLoan.height = 0;
                self.view_houseLoan.hidden = YES;
                [self resetViewFrame];
            }
        }
        //信用卡
        if (global.wsCustInfo.creditcardInf.length > 0) {
            NSString *string = SafeStr(global.wsCustInfo.creditcardInf);
            CGSize labelsize = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
            self.view_VISAcard.inputTextView.text = string;
            self.view_VISAcard.placeholderLabel.hidden = YES;
            if (labelsize.height > 17.900391) {//不要问我这个数字怎么来的,当行的时候打印啊哈哈哈哈哈哈哈哈哈
                self.view_VISAcard.inputTextView.textAlignment = NSTextAlignmentLeft;
            }
            if (labelsize.height > CellHeight) {
                self.view_VISAcard.height = labelsize.height+20;
                self.view_VISAcard.inputTextView.height = self.view_VISAcard.height;
                self.view_VISAcard.lineView.top = self.view_VISAcard.height-0.5;
            }
            [self resetViewFrame];
        }else{
            if (self.isNotFeedback == NO){
                self.view_VISAcard.height = 0;
                self.view_VISAcard.hidden = YES;
                [self resetViewFrame];
            }
        }
        //消费贷
        if (global.wsCustInfo.consumeInf.length > 0) {
            NSString *string = SafeStr(global.wsCustInfo.consumeInf);
            CGSize labelsize = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
            self.view_consumerLoan.inputTextView.text = string;
            self.view_consumerLoan.placeholderLabel.hidden = YES;
            if (labelsize.height > 17.900391) {//不要问我这个数字怎么来的,当行的时候打印啊哈哈哈哈哈哈哈哈哈
                self.view_consumerLoan.inputTextView.textAlignment = NSTextAlignmentLeft;
            }
            if (labelsize.height > CellHeight) {
                self.view_consumerLoan.height = labelsize.height+20;
                self.view_consumerLoan.inputTextView.height = self.view_consumerLoan.height;
                self.view_consumerLoan.lineView.top = self.view_consumerLoan.height-0.5;
            }
            [self resetViewFrame];
        }else{
            if (self.isNotFeedback == NO){
                self.view_consumerLoan.height = 0;
                self.view_consumerLoan.hidden = YES;
                [self resetViewFrame];
            }
        }
        //其他
        if (global.wsCustInfo.otherInf.length > 0) {
            NSString *string = SafeStr(global.wsCustInfo.otherInf);
            CGSize labelsize = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
            self.view_else.inputTextView.text = string;
            self.view_else.placeholderLabel.hidden = YES;
            if (labelsize.height > 17.900391) {//不要问我这个数字怎么来的,当行的时候打印啊哈哈哈哈哈哈哈哈哈
                self.view_else.inputTextView.textAlignment = NSTextAlignmentLeft;
            }
            if (labelsize.height > CellHeight) {
                self.view_else.height = labelsize.height+20;
                self.view_else.inputTextView.height = self.view_else.height;
                self.view_else.lineView.top = self.view_else.height-0.5;
            }
            [self resetViewFrame];
        }else{
            if (self.isNotFeedback == NO){
                self.view_else.height = 0;
                self.view_else.hidden = YES;
                [self resetViewFrame];
            }
        }
        //照片
    }
}

#pragma mark 照片数据
- (void)configureDataSource
{
    //修整数据。把数据转换成  大数组装小数组，且以对象的形式添加
    NSMutableArray *dataArray = @[].mutableCopy;
    if (global.wsCustInfo.docsDataList.count > 0){
        for (ZSWSFileCollectionModel *fileModel in global.wsCustInfo.docsDataList) {
            [dataArray addObject:fileModel];
            fileModel.thumbnailUrl = [NSString stringWithFormat:@"%@?w=200",fileModel.dataUrl];//如果是图片,生成缩略图
        }
    }else{
        self.errorView.hidden = NO;
    }
    [self.itemDataArray addObject:dataArray];
    
    self.dataCollectionView.itemArray = self.itemDataArray;
    [self.dataCollectionView.myCollectionView reloadData];
}

#pragma mark UI
- (void)initViews
{
    self.scroll_bg = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-64)];
    self.scroll_bg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scroll_bg];
    //上面不可修改的部分
    //根据角色设置顶部提示信息
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 30)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = ZSPageItemColor;
    NSString *string = [NSString stringWithFormat:@"%@基本资料",[NSString setRoleState:global.wsCustInfo.releation.intValue]];
    string = [string stringByReplacingOccurrencesOfString:@"信息" withString:@""];
    label.text = string;
    [self.scroll_bg addSubview:label];
    //姓名
    self.view_name = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, label.bottom, ZSWIDTH, CellHeight) withLeftTitle:@"姓名" withRightTitle:@""];
    [self.scroll_bg addSubview:self.view_name];
    //身份证号
    self.view_IDcard = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.view_name.bottom, ZSWIDTH, CellHeight) withLeftTitle:@"身份证号" withRightTitle:@""];
    [self.scroll_bg addSubview:self.view_IDcard];
    //图片
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view_IDcard.bottom, ZSWIDTH, (ZSWIDTH-30-30)/4+20)];
    backgroundView.backgroundColor = ZSColorWhite;
    [self.scroll_bg addSubview:backgroundView];
    self.view_photo = [[ZSPhotoContainerView alloc]initWithFrame:CGRectMake(15, 10, ZSWIDTH-30, (ZSWIDTH-30-30)/4+20)];
    [backgroundView addSubview:self.view_photo];
    //征信结果
    self.view_credit = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, backgroundView.bottom+10, ZSWIDTH, CellHeight) withClickAction:@"征信结果 *"];
    self.view_credit.delegate = self;
    [self.scroll_bg addSubview:self.view_credit];
    //征信说明
    self.view_creditRemark = [[ZSInputOrSelectView alloc]initTextViewWithFrame:CGRectMake(0, self.view_credit.bottom, ZSWIDTH, CellHeight) withInputAction:@"征信说明" withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDefault];
    [self.scroll_bg addSubview:self.view_creditRemark];
    //房贷
    self.view_houseLoan = [[ZSInputOrSelectView alloc]initTextViewWithFrame:CGRectMake(0, self.view_creditRemark.bottom, ZSWIDTH, CellHeight) withInputAction:@"房贷" withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDefault];
    [self.scroll_bg addSubview:self.view_houseLoan];
    //信用卡
    self.view_VISAcard = [[ZSInputOrSelectView alloc]initTextViewWithFrame:CGRectMake(0, self.view_houseLoan.bottom, ZSWIDTH, CellHeight) withInputAction:@"信用卡" withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDefault];
    [self.scroll_bg addSubview:self.view_VISAcard];
    //消费贷
    self.view_consumerLoan = [[ZSInputOrSelectView alloc]initTextViewWithFrame:CGRectMake(0, self.view_VISAcard.bottom, ZSWIDTH, CellHeight) withInputAction:@"消费贷" withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDefault];
    [self.scroll_bg addSubview:self.view_consumerLoan];
    //其他
    self.view_else = [[ZSInputOrSelectView alloc]initTextViewWithFrame:CGRectMake(0, self.view_consumerLoan.bottom, ZSWIDTH, CellHeight) withInputAction:@"其他" withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDefault];
    [self.scroll_bg addSubview:self.view_else];
    //textView内容变化时调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ValueChange:) name:UITextViewTextDidChangeNotification object:nil];
    //添加照片
    self.dataCollectionView = [[ZSWSDataCollectionView alloc]initWithFrame:CGRectMake(0, self.view_else.bottom, ZSWIDTH, [self resetHight])];
    self.dataCollectionView.clipsToBounds = YES;
    self.dataCollectionView .delegate = self;
    self.dataCollectionView .isShowTitle = NO;//不显示分组title
    self.dataCollectionView .addDataStyle = ZSAddResourceDataCountless;
    self.dataCollectionView.titleNameArray = @[@""].mutableCopy;
    [self configureDataSource];
    [self.scroll_bg addSubview:self.dataCollectionView];
    //提交反馈按钮
    if (self.isNotFeedback) {
        [self configuBottomButtonWithTitle:@"保存" OriginY:[self resetHight] + 15 + self.view_else.bottom];
        [self.scroll_bg addSubview:self.bottomBtn];
        //重设scroll的size
        self.scroll_bg.contentSize = CGSizeMake(ZSWIDTH,self.bottomBtn.bottom+25);
    }else{
        //重设scroll的size
        self.scroll_bg.contentSize = CGSizeMake(ZSWIDTH,self.dataCollectionView.bottom+15);
    }
}
// 保单最多只能输入20位 费用只能10位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
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
    
    if (textField.text.length>=500) {
        textField.text=[textField.text substringToIndex:500];
    }
    return YES;
}

#pragma mark 征信结果弹窗
- (void)clickBtnAction:(ZSInputOrSelectView *)view
{
    [self hideKeyboard];
    ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:@[@"通过",@"不通过"]];
    actionsheet.delegate = self;
    [actionsheet show:2];
}

- (void)SheetView:(ZSActionSheetView *)sheetView btnClick:(NSInteger)tag
{
    self.view_credit.rightLabel.textColor = ZSColorListRight;
    if (tag == 0) {
        self.view_credit.rightLabel.text = @"通过";
    }else{
        self.view_credit.rightLabel.text = @"不通过";
    }
}

#pragma mark 提交反馈
- (void)bottomClick:(UIButton *)sender
{
    if ([self.view_credit.rightLabel.text isEqualToString:KPlaceholderChoose]) {
        [ZSTool showMessage:@"请选择银行征信结果" withDuration:DefaultDuration];
    }
    else{
        if ([self.dataCollectionView.deletdataIDArray count]>0) {
            [self deletaDatas];
        }else  {
            [self uploadAllDatas];
        }
    }
}

#pragma mark 提交反馈的参数
- (NSMutableDictionary *)getParameter
{
    NSMutableDictionary *parameter = @{
                                       @"orderNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       @"custNo":global.wsCustInfo.tid,
                                       }.mutableCopy;
    //征信反馈结果
    if ([self.view_credit.rightLabel.text isEqualToString:@"通过"] || [self.view_credit.rightLabel.text isEqualToString:@"已反馈-通过"]) {
        [parameter setObject:@"1" forKey:@"creditResult"];
    }else if ([self.view_credit.rightLabel.text isEqualToString:@"不通过"] || [self.view_credit.rightLabel.text isEqualToString:@"已反馈-不通过"]){
        [parameter setObject:@"2" forKey:@"creditResult"];
    }
    //征信说明
    if (![self.view_creditRemark.inputTextView.text isEqualToString:KPlaceholderInput]) {
        [parameter setObject:self.view_creditRemark.inputTextView.text forKey:@"remark"];
    }else{
        [parameter setObject:@"" forKey:@"remark"];
    }
    //房贷
    if (![self.view_houseLoan.inputTextView.text isEqualToString:KPlaceholderInput]) {
        [parameter setObject:self.view_houseLoan.inputTextView.text forKey:@"houseloanInf"];
    }else{
        [parameter setObject:@"" forKey:@"houseloanInf"];
    }
    //信用卡
    if (![self.view_VISAcard.inputTextView.text isEqualToString:KPlaceholderInput]) {
        [parameter setObject:self.view_VISAcard.inputTextView.text forKey:@"creditcardInf"];
    }else{
        [parameter setObject:@"" forKey:@"creditcardInf"];
    }
    //消费贷
    if (![self.view_consumerLoan.inputTextView.text isEqualToString:KPlaceholderInput]) {
        [parameter setObject:self.view_consumerLoan.inputTextView.text forKey:@"consumeInf"];
    }else{
        [parameter setObject:@"" forKey:@"consumeInf"];
    }
    //其他
    if (![self.view_else.inputTextView.text isEqualToString:KPlaceholderInput]) {
        [parameter setObject:self.view_else.inputTextView.text forKey:@"otherInf"];
    }else{
        [parameter setObject:@"" forKey:@"otherInf"];
    }
    NSString *deleteIDStr = [self.dataCollectionView.deletdataIDArray componentsJoinedByString:@","];
    [parameter setObject:deleteIDStr forKey:@"photoIds"];//删除图片id集合
    //照片
    return parameter;
}

#pragma mark 上传所有资料
- (void)uploadAllDatas
{
    //圆形进度条
    needUploadArray=[self getNeedUploadFilesArray];
    if ([needUploadArray count]){//有图片上传
        hud = [LSProgressHUD showWithMessage:[NSString stringWithFormat:@"已上传0/%ld",(unsigned long)[needUploadArray count]]];
        [self setBottomBtnEnable:NO];//上传时，禁止交互. 上传失败，恢复交互性
        [self uploadDataWithUploadFileCache:0];

    }else{
        //无图片上传
        [self requestForBankCreditData];
    }
}

#pragma mark 上传单个资料
- (void)uploadDataWithUploadFileCache:(NSInteger)selectIndex
{
    if (needUploadArray.count > 0){
        ZSWSFileCollectionModel *fileCache = needUploadArray[selectIndex];
        BOOL isVideo = fileCache.videoPath.length > 0 ? YES : NO;
        NSData *data = nil;
        if (fileCache.videoPath.length) {
            NSURL *url=[NSURL fileURLWithPath:fileCache.videoPath];
            data = [NSData dataWithContentsOfURL:url];
        }
        else{
            data = UIImageJPEGRepresentation(fileCache.image, [ZSTool configureRandomNumber]);
        }
        
        [ZSRequestManager uploadImagesAndVideosWithParameters:[self getParameter] url:[ZSURLManager getEditorBankCreditInvestigation] Data:nil isVideo:isVideo SuccessBlock:^(NSDictionary *dic) {
            
            if (fileCache.videoPath.length > 0) {
                //从视频原来储存的地方删除
                [FILE_MANAGER removeItemAtPath:fileCache.videoPath error:nil];
            }
            hud.messageLabel.text=[NSString stringWithFormat:@"已上传%d/%ld",(int)selectIndex+1,(unsigned long)needUploadArray.count];
            if (selectIndex == needUploadArray.count-1) {
                //当缓存删除完时,上传成功。
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [LSProgressHUD hide];
                    [LSProgressHUD hideForView:self.view];
                    [ZSTool showMessage:@"上传成功" withDuration:DefaultDuration];
                    //通知银行后勤人员列表刷新
                    [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                NSInteger nextIndex = selectIndex+1;
                [self uploadDataWithUploadFileCache:nextIndex];
            }
        } ErrorBlock:^(NSError *error) {
            [self setBottomBtnEnable:YES];
            [LSProgressHUD hide];
            [LSProgressHUD hideForView:self.view];
        }];
    }
}

#pragma mark 没有图片上传掉接口
- (void)requestForBankCreditData
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager uploadImagesAndVideosWithParameters:[self getParameter] url:[ZSURLManager getEditorBankCreditInvestigation] Data:nil isVideo:NO SuccessBlock:^(NSDictionary *dic) {
        //通知银行后勤人员列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [LSProgressHUD hide];
        [LSProgressHUD hideForView:self.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
        [LSProgressHUD hideForView:self.view];
    }];
}

#pragma mark 删除资料请求
- (void)deletaDatas
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager uploadImagesAndVideosWithParameters:[self deleteIdParameter] url:[ZSURLManager getUpdateOrDelPhotoDataURL] Data:nil isVideo:NO SuccessBlock:^(NSDictionary *dic) {
        //如果有可上传的资料,则调上传资料的接口，没有课上传的话，则上传成功,返回
        if ([[weakSelf getNeedUploadFilesArray] count]>0) {
            [weakSelf uploadAllDatas];//上传资料
        }else {
            [weakSelf requestForBankCreditData];
            [weakSelf showSuccessWith:@"删除成功"];//上传成功并返回
        }
        [LSProgressHUD hide];
        [LSProgressHUD hideForView:self.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
        [LSProgressHUD hideForView:self.view];
    }];
}

#pragma mark 上传成功并返回
- (void)showSuccessWith:(NSString*)str
{
    [ZSTool showMessage:str withDuration:DefaultDuration];
}

#pragma mark 删除资料参数
- (NSMutableDictionary*)deleteIdParameter
{
    NSMutableDictionary*dict= @{
                                @"orderNo":global.wsOrderDetail.projectInfo.tid
                                }.mutableCopy;
    NSString *deleteIDStr = [self.dataCollectionView.deletdataIDArray componentsJoinedByString:@","];
    [dict setObject:deleteIDStr forKey:@"photoIds"];//删除图片id集合
    return dict;
}

#pragma mark 获取所要上传数据
- (NSMutableArray*)getNeedUploadFilesArray
{
    NSMutableArray *upArray=@[].mutableCopy;
    if ([self.dataCollectionView.itemArray count]) {
        for (NSMutableArray *array in self.dataCollectionView.itemArray ) {
            if ([array count]) {
                for (ZSWSFileCollectionModel *colletionModel in array) {
                    if (colletionModel.image) {//如果是本地拍的图片或视频.
                        [upArray addObject:colletionModel];
                    }
                }
            }
        }
    }
    return upArray;
}

#pragma mark 重置高度
- (CGFloat)resetHight
{
    CGFloat height = 0;
    if (self.isNotFeedback == NO){
        if ([global.wsCustInfo.docsDataList count] == 0){
            height = 0;
            self.dataCollectionView.hidden = YES;
        }else{
             height += [ZSTool getNumberOfLines:[global.wsCustInfo.docsDataList count]] * (itemHeight + 10) + 10;
        }
    }else{
        height += [ZSTool getNumberOfLines:[global.wsCustInfo.docsDataList count] + 1] * (itemHeight + 10) + 10;
    }
    return height;
}

#pragma mark /*-------------------------------ZSWSDataCollectionViewDelegate-------------------------------------------*/
//重置collview高度代理
- (void)refershDataCollectionViewHegiht
{
    [self.dataCollectionView layoutSubviews];
    self.dataCollectionView.frame = CGRectMake(0, self.view_else.bottom, ZSWIDTH, self.dataCollectionView.myCollectionView.height + self.view_else.bottom);
    self.bottomBtn.frame = CGRectMake(15, self.dataCollectionView.myCollectionView.bottom + 15 + self.view_else.bottom, ZSWIDTH - 30, 44);
    self.scroll_bg.contentSize = CGSizeMake(ZSWIDTH,self.bottomBtn.bottom+15);
}

//显示上传进度
- (void)showProgress:(NSString *)progressString;
{
    [self configureRightNavItemWithTitle:progressString withNormalImg:nil withHilightedImg:nil];//右侧按钮,用于显示上传进度
}

#pragma mark textView内容变化时调用 (因为在封装的view里面she代理不好使,至今拎出来在外面写)
- (void)ValueChange:(NSNotification *)obj
{
    UITextView *textView = obj.object;
    CGRect textviewRect = textView.frame;
    textviewRect.size.height = textView.contentSize.height;
    textView.frame = textviewRect;
    //征信说明
    if (textView == self.view_creditRemark.inputTextView) {
        //隐藏placeholer
        self.view_creditRemark.placeholderLabel.hidden = [@(self.view_creditRemark.inputTextView.text.length) boolValue];
        //根据输入文字的高度判断输入框的高度
        if (textviewRect.size.height > CellHeight) {
            self.view_creditRemark.height = textviewRect.size.height;
        }else{
            self.view_creditRemark.height = CellHeight;
        }
        //设置分割线的位置
        self.view_creditRemark.lineView.top = self.view_creditRemark.height-0.5;
        //解决复制粘贴的坑
        [self.view_creditRemark.inputTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    }
    //房贷
    if (textView == self.view_houseLoan.inputTextView) {
        self.view_houseLoan.placeholderLabel.hidden = [@(self.view_houseLoan.inputTextView.text.length) boolValue];
        if (textviewRect.size.height > CellHeight) {
            self.view_houseLoan.height = textviewRect.size.height;
        }else{
            self.view_houseLoan.height = CellHeight;
        }
        self.view_houseLoan.lineView.top = self.view_houseLoan.height-0.5;
        [self.view_houseLoan.inputTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    }
    //信用卡
    if (textView == self.view_VISAcard.inputTextView) {
        self.view_VISAcard.placeholderLabel.hidden = [@(self.view_VISAcard.inputTextView.text.length) boolValue];
        if (textviewRect.size.height > CellHeight) {
            self.view_VISAcard.height = textviewRect.size.height;
        }else{
            self.view_VISAcard.height = CellHeight;
        }
        self.view_VISAcard.lineView.top = self.view_VISAcard.height-0.5;
        [self.view_VISAcard.inputTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    }
    //消费贷
    if (textView == self.view_consumerLoan.inputTextView) {
        self.view_consumerLoan.placeholderLabel.hidden = [@(self.view_consumerLoan.inputTextView.text.length) boolValue];
        if (textviewRect.size.height > CellHeight) {
            self.view_consumerLoan.height = textviewRect.size.height;
        }else{
            self.view_consumerLoan.height = CellHeight;
        }
        self.view_consumerLoan.lineView.top = self.view_consumerLoan.height-0.5;
        [self.view_consumerLoan.inputTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    }
    //其他
    if (textView == self.view_else.inputTextView) {
        self.view_else.placeholderLabel.hidden = [@(self.view_else.inputTextView.text.length) boolValue];
        if (textviewRect.size.height > CellHeight) {
            self.view_else.height = textviewRect.size.height;
        }else{
            self.view_else.height = CellHeight;
        }
        self.view_else.lineView.top = self.view_else.height-0.5;
        [self.view_else.inputTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    }
    //重设其他view的frame
    [self resetViewFrame];
}

#pragma mark 重设其他view的frame
- (void)resetViewFrame
{
    self.view_creditRemark.top = self.view_credit.bottom;
    self.view_houseLoan.top = self.view_creditRemark.bottom;
    self.view_VISAcard.top = self.view_houseLoan.bottom;
    self.view_consumerLoan.top = self.view_VISAcard.bottom;
    self.view_else.top = self.view_consumerLoan.bottom;
    self.dataCollectionView.top = self.view_else.bottom;
    self.dataCollectionView.height = [self resetHight];
    self.bottomBtn.top = [self resetHight] + 15 + self.view_else.bottom;
    //重设scroll的size
    if (self.isNotFeedback) {
        self.scroll_bg.contentSize = CGSizeMake(ZSWIDTH,self.bottomBtn.bottom+25);
    }
    else{
        self.scroll_bg.contentSize = CGSizeMake(ZSWIDTH,self.dataCollectionView.bottom+15);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
