//
//  ZSWSDataCollectionView.m
//  ZSMoneytocar
//
//  Created by 武 on 2017/5/19.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "ZSSLDataCollectionView.h"
#import "JWCollectionLayout.h"
#import "JWCollectionViewCell.h"
#import "JWCollectionHeaderView.h"
#import "TZImagePickerController.h"
#import "PYPhotoBrowseView.h"
#import "UIImage+add.h"
#import "UIView+Extension.h"
#import "ZSActionSheetView.h"
#import "TZImageManager.h"

#define itemWidth   (ZSWIDTH-(1+self.countOfRow)*self.spacing)/self.countOfRow
#define itemHeight  (ZSWIDTH-(1+self.countOfRow)*self.spacing)/self.countOfRow

@interface  ZSSLDataCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,JWCollectionViewCellDelegate,TZImagePickerControllerDelegate,ZSActionSheetViewDelegate>
@property (nonatomic,strong) JWCollectionLayout      *myLayout;
@property (nonatomic,strong) JWCollectionHeaderView  *headerView;//表头
@property (nonatomic,strong) NSMutableArray          *needUploadArray;//需要上传的图片数组
@end


@implementation ZSSLDataCollectionView

- (NSMutableArray *)preViewImages
{
    if (!_preViewImages) {
        _preViewImages = [[NSMutableArray alloc]init];
    }
    return _preViewImages;
}

- (NSMutableArray*)deletdataIDArray {
    if (!_deletdataIDArray) {
        _deletdataIDArray = [[NSMutableArray alloc]init];
    }
    return _deletdataIDArray;
}

- (NSMutableArray*)biztemplateItemidArray
{
    if (!_biztemplateItemidArray) {
        _biztemplateItemidArray = [[NSMutableArray alloc]init];
    }
    return _biztemplateItemidArray;
}

- (NSMutableArray*)titleNameArray
{
    if (!_titleNameArray) {
        _titleNameArray = [[NSMutableArray alloc]init];
    }
    return _titleNameArray;
}

- (NSMutableArray*)needUploadArray
{
    if (!_needUploadArray) {
        _needUploadArray = [[NSMutableArray alloc]init];
    }
    return _needUploadArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        [NOTI_CENTER addObserver:self selector:@selector(reUploadImage) name:@"reUploadImage" object:nil];//点击保存按钮, 如果有未上传成功的图片, 继续上传
        [NOTI_CENTER addObserver:self selector:@selector(setPhotoIndex) name:@"setPhotoIndex" object:nil];//上传之前给当前图片添加下标,用于照片排序
    }
    return self;
}

#pragma mark 点击保存按钮, 如果有未上传成功的图片, 继续上传
- (void)reUploadImage
{
    if (self.needUploadArray.count > 0) {
        for (ZSWSFileCollectionModel *fileModel in self.needUploadArray) {
            //图片上传获取url
            [self getProductSaleLoanByUploadFileModel:fileModel data:fileModel.imageData isFromBanker:NO];
        }
    }
}

#pragma mark 上传之前给当前图片添加下标,用于照片排序(仅针对老资料)
- (void)setPhotoIndex
{
    if (self.currentIndexPath) {
        NSMutableArray *currentArray = self.itemArray[self.currentIndexPath.section];
        NSArray *newArray = [NSArray arrayWithArray:currentArray];
        [newArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZSWSFileCollectionModel *model = newArray[idx];
            model.currentIndex = idx;
            [currentArray replaceObjectAtIndex:idx withObject:model];
        }];
    }
}

- (void)setUpView
{
    self.isShowTitle = YES;
    self.selectEnable = YES;
    self.isShowAdd = YES;
    self.spacing = 10;
    self.countOfRow = 4;
    self.isShowDelete = YES;
    self.itemArray = @[@[].mutableCopy].mutableCopy;
    self.canCut = YES;
    [self loadCollectionView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //重置collectionView高度
    [self resetCollectionViewFrame];
}

- (void)loadCollectionView
{
    _myLayout = [[JWCollectionLayout alloc]init];
    _myLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    _myLayout.minimumInteritemSpacing = self.spacing;
    _myLayout.minimumLineSpacing = self.spacing;
    
    if (self.isShowOnly) {
        _myLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, self.spacing);
    }else{
        _myLayout.sectionInset = UIEdgeInsetsMake(self.spacing, self.spacing, self.spacing, self.spacing);
    }
    
    _myLayout.sectionInset = UIEdgeInsetsMake(self.spacing, self.spacing, self.spacing, self.spacing);
    _myLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH,[self resetCollectionViewFrame]) collectionViewLayout:_myLayout];
    _myCollectionView.backgroundColor=ZSColorWhite;
    _myCollectionView.delegate=self;
    _myCollectionView.dataSource=self;
    _myCollectionView.scrollEnabled=YES;
    _myCollectionView.userInteractionEnabled = YES;
    [self addSubview:_myCollectionView];
    
    //创建底部按钮
    if (self.itemArray.count > 0) {
        [self createBottomBtn];
    }
    
    // 注册cell
    [_myCollectionView registerNib:[UINib nibWithNibName:KReuseJWCollectionViewCell bundle:nil] forCellWithReuseIdentifier:KReuseJWCollectionViewCell];
    
    //注册区头
    if (self.isShowTitle) {
        [_myCollectionView registerNib:[UINib nibWithNibName:KResuseJWCollectionHeaderViewIndentifier bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KResuseJWCollectionHeaderViewIndentifier];
    }
    
    //注册区尾巴
    if (self.isRightLabelShow) {
        [_myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    }
}

//创建底部按钮
- (void)createBottomBtn
{
    self.bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.bottomBtn setTitleColor:ZSColorWhite forState:UIControlStateNormal];
    self.bottomBtn.frame = CGRectMake(15,_myCollectionView.bottom + 15, ZSWIDTH - 30, 44);
    self.bottomBtn.titleLabel.font     = [UIFont systemFontOfSize:15];
    self.bottomBtn.layer.cornerRadius  = 22;
    self.bottomBtn.layer.masksToBounds = YES;
    self.bottomBtn.backgroundColor     = ZSColorRed;
    [self.bottomBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorRed] forState:UIControlStateNormal];
    [self.bottomBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorRedHighlighted] forState:UIControlStateHighlighted];
    self.bottomBtn.enabled = YES;
    self.bottomBtn.hidden  = YES;
    [self addSubview:_bottomBtn];
}

//底部按钮是否可点击
- (void)setBottomBtnEnable:(BOOL)enable
{
    if (enable) {
        self.bottomBtn.userInteractionEnabled = YES;
        [self.bottomBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorRed] forState:UIControlStateNormal];
    }else{
        self.bottomBtn.userInteractionEnabled = NO;
        [self.bottomBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorCanNotClick] forState:UIControlStateNormal];
    }
}

#pragma mark 区头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *ReusableView = nil;
    if ([kind isEqualToString: UICollectionElementKindSectionHeader ])
    {
        if (self.isShowTitle)
        {
            _headerView = [_myCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KResuseJWCollectionHeaderViewIndentifier forIndexPath:indexPath];
            if ([self.titleNameArray count]) {
                if (self.isRightLabelShow){
                    _headerView.imageTitleNameLab.text = @"获取时间";
                    _headerView.backgroundColor = ZSColorWhite;
                    _headerView.imageTitleNameLab.font = [UIFont systemFontOfSize:15];
                    _headerView.imageTitleNameLab.textColor = ZSColorListRight;
                    _headerView.rightLabel.font = [UIFont systemFontOfSize:15];
                    _headerView.imageTitleNameLab.textColor = ZSColorListRight;
                    if (indexPath.section < self.titleNameArray.count){
                        _headerView.rightLabel.text = self.titleNameArray[indexPath.section];
                    }
                    if (indexPath.section != 0){
                        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 10)];
                        headerView.backgroundColor = ZSViewBackgroundColor;
                        [_headerView addSubview:headerView];
                        _headerView.imageTitleNameLabelTopContraint.constant = 10;
                    }
                    
                }else{
                    _headerView.imageTitleNameLab.text=self.titleNameArray[indexPath.section];
                    _headerView.rightLabel.text = @"";
                }
            }
            ReusableView = _headerView;
        }
    }
    else
    {
        if (self.isRightLabelShow){
            UICollectionReusableView *footerrView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
            footerrView.backgroundColor = ZSColorRed;
            ReusableView = footerrView;
        }
    }
    return ReusableView;
}

#pragma mark 区头尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.isRightLabelShow){
        if (section == 0){
            return  self.isShowTitle?CGSizeMake(ZSWIDTH, CellHeight):CGSizeMake(ZSWIDTH, 0);
        }
        return  self.isShowTitle?CGSizeMake(ZSWIDTH, CellHeight + 10):CGSizeMake(ZSWIDTH, 0);
    }
    else {
        return  self.isShowTitle?CGSizeMake(ZSWIDTH, 30):CGSizeMake(ZSWIDTH, 0 );
    }
}

#pragma mark 区尾尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.itemArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.itemArray[section];
    if (self.addDataStyle == ZSAddResourceDataOne) {
        return 1;
    }
    else if (self.addDataStyle == ZSAddResourceDataTwo) {
        return 2;
    }
    else{
        return self.isShowAdd ? [array count] + 1 : [array count];
    }
}

#pragma mark cellForItem
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JWCollectionViewCell *cell = [_myCollectionView dequeueReusableCellWithReuseIdentifier:KReuseJWCollectionViewCell forIndexPath:indexPath];
    cell.delegate = self;
    cell.nameLabelHightContraint.constant = 0;
    cell.mainImageViewBottomContraint.constant = 0;
    ZSWSFileCollectionModel *fileModel = nil;
    NSMutableArray *array = self.itemArray[indexPath.section];
  
    //1.可以添加多张照片情况
    if (self.addDataStyle == ZSAddResourceDataCountless)
    {
        if (indexPath.row < array.count) {
            fileModel = self.itemArray[indexPath.section][indexPath.row];
            //预览资料
            cell.indexPath = indexPath;
            cell.fileModel = fileModel;
        }else{
            cell.deleteBtn.hidden = YES;
            cell.mainImageView.image = ImageName(@"list_add_n");
        }
    }
    //3.两个加号或者一个加号
    else
    {
        fileModel = self.itemArray[indexPath.section][indexPath.row];
        //两个加号
        if (self.addDataStyle == ZSAddResourceDataTwo){
            cell.nameLabelHightContraint.constant = 12;//底部按钮出现
            cell.mainImageViewBottomContraint.constant = 10;
            cell.nameLabel.text = indexPath.row == 0 ? @"户主页" : @"个人页";
            //不展示加号和删除的时候
            if (!self.isShowAdd) {
                //如果订单是关闭或者完成两个加号的展示问题
                if (!(fileModel.dataUrl && indexPath.row == 1)) {
                    cell.nameLabel.text = indexPath.row == 0 ? fileModel.leafCategory : @"";
                }
            }
        }
        //如果是关闭或者完成，不给加号
        if (!self.isShowAdd){
            cell.isShowAdd = NO;
        }else{
            cell.isShowAdd = YES;
        }
        cell.indexPath = indexPath;
        cell.fileModel = fileModel;
    }
  
    //没有添加功能。同时没有删除功能
    if (!self.isShowAdd) {
        cell.deleteBtn.hidden = YES;
    }
    return cell;
}

#pragma mark 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //当前有可操作权限的时候且资料获取成功才可点击，否则点击会闪退
    if (self.selectEnable && [self.titleNameArray count])
    {
        self.currentIndexPath = indexPath;
        NSMutableArray *array = self.itemArray[indexPath.section];
        //1.多张照片
        if (self.addDataStyle == ZSAddResourceDataCountless) {
            if (indexPath.row < array.count) {
                //预览大图
                [self preViewBigImages];
            }else{
                if (self.isShowAdd) {
                    //添加资料弹框
                    [self addImagePickerControllerWithDataStyle:ZSAddResourceDataCountless];
                }
            }
        }
        else
        {
            //2.一张或者两张
            ZSWSFileCollectionModel *fileModel = self.itemArray[indexPath.section][indexPath.row];
            if (fileModel.dataUrl.length || fileModel.image) {
                //预览大图
                [self preViewBigImages];
            }else{
                if (self.isShowAdd) {
                    //添加资料弹框
                    [self addImagePickerControllerWithDataStyle:ZSAddResourceDataOne];
                }
            }
        }
    }
}

- (void)addImagePickerControllerWithDataStyle:(ZSAddResourceDataStyle)dataStyle
{
    ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:@[@"拍照",@"从相册选择"]];
    actionsheet.delegate = self;
    actionsheet.sheetStyle = (ZSAddResourceDataStyle)dataStyle;
    [actionsheet show:2];
}

- (void)SheetView:(ZSActionSheetView *)sheetView btnClick:(NSInteger)tag sheetStyle:(ZSAddResourceDataStyle)sheetStyle
{
    if (tag == 0){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self takePhotoFromCamara];
        }
        else {
            ZSLOG(@"模拟器无法打开相机");
        }
    }
    else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            [self GoToPhotoLibraryWithDataStyle:(ZSAddResourceDataStyle)sheetStyle];//多选
        }
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.addDataStyle == ZSAddResourceDataTwo ? CGSizeMake(itemWidth, itemHeight+ 22):CGSizeMake(itemWidth, itemHeight);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark takePhotoFromCamara
- (void)takePhotoFromCamara
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //    picker.allowsEditing = YES;
    [[self ui_viewController] presentViewController:picker animated:YES completion:nil];
}

#pragma mark /*--------------------------------拍照-------------------------------------------*/
#pragma mark - UIImagePickerController  拍照代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [UIImage fixOrientation:info[UIImagePickerControllerOriginalImage]];//校正拍照时图片的方向
    NSData *data = UIImageJPEGRepresentation(image, [ZSTool configureRandomNumber]);
    [picker dismissViewControllerAnimated:YES completion:^{
//        //当image从相机中获取的时候存入相册中
//        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//            UIImageWriteToSavedPhotosAlbum(image,self,nil,NULL);
//        }
    }];

    //找到当前区 对应的数组
    NSMutableArray *currentArray = self.itemArray[self.currentIndexPath.section];
    //加号对应的model
    ZSWSFileCollectionModel *selectModel = [[ZSWSFileCollectionModel alloc]init];
    //文件model赋值
    ZSWSFileCollectionModel *fileModel = [self configureImageModel:image imageData:data];
    //代理传值,提示上传张数
    NSUInteger hasbeenUploadNum = [USER_DEFALT integerForKey:@"hasbeenUploadNum"];
    NSUInteger needUploadNum = [USER_DEFALT integerForKey:@"needUploadNum"];
    needUploadNum = needUploadNum + 1;
    [USER_DEFALT setInteger:needUploadNum forKey:@"needUploadNum"];
    if (_delegate && [_delegate respondsToSelector:@selector(showProgress:)]){
        [_delegate showProgress:[NSString stringWithFormat:@"已上传%ld/%ld",(long)hasbeenUploadNum,(long)needUploadNum]];
    }
    //1.银行卡信息
    if (self.bool_isFromBanker)
    {
        //新增model,用于照片回显
        [currentArray addObject:fileModel];
        //将需要上传的照片存入到数组当中,上传成功再从数组中删除
        [self.needUploadArray addObject:fileModel];
        //图片上传获取url,获取银行卡信息
        [self getProductSaleLoanByUploadFileModel:fileModel data:data isFromBanker:YES];
    }
    //2.其他资料
    else
    {
        //2.1两张
        if (self.addDataStyle == ZSAddResourceDataTwo) {
            //不是两个加号的情况 加号的model属性赋值
            selectModel = currentArray[self.currentIndexPath.row];
            //替换原有model,用于照片回显
            [currentArray replaceObjectAtIndex:self.currentIndexPath.row withObject:fileModel];
            //点击加号的时候model重新赋值
            [self setModelAttributeWithFileModel:fileModel Model:selectModel isFormAbum:NO];
        }
        //2.1多张照片
        else {
            //替换原有model,用于照片回显
            [currentArray addObject:fileModel];
            //点击加号的时候model重新赋值
            [self setModelAttributeWithFileModel:fileModel Model:selectModel isFormAbum:NO];
        }
        //将需要上传的照片存入到数组当中,上传成功再从数组中删除
        [self.needUploadArray addObject:fileModel];
        //图片上传获取url
        [self getProductSaleLoanByUploadFileModel:fileModel data:data isFromBanker:NO];
        //刷新数据
        [self reloadDataForColltionviewDelegate];
    }
}

#pragma mark /*--------------------------------相册选择-------------------------------------------*/
#pragma mark 跳转相册
- (void)GoToPhotoLibraryWithDataStyle:(ZSAddResourceDataStyle)dataStyle
{
    __weak typeof(self) weakSelf = self;
    NSInteger maxImageCount = (dataStyle == ZSAddResourceDataCountless && !self.bool_isFromBanker) ? 9 : 1;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImageCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.delegate = weakSelf;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.isSelectOriginalPhoto = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    
    //找到当前区 对应的数组
    NSMutableArray *currentArray = weakSelf.itemArray[weakSelf.currentIndexPath.section];
    
    //加号的model属性赋值
    ZSWSFileCollectionModel *selectModel;
    if (weakSelf.addDataStyle != ZSAddResourceDataCountless) {
        selectModel = currentArray[weakSelf.currentIndexPath.row];
    }else{
        selectModel = [[ZSWSFileCollectionModel alloc]init];
    }
    
    //禁止滑动
    weakSelf.myCollectionView.scrollEnabled = NO;
    
    //照片数据处理
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        //加载框,避免图片未回显成功的时候点击
        [LSProgressHUD showWithMessage:@"图片处理中"];
        
        //代理传值,提示未上传
        NSUInteger hasbeenUploadNum = [USER_DEFALT integerForKey:@"hasbeenUploadNum"];
        NSUInteger needUploadNum = [USER_DEFALT integerForKey:@"needUploadNum"];
        needUploadNum = needUploadNum + photos.count;
        [USER_DEFALT setInteger:needUploadNum forKey:@"needUploadNum"];
        if (_delegate && [_delegate respondsToSelector:@selector(showProgress:)]){
            [_delegate showProgress:[NSString stringWithFormat:@"已上传%ld/%ld",(long)hasbeenUploadNum,(long)needUploadNum]];
        }
        //异步上传
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
#pragma mark 原图
                [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    PHAsset *imageAssets = assets[idx];
                    [[TZImageManager manager]getOriginalPhotoWithAsset:imageAssets newCompletion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                        //图片文件转成data
                        NSData *data = UIImageJPEGRepresentation(photo, [ZSTool configureRandomNumber]);
                        //文件model赋值
                        ZSWSFileCollectionModel *fileModel = [weakSelf configureImageModel:photo imageData:data];
                        //5.1收款银行卡/还款银行卡两项资料
                        if (weakSelf.bool_isFromBanker)
                        {
                            //新增model,用于照片回显
                            [currentArray addObject:fileModel];
                            //将需要上传的照片存入到数组当中,上传成功再从数组中删除
                            [self.needUploadArray addObject:fileModel];
                            //图片上传获取url,获取银行卡信息
                            [weakSelf getProductSaleLoanByUploadFileModel:fileModel data:data isFromBanker:YES];
                        }
                        //5.2其余资料
                        else {
                            //6.1多张照片
                            if (weakSelf.addDataStyle == ZSAddResourceDataCountless){
                                //新增model,用于照片回显
                                [currentArray addObject:fileModel];
                                //点击加号的时候model的属性重新赋值
                                [weakSelf setModelAttributeWithFileModel:fileModel Model:selectModel isFormAbum:YES];
                            }
                            else {
                                //替换原有model,用于照片回显
                                [currentArray replaceObjectAtIndex:weakSelf.currentIndexPath.row withObject:fileModel];
                                //点击加号的时候model的属性重新赋值
                                [weakSelf setModelAttributeWithFileModel:fileModel Model:selectModel isFormAbum:YES];
                            }
                            //将需要上传的照片存入到数组当中,上传成功再从数组中删除
                            [self.needUploadArray addObject:fileModel];
                            //图片上传获取url
                            [weakSelf getProductSaleLoanByUploadFileModel:fileModel data:data isFromBanker:NO];
                        }
                        //代理方法，刷新数据
                        if (idx == assets.count-1) {
                            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                                [weakSelf reloadDataForColltionviewDelegate];
                                //隐藏加载框
                                [LSProgressHUD hide];
                            });
                        }
                    }];
                }];
            });
        });
    }];
    [[self ui_viewController] presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark /*--------------------------------上传图片接口-------------------------------------------*/
- (void)getProductSaleLoanByUploadFileModel:(ZSWSFileCollectionModel *)fileModel data:(NSData *)data isFromBanker:(BOOL)isFromBanker
{
    //递归锁实例化
    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    static void (^RecursiveMethod)(NSInteger);
    //同一线程可多次加锁，不会造成死锁
    RecursiveMethod = ^(NSInteger value){
        //一进来就要开始加锁
        [lock lock];
        //网络请求
        __weak typeof(self) weakSelf = self;
        [ZSRequestManager uploadImageWithNativeAPI:data SuccessBlock:^(NSDictionary *dic) {
            //一旦数据获取成功就要解锁 不然会造成死锁
            [lock unlock];
            
            [LSProgressHUD hide];
            //1.上传成功之后数据替换
            NSInteger indexSection = fileModel.currentSectionIndex ? fileModel.currentSectionIndex : 0;//每次点击section都会将下标存入到filemodel
            NSMutableArray *currentArray = weakSelf.itemArray[indexSection];
            NSArray *newArray = [NSArray arrayWithArray:currentArray];
            [newArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZSWSFileCollectionModel *model = newArray[idx];
                if (model.isNewImage==YES && [model.imageData isEqual:data]) {
                    model.dataUrl = dic[@"MD5"];
                    [currentArray replaceObjectAtIndex:idx withObject:model];
                }
            }];
            //2.显示上传进度
            //代理传值,提示上传张数
            NSUInteger hasbeenUploadNum = [USER_DEFALT integerForKey:@"hasbeenUploadNum"];
            hasbeenUploadNum = hasbeenUploadNum + 1;
            [USER_DEFALT setInteger:hasbeenUploadNum forKey:@"hasbeenUploadNum"];
            if (_delegate && [_delegate respondsToSelector:@selector(showProgress:)]){
                [_delegate showProgress:@""];
            }
            //3.如果是银行卡上传,识别一下
            if (isFromBanker == YES) {
                [weakSelf getBankInfoByUploadFileModel:fileModel];
            }
            //4.将需要上传的照片存入到数组当中,上传成功再从数组中删除
            NSArray *array = [NSArray arrayWithArray:weakSelf.needUploadArray];
            for (ZSWSFileCollectionModel *model in array) {
                if (model.isNewImage==YES && [model.imageData isEqual:fileModel.imageData]) {
                    [weakSelf.needUploadArray removeObject:model];
                    return;
                }
            }
        } ErrorBlock:^(NSError *error) {
            [LSProgressHUD hide];
            //条件没有达到，开始循环操作
            if(value > 0){
                RecursiveMethod(value-1);//必须-1 循环
            }
            //如果==0则循环的次数条件已经达到 可以做别的操作
            if(value == 0){
                [ZSTool showMessage:@"上传失败,请点击保存按钮重试" withDuration:DefaultDuration];
                //图片上传失败,传递标志,用于点击保存按钮的时候发送通知,重新上传照片
                if (_delegate && [_delegate respondsToSelector:@selector(judePictureUploadingFailure:)]){
                    [_delegate judePictureUploadingFailure:YES];
                }
            }
            //失败后也要解锁
            [lock unlock];
        }];
        //记得解锁
        [lock unlock];
    };
    //设置递归锁循环次数
    RecursiveMethod(1);
}

#pragma mark /*--------------------------------银行卡信息上传接口-------------------------------------------*/
#pragma mark 获取到图片上传,返回图片url和银行卡信息
- (void)getBankInfoByUploadFileModel:(ZSWSFileCollectionModel *)fileModel
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"url":fileModel.dataUrl,
                                  @"ocrType":@"bankCard",
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getOCRRecognitionURL] SuccessBlock:^(NSDictionary *dic) {
//        NSLog(@"银行卡信息图片识别成功:%@",dic);
        //1.银行卡信息传值
        BankRepay *bankModel = [BankRepay yy_modelWithJSON:dic[@"respMap"]];
        if (_delegate && [_delegate respondsToSelector:@selector(getBankerInfoWithBankerModel:)]){
            [_delegate getBankerInfoWithBankerModel:bankModel];
        }
        //2.代理方法，刷新数据
        [weakSelf reloadDataForColltionviewDelegate];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 点击加号的时候model的属性重新赋值
- (void)setModelAttributeWithFileModel:(ZSWSFileCollectionModel *)fileModel  Model:(ZSWSFileCollectionModel *)selectModel isFormAbum:(BOOL)isFormAbum
{
    fileModel.custNo              = selectModel.custNo;
    fileModel.subCategory         = selectModel.subCategory; //新房见证用于区分(户主页和个人页)星速贷区分是贷款人还是配偶
    fileModel.subType             = selectModel.subType;     //资料叶子类型,个人身份证正面、反面等
    fileModel.docType             = selectModel.docType;     //资料类型，户主页和个人页 (用于上传)
    fileModel.leafCategory        = selectModel.leafCategory; //户口本或者个人页(用于获取)
    fileModel.category            = selectModel.category;
    fileModel.isFromAbum          = selectModel.isFromAbum;
    fileModel.currentSectionIndex = self.currentIndexPath.section;
}

#pragma mark 添加视频和照片的模型
- (ZSWSFileCollectionModel*)configureImageModel:(UIImage*)image imageData:(NSData *)data
{
    ZSWSFileCollectionModel *fileModel = [[ZSWSFileCollectionModel alloc]init];
    fileModel.thumbnailUrl = [NSString stringWithFormat:@"%@?w=200",fileModel.dataUrl];//如果是图片,生成缩略图
    fileModel.docId = self.docId;
    fileModel.image = image;
    fileModel.imageData = data;
    fileModel.isNewImage = YES; //拍照和从相册选择的都是新增的图片
    return fileModel;
}

#pragma mark /*--------------------------------预览大图-------------------------------------------*/
#pragma mark 预览大图
- (void)preViewBigImages
{
    NSMutableArray *photosArray = [NSMutableArray array];
    ZSWSFileCollectionModel *currentModel = self.itemArray[self.currentIndexPath.section][self.currentIndexPath.row];//获取当前的资料对象
    JWCollectionViewCell *cell = (JWCollectionViewCell *)[_myCollectionView cellForItemAtIndexPath:self.currentIndexPath];
    //获取预览数组
    self.preViewImages = [self getPreviewImageArray];
    //找到当前对象在预览图数组中的索引
    NSInteger index = [self.preViewImages indexOfObject:currentModel];
    for (int i = 0; i < self.preViewImages.count; i++) {
        ZSWSFileCollectionModel *fileModel = self.preViewImages[i];
        //如果预览的本地图片,那么直接把本地图片赋值给相册。相反，如果预览的是线上的图片，则把url赋值给相册
        if (fileModel.image) {
            //本地的
            [photosArray addObject: fileModel.image];
        }else{
            //线上的
            [photosArray addObject:[NSString stringWithFormat:@"%@%@?p=0",APPDELEGATE.zsImageUrl,fileModel.dataUrl]];
        }
    }
    // 1. 创建photoBroseView对象
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
    photoBroseView.imagesURL = photosArray;
    photoBroseView.modelsURL = self.preViewImages;//模型数组赋值(上传人和上传时间)
    photoBroseView.showFromView = cell.mainImageView;
    photoBroseView.hiddenToView = cell.mainImageView;
    photoBroseView.currentIndex = index;
    // 3.显示(浏览)
    [photoBroseView show];
}

#pragma mark 获取预览数组
- (NSMutableArray*)getPreviewImageArray
{
    NSMutableArray *preArray = @[].mutableCopy;
    for (NSMutableArray *smallArr in self.itemArray) {
        if ([smallArr count]) {
            for (ZSWSFileCollectionModel *fileModel in smallArr) {
                //判断fileModel必有的属性是否存在
                if (fileModel.dataUrl.length > 0 || fileModel.image) {
                    [preArray addObject:fileModel];
                }
            }
        }
    }
    return preArray;
}

#pragma mark 获取所在控制器
- (UIViewController *)ui_viewController
{
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark ZSWSDataCollectionViewDelegate代理方法
- (void)reloadDataForColltionviewDelegate
{
    //刷新高度坐标
    if (_delegate && [_delegate respondsToSelector:@selector(refershDataCollectionViewHegiht)]){
        [_delegate refershDataCollectionViewHegiht];
    }
    //点击大图
    if (_delegate &&[_delegate respondsToSelector:@selector(didSelectedImage)]) {
        [_delegate didSelectedImage];
    }
    //刷新数据
    [self.myCollectionView reloadData];
}

#pragma mark 重置frame
- (CGFloat)resetCollectionViewFrame
{
    CGFloat hight = 0.0;
    if ([self.itemArray count]) {
        //一个加号的时候高度
        if (self.addDataStyle == ZSAddResourceDataOne){
            hight += self.itemArray.count * (itemHeight + 20) + 30 *self.itemArray.count ;
        }
        //两个加号的时候高度
        else if (self.addDataStyle == ZSAddResourceDataTwo){
            hight += self.itemArray.count * (itemHeight + 46) + 30 *self.itemArray.count ;
        }
        else if (self.addDataStyle == ZSAddResourceDataCountless){
            //可添加多张图片的高度
            hight = [self resetViewHightByStyleOther];
        }
    }
    //高度
    self.myCollectionView.height = hight;
    
    //底部按钮是否隐藏（针对新房见证反馈）
    if (!self.bottomBtn.hidden){
        self.bottomBtn.top = self.myCollectionView.bottom + 15;
        self.height = self.bottomBtn.bottom;
    }else{
        self.height = self.myCollectionView.height;
    }
    
    return hight;
}

#pragma mark 计算可以添加多张图片时高度
- (CGFloat)resetViewHightByStyleOther
{
    CGFloat hight = 0.0;
    for (NSArray *array in self.itemArray) {
        if (!self.isShowTitle){
            hight += [ZSTool getNumberOfLines:self.isShowAdd ? [array count] + 1 :[array count]] * (itemHeight + 10) + 10;
        }else{
            if (self.isRightLabelShow){
                if ([array count] == 0){
                    hight += 10 + 54 + self.spacing;
                    
                }else {
                    hight += ([ZSTool getNumberOfLines:self.isShowAdd ? [array count] + 1 :[array count]] * (itemHeight + 10)) + 54 + self.spacing;
                }
            }else {
                hight += [ZSTool getNumberOfLines:self.isShowAdd ? [array count] + 1 :[array count]] * (itemHeight + 10) + 30 + self.spacing;
            }
        }
    }
    if (self.isRightLabelShow){
        hight = hight - 10;
    }
    return hight;
}

#pragma mark /*-----------------------JWCollectionViewCellDelegate-----------------------*/
#pragma mark 删除资料代理
- (void)deleteDataByIndexPath:(NSIndexPath *)indexPath
{
    ZSWSFileCollectionModel *fileModel = self.itemArray[indexPath.section][indexPath.row];
    //1.不是银行卡两项资料
    if (!self.bool_isFromBanker) {
        //如果该资料是已上传的。则需要把该资料的ID放入数组中。永远调删除资料的数组
        if (!fileModel.image && !fileModel.imageData && fileModel.isNewImage == NO) {
            [self.deletdataIDArray addObject:fileModel.dataId];
        }
    }
    ZSWSFileCollectionModel *model = [[ZSWSFileCollectionModel alloc]init];
    //添加多张
    if (self.addDataStyle == ZSAddResourceDataCountless) {
        [self.itemArray[indexPath.section] removeObjectAtIndex:indexPath.row];
    }else{
        //加号按钮对应的model赋值
        [self setModelAttributeWithFileModel:model Model:fileModel isFormAbum:NO];
        [self.itemArray[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:model];
    }
    //并没有上传的照片, 进行了删除操作, 也需要从数组中删除
    if (self.needUploadArray.count > 0) {
        NSArray *array = [NSArray arrayWithArray:self.needUploadArray];
        for (ZSWSFileCollectionModel *model in array) {
            if (model.isNewImage==YES && [model.imageData isEqual:fileModel.imageData]) {
                [self.needUploadArray removeObject:model];
            }
        }
    }
    //更新cell高度
    if (_delegate && [_delegate respondsToSelector:@selector(refershDataCollectionViewHegiht)]){
        [_delegate refershDataCollectionViewHegiht];
    }
    //有删除操作,代理传值,提示上传张数
    if (_delegate && [_delegate respondsToSelector:@selector(showProgress:)]){
        [_delegate showProgress:@""];
    }
    //刷新数据
    [self.myCollectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
}

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

@end
