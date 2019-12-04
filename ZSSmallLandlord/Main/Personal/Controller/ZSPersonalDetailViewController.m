//
//  ZSPersonalDetailViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/7/13.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSPersonalDetailViewController.h"
#import "ZSPersonalDetailCell.h"
#import "ZSWSYearMonthDayPicker.h"
#import "ZSChangePhoneViewController.h"
#import "ZSChangeUserIDViewController.h"

#pragma mark 传递类型
typedef NS_ENUM(NSUInteger, updateType) {
    headPhoto = 0,   //头像
    userid,          //用户名
    birthday,        //生日
    sex,             //性别
    beNotice,        //短信通知
};

@interface ZSPersonalDetailViewController ()<ZSActionSheetViewDelegate,ZSAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)NSMutableArray *personInfoArray;     //人员基本资料
@property(nonatomic,strong)NSMutableArray *rightPersonInfoArray;//右边人员基本资料
@end

@implementation ZSPersonalDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //Data
    [self getUserInfo];
    //开启返回手势(自定义返回按钮会导致手势失效)
    [self openInteractivePopGestureRecognizerEnable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = @"个人信息";
    self.tableView.frame = CGRectMake(0, -10, ZSWIDTH, ZSHEIGHT);
    self.tableView.scrollEnabled = NO;
    [self setLeftBarButtonItem];//返回按钮
}

#pragma mark 获取个人信息
- (void)getUserInfo
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@"加载中..."];
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getUserInformation] SuccessBlock:^(NSDictionary *dic) {
        //保存个人信息
        NSDictionary *newdic = dic[@"respData"];
        [ZSTool saveUserInfoWithDic:newdic];
        //Data
        [weakSelf fillInData];
        [weakSelf.tableView reloadData];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 数据填充
- (void)fillInData
{
    ZSUidInfo *userInfo = [ZSTool readUserInfo];
    self.personInfoArray = @[@"头像",@"用户名",@"姓名",@"手机号",@"性别",@"生日",@"角色",@"所属部门"].mutableCopy;
    self.rightPersonInfoArray = [[NSMutableArray alloc]init];
    //头像
    if (userInfo.headPhoto.length) {
        [self.rightPersonInfoArray addObject:userInfo.headPhoto];
    }else{
        [self.rightPersonInfoArray addObject:@""];
    }
    //用户名
    if (userInfo.userid.length) {
        [self.rightPersonInfoArray addObject:userInfo.userid];
    }else{
        [self.rightPersonInfoArray addObject:@""];
    }
    //姓名
    if (userInfo.username.length) {
        [self.rightPersonInfoArray addObject:userInfo.username];
    }else{
        [self.rightPersonInfoArray addObject:@""];
    }
    //手机号
    if (userInfo.telphone.length) {
        [self.rightPersonInfoArray addObject:userInfo.telphone];
    }else{
        [self.rightPersonInfoArray addObject:@"未绑定"];
    }
    //性别
    if (userInfo.sex) {
        NSString *sex = userInfo.sex.intValue==1 ? @"男" : @"女";
        [self.rightPersonInfoArray addObject:sex];
    }else{
        [self.rightPersonInfoArray addObject:@""];
    }
    //生日
    if (userInfo.birthday.length) {
        [self.rightPersonInfoArray addObject:userInfo.birthday];
    }else{
        [self.rightPersonInfoArray addObject:@""];
    }
    //角色
    if (userInfo.roleName.length) {
        [self.rightPersonInfoArray addObject:userInfo.roleName];
    }else{
        [self.rightPersonInfoArray addObject:@""];
    }
    //所属部门
    if (userInfo.orgnizationName.length) {
        [self.rightPersonInfoArray addObject:userInfo.orgnizationName];
    }else{
        [self.rightPersonInfoArray addObject:@""];
    }
}

#pragma mark tableview--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    }else{
        return CellHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.personInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ZSPersonalDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identify"];
    if (cell == nil) {
        cell = [[ZSPersonalDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
        cell.leftImage.hidden = YES;
        cell.leftLabel.left = 15;
        cell.rightLabel.hidden = YES;
    }
    //左侧
    cell.leftLabel.text = self.personInfoArray[indexPath.row];
    //右侧
    if (indexPath.row == 0) {
        cell.leftLabel.top = (70-CellHeight)/2;
        cell.pushImage.top = (70-15)/2;
        UIImageView *HeadPortraitImage = [[UIImageView alloc]initWithFrame:CGRectMake(ZSWIDTH-40-35, 10, 40, 40)];
        HeadPortraitImage.backgroundColor = ZSColorListLeft;
        HeadPortraitImage.layer.cornerRadius = 20;
        HeadPortraitImage.layer.masksToBounds = YES;
        HeadPortraitImage.contentMode = UIViewContentModeScaleAspectFill;
        [cell addSubview:HeadPortraitImage];
        [HeadPortraitImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.rightPersonInfoArray.firstObject]] placeholderImage:[UIImage imageNamed:@"my_head_portrait_n"]];
    }
    else{
        cell.rightLabel.hidden = NO;
        cell.rightLabel.text = self.rightPersonInfoArray[indexPath.row];
    }
    
    cell.rightLabel.text = self.rightPersonInfoArray[indexPath.row];
    if (indexPath.row == 2 || indexPath.row == 6 || indexPath.row == 7) {
        cell.pushImage.hidden = YES;
        cell.rightLabel.right = ZSWIDTH-15;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0://修改头像
        {
            ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:@[@"拍照",@"从相册选择",@"恢复默认头像"]];
            actionsheet.delegate = self;
            actionsheet.tag = 0;
            [actionsheet show:3];
        }
            break;
        case 1://修改用户名
        {
            ZSChangeUserIDViewController *changeUseridVC = [[ZSChangeUserIDViewController alloc]init];
            [self.navigationController pushViewController:changeUseridVC animated:YES];
        }
            break;
        case 3://绑定或修改手机号
        {
            ZSChangePhoneViewController *ChangephoneVC = [[ZSChangePhoneViewController alloc]init];
            [self.navigationController pushViewController:ChangephoneVC animated:YES];
            if ([self.rightPersonInfoArray[3] isEqualToString:@"未绑定"]) {
                ChangephoneVC.isChange = NO;
            }else{
                ChangephoneVC.isChange = YES;
            }
        }
            break;
        case 4://性别
        {
            ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:@[@"男",@"女"]];
            actionsheet.delegate = self;
            actionsheet.tag = 4;
            [actionsheet show:2];
        }
            break;
        case 5://生日
        {
            ZSWSYearMonthDayPicker *datePicker = [[ZSWSYearMonthDayPicker alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 250)];
            datePicker.datePickerBlock = ^(NSString *selectDate) {
                [self updateUserInformationWithType:birthday updateContent:selectDate];
            };
            [self.view addSubview:datePicker];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ZSInputOrSelectViewDelegate
- (void)SheetView:(ZSActionSheetView *)sheetView btnClick:(NSInteger)tag
{
    if (sheetView.tag == 0) {//头像
        if (tag == 0) {
            [self camera];
        }
        if (tag == 1) {
            [self imagePicker];
        }
        if (tag == 2) {
            UIImage *image = [UIImage imageNamed:@"my_head_portrait_n"];
            NSData *data = UIImageJPEGRepresentation(image, [ZSTool configureRandomNumber]);
            [self uploadHeadImage:data];
        }
    }
    
    if (sheetView.tag == 4) {//性别
        if (tag == 0) {
            [self updateUserInformationWithType:sex updateContent:@"1"];
        }
        if (tag == 1) {
            [self updateUserInformationWithType:sex updateContent:@"2"];
        }
        [self.tableView reloadData];
    }
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
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)AlertView:(ZSAlertView *)alert;//确认按钮响应的方法
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

#pragma mark 从手机相册选择
- (void)imagePicker
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *Photoimage  = info[UIImagePickerControllerEditedImage];
    if (Photoimage != nil) {
        NSData *data = UIImageJPEGRepresentation(Photoimage, [ZSTool configureRandomNumber]);
//        NSData *data_png = UIImagePNGRepresentation(Photoimage);
        //看一下图片的大小(PNG的大了500KB,jpeg小了500KB)
        NSInteger length = data.length/1024;
//        NSLog(@"大小:%ld",(long)length);
        if (length+500 > 2048) {
            [ZSTool showMessage:@"图片太大了" withDuration:DefaultDuration];
        }
        else{
            [self uploadHeadImage:data];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 上传头像
- (void)uploadHeadImage:(NSData *)data
{
    //上传图片,获取url
    [LSProgressHUD showToView:self.view message:@""];
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager uploadImagesAndVideosWithParameters:nil url:[ZSURLManager getDataUpload] Data:data isVideo:NO SuccessBlock:^(NSDictionary *dic)
     {
         NSLog(@"图片上传成功:%@",dic);
         [self updateUserInformationWithType:headPhoto updateContent:dic[@"respData"]];
         [LSProgressHUD hideForView:weakSelf.view];
     } ErrorBlock:^(NSError *error) {
         [LSProgressHUD hideForView:weakSelf.view];
     }];
}

#pragma mark 修改个人资料
- (void)updateUserInformationWithType:(updateType)type updateContent:(NSString *)updateContent;
{
    [LSProgressHUD showToView:self.view message:@""];
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:[self getCreateUserParamterWithType:type updateContent:updateContent] url:[ZSURLManager updateUserInformation] SuccessBlock:^(NSDictionary *dic){
        ZSLOG(@"修改资料成功:%@",dic);
        //保存个人信息
        NSDictionary *newdic = dic[@"respData"];
        [ZSTool saveUserInfoWithDic:newdic];
        //刷新数据
        [weakSelf fillInData];
        [weakSelf.tableView reloadData];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 创建订单请求的参数
- (NSMutableDictionary *)getCreateUserParamterWithType:(updateType)type updateContent:(NSString *)updateContent
{
    NSMutableDictionary *parameter = @{@"tid":[ZSTool readUserInfo].tid}.mutableCopy;
    if (type == headPhoto) {
        [parameter setObject:updateContent forKey:@"headPhoto"];
    }
    if (type == userid) {
        [parameter setObject:updateContent forKey:@"userid"];
    }
    if (type == birthday) {
        [parameter setObject:updateContent forKey:@"birthday"];
    }
    if (type == sex) {
        [parameter setObject:updateContent forKey:@"sex"];
    }
    return parameter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
