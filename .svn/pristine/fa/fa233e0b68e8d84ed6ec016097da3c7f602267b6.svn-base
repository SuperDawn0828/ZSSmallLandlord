//
//  ZSProvincesPopView.m
//  Shihanbainian
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 Codeliu. All rights reserved.
//

#import "ZSProvincesPopView.h"
#import "ZSProvinceModel.h"

#define SORT_ARRAY [[_provinceDic allKeys]sortedArrayUsingSelector:@selector(compare:)]

@interface ZSProvincesPopView ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
//UI
@property(nonatomic,strong)UIScrollView          *areaScrollView;
@property(nonatomic,strong)UIButton              *selectProvBtn;
@property(nonatomic,strong)UIButton              *selectCityBtn;
@property(nonatomic,strong)UIButton              *selectAreaBtn;
@property(nonatomic,strong)UIView                *redLineView;
//Data
@property(nonatomic,strong)NSMutableArray        *provinceArray;//省份
@property(nonatomic,strong)NSMutableArray        *cityArray;//城市
@property(nonatomic,strong)NSMutableArray        *areaArray;//区
@property(nonatomic,strong)NSMutableDictionary   *provinceDic;//省份分区字典
@property(nonatomic,strong)ZSProvinceModel       *firstProvinceModel;//湖南省
@property(nonatomic,strong)ZSProvinceModel       *selectProvinceModel;//选中的省份model
@property(nonatomic,strong)ZSProvinceModel       *selectCityModel;//选中的城市model
@property(nonatomic,strong)ZSProvinceModel       *selectAreaModel;//选中的区域model
@end

@implementation ZSProvincesPopView
{
    CGFloat selectProvBtnWidth;
    CGFloat selectCityBtnWidth;
    CGFloat selectAreaBtnWidth;
}
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizesSubviews = NO;
        //UI
        [self configureViews];
        [self creatBaseUI];
    }
    return self;
}

#pragma mark /*------------------------------------------页面------------------------------------------*/
- (void)creatBaseUI
{
    //省市区选择
    self.titleLabel.text = @"省市区选择";
    
    //选中的省市区
    self.selectProvBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectProvBtn.frame = CGRectMake(GapWidth, 30+CellHeight, 80, CellHeight);
    [self.selectProvBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [self.selectProvBtn setTitleColor:ZSColorBlack forState:UIControlStateNormal];
    self.selectProvBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.selectProvBtn addTarget:self action:@selector(areaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteBackgroundView addSubview:self.selectProvBtn];
    
    self.selectCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectCityBtn.frame = CGRectMake( self.selectProvBtn.right, 30+CellHeight, 80, CellHeight);
    [self.selectCityBtn setTitleColor:ZSColorBlack forState:UIControlStateNormal];
    self.selectCityBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.selectCityBtn addTarget:self action:@selector(areaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteBackgroundView addSubview:self.selectCityBtn];
    
    self.selectAreaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectAreaBtn.frame = CGRectMake( self.selectCityBtn.right, 30+CellHeight, 80, CellHeight);
    [self.selectAreaBtn setTitleColor:ZSColorBlack forState:UIControlStateNormal];
    self.selectAreaBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.selectAreaBtn addTarget:self action:@selector(areaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteBackgroundView addSubview:self.selectAreaBtn];
    
    //底部红线
    self.redLineView = [[UIView alloc]initWithFrame:CGRectMake(GapWidth, 30+CellHeight*2-2, 80, 2)];
    self.redLineView.backgroundColor = ZSColorRed;
    [self.whiteBackgroundView addSubview:self.redLineView];
    
    //分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 30+CellHeight*2, ZSWIDTH, 0.5)];
    lineView.backgroundColor = ZSColorLine;
    [self.whiteBackgroundView addSubview:lineView];
    
    //显示省市区列表的scrollview
    _areaScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, lineView.bottom, ZSWIDTH, self.whiteBackgroundView.height-30-CellHeight*2-SafeAreaBottomHeight)];
    _areaScrollView.delegate = self;
    _areaScrollView.contentSize = CGSizeMake(ZSWIDTH, 0);
    _areaScrollView.pagingEnabled = YES;
    _areaScrollView.showsVerticalScrollIndicator = NO;
    _areaScrollView.showsHorizontalScrollIndicator = NO;
    [self.whiteBackgroundView addSubview:_areaScrollView];
    for (int i = 0; i < 3; i++)
    {
        UITableView *area_tableView = [[UITableView alloc]initWithFrame:CGRectMake(ZSWIDTH * i, 0, ZSWIDTH, _areaScrollView.height) style:UITableViewStylePlain];
        area_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        area_tableView.delegate = self;
        area_tableView.dataSource = self;
        area_tableView.tag = 200 + i;
        [_areaScrollView addSubview:area_tableView];
    }
}

#pragma mark 点击显示省市区的按钮
- (void)areaBtnAction:(UIButton *)btn
{
    if (btn == self.selectProvBtn)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.areaScrollView.contentOffset = CGPointMake(0, 0);
            self.redLineView.frame = CGRectMake(GapWidth, 30+CellHeight*2-2, selectProvBtnWidth, 2);
        }];
    }
    else if (btn == self.selectCityBtn)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.areaScrollView.contentOffset = CGPointMake(ZSWIDTH, 0);
            self.redLineView.frame = CGRectMake(self.selectProvBtn.right, 30+CellHeight*2-2, selectCityBtnWidth, 2);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.areaScrollView.contentOffset = CGPointMake(ZSWIDTH * 2, 0);
            self.redLineView.frame = CGRectMake(self.selectCityBtn.right, 30+CellHeight*2-2, selectAreaBtnWidth, 2);
        }];
    }
}

#pragma mark /*------------------------------------------数据------------------------------------------*/
//获取省份
- (void)getProvincesList
{
    self.provinceArray = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getProvincesList] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                global.provinceModel = [ZSProvinceModel yy_modelWithDictionary:dict];
                [weakSelf.provinceArray addObject:global.provinceModel];
            }
            [weakSelf pinyinFromChiniseString];
        }
        UITableView *tableView = [weakSelf.areaScrollView viewWithTag:200];
        [tableView reloadData];
        if (weakSelf.addressID.length) {
            [weakSelf fillinData:0];
        }
    } ErrorBlock:^(NSError *error) {
    }];
}

//获取城市
- (void)getCitysList:(NSString *)proID isFillinData:(BOOL)isFillIn
{
    self.cityArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *parameterDict = @{
                                           @"provinceID":proID
                                           }.mutableCopy;
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getCitysList] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                global.provinceModel = [ZSProvinceModel yy_modelWithDictionary:dict];
                [weakSelf.cityArray addObject:global.provinceModel];
            }
        }
        UITableView *tableView = [weakSelf.areaScrollView viewWithTag:201];
        [tableView reloadData];
        weakSelf.areaScrollView.contentSize = CGSizeMake(ZSWIDTH * 2, 0);
        if (isFillIn == YES)
        {
            [weakSelf fillinData:1];
        }
        else
        {
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.areaScrollView.contentOffset = CGPointMake(ZSWIDTH, 0);
            }];
        }
    } ErrorBlock:^(NSError *error) {
    }];
}

//获取区
- (void)getAreasList:(NSString *)cityID isFillinData:(BOOL)isFillIn
{
    __weak typeof(self) weakSelf = self;
    self.areaArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *parameterDict = @{
                                           @"cityID":cityID
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getAreasList] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                global.provinceModel = [ZSProvinceModel yy_modelWithDictionary:dict];
                [weakSelf.areaArray addObject:global.provinceModel];
            }
        }
        UITableView *tableView = [weakSelf.areaScrollView viewWithTag:202];
        [tableView reloadData];
        weakSelf.areaScrollView.contentSize = CGSizeMake(ZSWIDTH * 3, 0);
        if (isFillIn == YES)
        {
            [weakSelf fillinData:2];
        }
        else
        {
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.areaScrollView.contentOffset = CGPointMake(ZSWIDTH * 2, 0);
            }];
        }
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 根据首字母排序
- (void)pinyinFromChiniseString
{
    self.provinceDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i<self.provinceArray.count; i++)
    {
        ZSProvinceModel *model = self.provinceArray[i];
        NSString *city= model.name;
        NSString *cityPinYin = [model.nameCn uppercaseString]; //转大写
        NSString *firstLetter = [cityPinYin substringWithRange:NSMakeRange(0, 1)];//截取城市拼音的第一个字母
        if (![self.provinceDic objectForKey:firstLetter]) {
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            [self.provinceDic setObject:arr forKey:firstLetter];
        }
        if ([[self.provinceDic objectForKey:firstLetter] containsObject:city]) {
            return;
        }
        [[self.provinceDic objectForKey:firstLetter]addObject:model];
    }
}

#pragma mark 数据填充
//名称
- (void)setAddressName:(NSString *)addressName
{
    if (addressName && ![addressName isEqualToString:@""] && ![addressName containsString:@"选择"])
    {
        //省市区名称
        NSArray *nameArray = [addressName componentsSeparatedByString:@" "];
        
        //省份名称赋值
        if (nameArray[0])
        {
            //UI处理
            selectProvBtnWidth = [ZSTool getStringWidth:nameArray[0] withframe:CGSizeMake((ZSWIDTH-GapWidth*4)/3, CellHeight) withSizeFont:[UIFont systemFontOfSize:15]] + GapWidth;
            [self.selectProvBtn setTitle:nameArray[0] forState:UIControlStateNormal];
            self.selectProvBtn.frame = CGRectMake(GapWidth, 30+CellHeight, selectProvBtnWidth, CellHeight);
            self.redLineView.frame = CGRectMake(GapWidth, 30+CellHeight*2-2, selectProvBtnWidth, 2);;
        }
        //城市名称赋值
        if (nameArray[1])
        {
            //UI处理
            selectCityBtnWidth = [ZSTool getStringWidth:nameArray[1] withframe:CGSizeMake((ZSWIDTH-GapWidth*4)/3, CellHeight) withSizeFont:[UIFont systemFontOfSize:15]] + GapWidth;
            [self.selectCityBtn setTitle:nameArray[1] forState:UIControlStateNormal];
            self.selectCityBtn.frame = CGRectMake(self.selectProvBtn.right, 30+CellHeight, selectCityBtnWidth, CellHeight);
        }
        //区域名称赋值
        if (nameArray[2])
        {
            selectAreaBtnWidth = [ZSTool getStringWidth:nameArray[2] withframe:CGSizeMake((ZSWIDTH-GapWidth*4)/3, CellHeight) withSizeFont:[UIFont systemFontOfSize:15]] + GapWidth;
            [self.selectAreaBtn setTitle:nameArray[2] forState:UIControlStateNormal];
            self.selectAreaBtn.frame = CGRectMake(self.selectCityBtn.right, 30+CellHeight, selectAreaBtnWidth, CellHeight);
        }
    }
}

//ID
- (void)setAddressID:(NSString *)addressID
{
    _addressID = addressID;
    
    //Data
    [self getProvincesList];
}

//列表填充
- (void)fillinData:(NSInteger)index
{
    //省市区ID
    NSArray *IDArray = [_addressID componentsSeparatedByString:@"-"];
    
    //省份列表
    if (index == 0 && IDArray[0])
    {
        //请求数据
        [self getCitysList:IDArray[0] isFillinData:YES];
        ZSProvinceModel *newModel = [self getModelWithArray:self.provinceArray withID:IDArray[0]];
        self.selectProvinceModel = newModel;
    }
    //城市列表
    if (index == 1 && IDArray[1])
    {
        //请求数据
        [self getAreasList:IDArray[1] isFillinData:YES];
        ZSProvinceModel *newModel = [self getModelWithArray:self.cityArray withID:IDArray[1]];
        self.selectCityModel = newModel;
    }
    //区域列表
    if (index == 2 && IDArray[2])
    {
        //请求数据
        ZSProvinceModel *newModel = [self getModelWithArray:self.areaArray withID:IDArray[2]];
        self.selectAreaModel = newModel;
    }
}

- (ZSProvinceModel *)getModelWithArray:(NSArray *)array withID:(NSString *)IDString
{
    ZSProvinceModel *newModel;
    for (ZSProvinceModel *model in array) {
        if ([model.ID isEqualToString:IDString]) {
            newModel = model;
        }
    }
    return newModel;
}

#pragma mark /*------------------------------------------tableview------------------------------------------*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag - 200 == 0)
    {
        return self.provinceDic.count + 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag - 200 == 0)
    {
        if (section == 0){
            return 1;
        }else{
            NSMutableArray *cityArrays = [self.provinceDic objectForKey:SORT_ARRAY[section - 1]];
            for (int i = 0; i < cityArrays.count ; i++) {
                global.provinceModel = cityArrays[i];
                if ([global.provinceModel.name isEqualToString:@"湖南省"]) {
                    [cityArrays removeObject:global.provinceModel];
                    self.firstProvinceModel = global.provinceModel;
                }
            }
            return cityArrays.count;
        }
    }
    else if (tableView.tag - 200 == 1)
    {
        return self.cityArray.count;
    }
    else
    {
        return self.areaArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"area_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"area_cell"];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGBCOLOR(255,238,238);
        cell.textLabel.highlightedTextColor = ZSColorRed;
        cell.textLabel.textColor = ZSColorBlack;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    switch (tableView.tag - 200) {
        case 0:
        {
            if (indexPath.section == 0)
            {
                //湖南省
                global.provinceModel = self.firstProvinceModel;
                cell.textLabel.text = global.provinceModel.name;
            }
            else
            {
                if (self.provinceArray.count)
                {
                    //移除湖南省
                    NSMutableArray *cityArrays =[self.provinceDic objectForKey:SORT_ARRAY[indexPath.section - 1]];
                    for (int i = 0; i < cityArrays.count ; i++) {
                        global.provinceModel = cityArrays[i];
                        if ([global.provinceModel.name isEqualToString:@"湖南省"]) {
                            [cityArrays removeObject:global.provinceModel.name];
                        }
                    }
                    global.provinceModel = cityArrays[indexPath.row];
                    cell.textLabel.text = global.provinceModel.name;
                }
            }
            //高亮设置
            if (global.provinceModel == self.selectProvinceModel) {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
            }
        }
            break;
        case 1:
        {
            if (self.provinceArray.count)
            {
                //把长沙放到最前面,娄底第二
                for (int i = 0; i < self.cityArray.count ; i++) {
                    global.provinceModel = self.cityArray[i];
                    if ([global.provinceModel.name isEqualToString:@"长沙市"]) {
                        [self.cityArray exchangeObjectAtIndex:0 withObjectAtIndex:i];
                    }
                    if ([global.provinceModel.name isEqualToString:@"娄底市"]) {
                        [self.cityArray exchangeObjectAtIndex:1 withObjectAtIndex:i];
                    }
                }
                global.provinceModel = self.cityArray[indexPath.row];
                cell.textLabel.text = global.provinceModel.name;
                //高亮设置
                if (global.provinceModel == self.selectCityModel) {
                    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
                }
            }
        }
            break;
        case 2:
        {
            if (self.provinceArray.count)
            {
                global.provinceModel = self.areaArray[indexPath.row];
                cell.textLabel.text = global.provinceModel.name;
                //高亮设置
                if (global.provinceModel == self.selectAreaModel) {
                    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
                }
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //tableview
    switch (tableView.tag - 200)
    {
        case 0:
        {
            if (indexPath.section == 0)
            {
                //湖南省
                global.provinceModel = self.firstProvinceModel;
            }
            else
            {
                //其余省份
                NSArray *cityArrays = [self.provinceDic objectForKey:SORT_ARRAY[indexPath.section-1]];
                global.provinceModel = [cityArrays objectAtIndex:indexPath.row];
            }
            self.selectProvinceModel = global.provinceModel;
            //请求数据
            [self getCitysList:global.provinceModel.ID isFillinData:NO];
            //UI处理
            selectProvBtnWidth = [ZSTool getStringWidth:global.provinceModel.name withframe:CGSizeMake((ZSWIDTH-GapWidth*4)/3, CellHeight) withSizeFont:[UIFont systemFontOfSize:15]] + GapWidth;
            [self.selectProvBtn setTitle:global.provinceModel.name forState:UIControlStateNormal];
            self.selectProvBtn.userInteractionEnabled = YES;
            self.selectCityBtn.userInteractionEnabled = YES;
            self.selectAreaBtn.userInteractionEnabled = NO;
            [self.selectCityBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [self.selectAreaBtn setTitle:@"" forState:UIControlStateNormal];
            [UIView animateWithDuration:0.25 animations:^{
                self.selectProvBtn.frame = CGRectMake(GapWidth, 30+CellHeight, selectProvBtnWidth, CellHeight);
                self.selectCityBtn.frame = CGRectMake(GapWidth + selectProvBtnWidth, 30+CellHeight, selectCityBtnWidth ? selectCityBtnWidth : 80, CellHeight);
                self.redLineView.frame = CGRectMake(GapWidth + selectProvBtnWidth, 30+CellHeight*2-2, selectCityBtnWidth ? selectCityBtnWidth : 80, 2);
            }];
        }
            break;
        case 1:
        {
            global.provinceModel = self.cityArray[indexPath.row];
            self.selectCityModel = global.provinceModel;
            //请求数据
            [self getAreasList:global.provinceModel.ID isFillinData:NO];
            //UI
            selectCityBtnWidth = [ZSTool getStringWidth:global.provinceModel.name withframe:CGSizeMake((ZSWIDTH-GapWidth*4)/3, CellHeight) withSizeFont:[UIFont systemFontOfSize:15]] + GapWidth;
            [self.selectCityBtn setTitle:global.provinceModel.name forState:UIControlStateNormal];
            self.selectAreaBtn.userInteractionEnabled = YES;
            [self.selectAreaBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [UIView animateWithDuration:0.25 animations:^{
                self.selectCityBtn.frame = CGRectMake(self.selectProvBtn.right, 30+CellHeight, selectCityBtnWidth, CellHeight);
                self.selectAreaBtn.frame = CGRectMake(GapWidth + selectProvBtnWidth + selectCityBtnWidth, 30+CellHeight, selectAreaBtnWidth ? selectAreaBtnWidth : 80, CellHeight);
                self.redLineView.frame = CGRectMake(GapWidth + selectProvBtnWidth + selectCityBtnWidth, 30+CellHeight*2-2, selectAreaBtnWidth ? selectAreaBtnWidth : 80, 2);
            }];
        }
            break;
        case 2:
        {
            global.provinceModel = self.areaArray[indexPath.row];
            self.selectAreaModel = global.provinceModel;
            //UI
            selectAreaBtnWidth = [ZSTool getStringWidth:global.provinceModel.name withframe:CGSizeMake((ZSWIDTH-GapWidth*4)/3, CellHeight) withSizeFont:[UIFont systemFontOfSize:15]] + GapWidth;
            [self.selectAreaBtn setTitle:global.provinceModel.name forState:UIControlStateNormal];
            [self.selectAreaBtn setTitleColor:ZSColorBlack forState:UIControlStateNormal];
            [UIView animateWithDuration:0.25 animations:^{
                self.selectAreaBtn.frame = CGRectMake(self.selectCityBtn.right, 30+CellHeight, selectAreaBtnWidth, CellHeight);
                self.redLineView.frame = CGRectMake(GapWidth + selectProvBtnWidth + selectCityBtnWidth, 30+CellHeight*2-2, selectAreaBtnWidth, 2);
            }];
            [self dismiss];
            //block传值
            if (self.addressArray) {
                self.addressArray(@[self.selectProvinceModel,self.selectCityModel,self.selectAreaModel]);
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (selectProvBtnWidth && selectCityBtnWidth && scrollView == _areaScrollView)
    {
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.x / ZSWIDTH == 0)
            {
                self.redLineView.frame = CGRectMake(GapWidth, 30+CellHeight*2-2, selectProvBtnWidth, 2);;
            }
            else if (scrollView.contentOffset.x / ZSWIDTH == 1)
            {
                self.redLineView.frame = CGRectMake(GapWidth + selectProvBtnWidth, 30+CellHeight*2-2, selectCityBtnWidth, 2);;
            }
            else if (scrollView.contentOffset.x / ZSWIDTH == 2)
            {
                self.redLineView.frame = CGRectMake(GapWidth + selectProvBtnWidth + selectCityBtnWidth, 30+CellHeight*2-2, selectAreaBtnWidth ? selectAreaBtnWidth : 80, 2);
            }
        }];
    }
}

@end
