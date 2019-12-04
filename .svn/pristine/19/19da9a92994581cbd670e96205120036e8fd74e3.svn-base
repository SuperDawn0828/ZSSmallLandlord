//
//  ZSPCOrderPersonDetailViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/8/31.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSPCOrderPersonDetailViewController.h"
#import "ZSBaseSectionView.h"
#import "ZSWSNewLeftRightCell.h"
#import "ZSPCOrderDetailPhotoCell.h"

@interface ZSPCOrderPersonDetailViewController ()<ZSTextWithPhotosTableViewCellDelegate>
@property(nonatomic,strong)NSMutableArray<ZSOrderModel *>       *baseDataArray;
@property(nonatomic,strong)NSMutableArray<ZSDynamicDataModel *> *photoDataArray;
@end

@implementation ZSPCOrderPersonDetailViewController

- (NSMutableArray *)baseDataArray
{
    if (_baseDataArray == nil) {
        _baseDataArray = [[NSMutableArray alloc]init];
    }
    return _baseDataArray;
}

- (NSMutableArray *)photoDataArray
{
    if (_photoDataArray == nil) {
        _photoDataArray = [[NSMutableArray alloc]init];
    }
    return _photoDataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self setLeftBarButtonItem];
    self.title = [NSString stringWithFormat:@"%@信息",[ZSGlobalModel getReleationStateWithCode:global.currentCustomer.releation]];
    [self configureTable];
    //Data
    [self initData];
}

#pragma mark /*---------------------------------------数据填充---------------------------------------*/
- (void)initData
{
    CustomersModel *model = global.currentCustomer;
    
    //姓名
    ZSOrderModel *nameModel = [[ZSOrderModel alloc]init];
    nameModel.leftName = @"姓名";
    nameModel.rightData = model.name ? model.name : @"";
    [self.baseDataArray addObject:nameModel];
    
    //身份证号
    ZSOrderModel *IDCardModel = [[ZSOrderModel alloc]init];
    IDCardModel.leftName = @"身份证号";
    IDCardModel.rightData = model.identityNo ? model.identityNo : @"";
    [self.baseDataArray addObject:IDCardModel];
    
    //手机号
    ZSOrderModel *phoneModel = [[ZSOrderModel alloc]init];
    phoneModel.leftName = @"手机号";
    phoneModel.rightData = model.cellphone ? model.cellphone : @"";
    [self.baseDataArray addObject:phoneModel];
    
    //婚姻状况
    if (![self.title containsString:@"贷款人配偶信息"]) {
        ZSOrderModel *marryModel = [[ZSOrderModel alloc]init];
        marryModel.leftName = @"婚姻状况";
        marryModel.rightData = model.beMarrage ? [ZSGlobalModel getMarrayStateWithCode:model.beMarrage] : @"";
        [self.baseDataArray addObject:marryModel];
    }
    
    //身份证照片
    if (model.identityPos || model.identityBak) {
        ZSDynamicDataModel *IDCardPhotoModel = [[ZSDynamicDataModel alloc]init];
        IDCardPhotoModel.fieldMeaning = @"身份证照片";
        IDCardPhotoModel.isNecessary = @"0";
        NSString *IDCardPhotoString;
        if (model.identityPos) {
            IDCardPhotoString = [NSString stringWithFormat:@"%@",model.identityPos];
        }
        if (model.identityBak) {
            if (model.identityPos) {
                IDCardPhotoString = [NSString stringWithFormat:@"%@,%@",IDCardPhotoString,model.identityBak];
            }
            else{
                IDCardPhotoString = [NSString stringWithFormat:@"%@",model.identityBak];
            }
        }
        IDCardPhotoModel.rightData = IDCardPhotoString;
        [self.photoDataArray addObject:IDCardPhotoModel];
    }
    
    //户口本
    if (model.houseRegisterMaster || model.houseRegisterPersonal) {
        ZSDynamicDataModel *MasterModel = [[ZSDynamicDataModel alloc]init];
        MasterModel.fieldMeaning = @"户口本";
        MasterModel.isNecessary = @"0";
        NSString *MasterModelPhotoString;
        if (model.houseRegisterMaster) {
            MasterModelPhotoString = [NSString stringWithFormat:@"%@",model.houseRegisterMaster];
        }
        if (model.houseRegisterPersonal) {
            if (model.houseRegisterMaster) {
                MasterModelPhotoString = [NSString stringWithFormat:@"%@,%@",MasterModelPhotoString,model.houseRegisterPersonal];
            }
            else{
                MasterModelPhotoString = [NSString stringWithFormat:@"%@",model.houseRegisterPersonal];
            }
        }
        MasterModel.rightData = MasterModelPhotoString;
        [self.photoDataArray addObject:MasterModel];
    }
    
    //央行征信报告
    if (model.bankCredits) {
        ZSDynamicDataModel *bankCreditsModel = [[ZSDynamicDataModel alloc]init];
        bankCreditsModel.fieldMeaning = @"央行征信报告";
        bankCreditsModel.isNecessary = @"0";
        bankCreditsModel.rightData = model.bankCredits ? model.bankCredits : @"";
        [self.photoDataArray addObject:bankCreditsModel];
    }
    
    //刷新tableview
    [self.tableView reloadData];
}

#pragma mark /*---------------------------------------tableView---------------------------------------*/
- (void)configureTable
{
    [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight) withStyle:UITableViewStyleGrouped];
    self.tableView.estimatedRowHeight = CellHeight;
    [self.tableView registerNib:[UINib nibWithNibName:KReuseZSWSNewLeftRightCellIdentifier bundle:nil] forCellReuseIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
}

#pragma mark tableViewCell代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.baseDataArray.count + self.photoDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.baseDataArray.count)
    {
        return UITableViewAutomaticDimension;
    }
    else
    {
        ZSDynamicDataModel *model = self.photoDataArray[indexPath.row - self.baseDataArray.count];
        return model.rightData.length ? model.cellHeight + 10 : CellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 54)];
    view.backgroundColor = ZSViewBackgroundColor;
    ZSBaseSectionView *sectionView = [[ZSBaseSectionView alloc]initWithFrame:CGRectMake(0, 10, ZSWIDTH, CellHeight)];
    sectionView.leftLab.text = @"基本资料";
    sectionView.rightArrowImgV.hidden = YES;
    [view addSubview:sectionView];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //基本资料
    if (indexPath.row < self.baseDataArray.count)
    {
        ZSWSNewLeftRightCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
        if (!cell) {
            cell = [[ZSWSNewLeftRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
        }
        if (self.baseDataArray.count > 0) {
            cell.model = self.baseDataArray[indexPath.row];
        }
        return cell;
    }
    //照片资料
    else
    {
        ZSPCOrderDetailPhotoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ZSPCOrderDetailPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextWithPhotosCellIdentifier];
            cell.delegate = self;
        }
        //下标赋值,用于刷新高度
        cell.currentIndex = indexPath.row - self.baseDataArray.count;
        //照片赋值
        if (self.photoDataArray.count > 0) {
            ZSDynamicDataModel *model = self.photoDataArray[indexPath.row - self.baseDataArray.count];
            cell.model = model;
        }
        return cell;
    }
}

#pragma mark /*------------------------------------------ZSTextWithPhotosTableViewCellDelegate------------------------------------------*/
//当前cell的高度
- (void)sendCurrentCellHeight:(CGFloat)collectionHeight withIndex:(NSUInteger)currentIndex
{
    //保存数据
    ZSDynamicDataModel *model = self.photoDataArray[currentIndex];
    model.cellHeight = collectionHeight;
    [self.photoDataArray replaceObjectAtIndex:currentIndex withObject:model];
    //刷新当前tableView(只刷新高度)
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
