//
//  ZSWSChooseProvinceViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/13.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWSChooseProvinceViewController.h"
#import "ChineseToPinyin.h"

#define SORT_ARRAY [[_provinceDic allKeys]sortedArrayUsingSelector:@selector(compare:)]


@interface ZSWSChooseProvinceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIView            *backgroundView_black;
@property(nonatomic,strong)UITableView       *provinceTable;
@property(nonatomic,strong)UITableView       *cityTable;
@property(nonatomic,strong)UITableView       *areaTable;
@property(nonatomic,strong)NSMutableArray    *provinceArray;//省份
@property(nonatomic,strong)NSMutableArray    *cityArray;//城市
@property(nonatomic,strong)NSMutableArray    *areaArray;//区
@property(nonatomic,strong)NSMutableDictionary    *provinceDic;//省份分区字典
@property(nonatomic,strong)ZSProvinceModel   *firstProvinceModel;//湖南省
@property(nonatomic,assign)BOOL              city_cell_select;//用于防止重复点击

@end

@implementation ZSWSChooseProvinceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = @"选择省市区";
    [self setLeftBarButtonItem];//返回按钮
    [self initViews];
    //Data
    [self getProvincesList];
    self.city_cell_select = false;
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark UI
- (void)initViews
{
    self.provinceTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) style:UITableViewStylePlain];
    self.provinceTable.dataSource = self;
    self.provinceTable.delegate = self;
    self.provinceTable.sectionIndexColor = ZSColorAllNotice;
    self.provinceTable.separatorColor = ZSColorLine;
    //索引的背景颜色
    self.provinceTable.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:self.provinceTable];
    //黑底
    self.backgroundView_black = [[UIView alloc]initWithFrame:CGRectMake(-ZSWIDTH/3, 0, ZSWIDTH/3, ZSHEIGHT)];
    self.backgroundView_black.backgroundColor = ZSColorBlack;
    self.backgroundView_black.alpha = 0.5;
    [self.view insertSubview:self.backgroundView_black aboveSubview:self.provinceTable];
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    [self.backgroundView_black addGestureRecognizer:tap];
    //table--城市
    self.cityTable = [[UITableView alloc]initWithFrame:CGRectMake(ZSWIDTH, 0, ZSWIDTH/3*2, ZSHEIGHT) style:UITableViewStylePlain];
    self.cityTable.dataSource = self;
    self.cityTable.delegate = self;
    self.cityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.cityTable];
    //table--区域
    self.areaTable = [[UITableView alloc]initWithFrame:CGRectMake(ZSWIDTH, 0, ZSWIDTH/3*2, ZSHEIGHT) style:UITableViewStylePlain];
    self.areaTable.dataSource = self;
    self.areaTable.delegate = self;
    self.areaTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.areaTable];
}

- (void)showCityView
{
    [UIView animateWithDuration:0.25 animations:^
    {
        self.backgroundView_black.frame = CGRectMake(0, 0, ZSWIDTH/3, ZSHEIGHT);
        self.cityTable.frame = CGRectMake(ZSWIDTH/3, 0, ZSWIDTH/3*2, ZSHEIGHT);
    }];
}

- (void)showAreaView
{
    [UIView animateWithDuration:0.25 animations:^
    {
        self.backgroundView_black.frame = CGRectMake(0, 0, ZSWIDTH/3, ZSHEIGHT);
        self.areaTable.frame = CGRectMake(ZSWIDTH/3, 0, ZSWIDTH/3*2, ZSHEIGHT);
    }];
}

- (void)hiddenView
{
    [UIView animateWithDuration:0.25 animations:^
    {
        self.backgroundView_black.frame = CGRectMake(-ZSWIDTH/3, 0, ZSWIDTH/3, ZSHEIGHT);
        self.cityTable.frame = CGRectMake(ZSWIDTH, 0, ZSWIDTH/3*2, ZSHEIGHT);
        self.areaTable.frame = CGRectMake(ZSWIDTH, 0, ZSWIDTH/3*2, ZSHEIGHT);
    }];
}

#pragma mark dataRequest
//获取省份
- (void)getProvincesList
{
    self.provinceArray = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getProvincesList] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                global.provinceModel = [ZSProvinceModel yy_modelWithJSON:dict];
                [weakSelf.provinceArray addObject:global.provinceModel];
            }
            [weakSelf pinyinFromChiniseString];
        }
        [weakSelf.provinceTable reloadData];
    } ErrorBlock:^(NSError *error) {
    }];
}

//获取城市
- (void)getCitysList:(NSString *)proID
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
                global.provinceModel = [ZSProvinceModel yy_modelWithJSON:dict];
                [weakSelf.cityArray addObject:global.provinceModel];
            }
            [weakSelf showCityView];
        }
        [weakSelf.cityTable reloadData];
    } ErrorBlock:^(NSError *error) {
    }];
}

//获取区
- (void)getAreasList:(NSString *)cityID
{
    __weak typeof(self) weakSelf = self;
    self.areaArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *parameterDict = @{
                                           @"cityID":cityID}.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getAreasList] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                global.provinceModel = [ZSProvinceModel yy_modelWithJSON:dict];
                [weakSelf.areaArray addObject:global.provinceModel];
            }
            [weakSelf showAreaView];
        }
        [weakSelf.areaTable reloadData];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 分组标题
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.provinceTable){
        return section == 0 ?  0 : 30;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView ==self.provinceTable) {
        UIView *headerView = [[UIView alloc]init];
        headerView.backgroundColor = ZSViewBackgroundColor;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, ZSWIDTH - 15, 30)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = ZSColorAllNotice;
        titleLabel.text = section == 0 ? @"" :[NSString stringWithFormat:@"%@",SORT_ARRAY[section - 1]];
        [headerView addSubview:titleLabel];
        return headerView;
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView ==self.provinceTable) {
        return self.provinceDic.count + 1;
    }
    return 1;
}

#pragma mark 根据首字母排序
- (void)pinyinFromChiniseString{
    self.provinceDic =[[NSMutableDictionary alloc]init];
    for (int i = 0; i<self.provinceArray.count; i++) {
        ZSProvinceModel *model = self.provinceArray[i];
        NSString *city= model.name;
//        ZSLOG(@"--------%@",model.name);
//        NSString *cityPinYin = [ChineseToPinyin pinyinFromChiniseString:city];
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

#pragma mark tableview--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.provinceTable) {
        if (section == 0){
            return 1;
        }else{
            NSMutableArray *cityArrays =[self.provinceDic objectForKey:SORT_ARRAY[section - 1]];
            for (int i = 0; i < cityArrays.count ; i++) {
                global.provinceModel = cityArrays[i];
                if ([global.provinceModel.name isEqualToString:@"湖南省"]) {
                    [cityArrays removeObject:global.provinceModel];
                    self.firstProvinceModel = global.provinceModel;
                }
            }
            return cityArrays.count;
        }
    }else if (tableView == self.cityTable) {
        return self.cityArray.count;
    }else{
        return self.areaArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identify = @"identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.textLabel.textColor = ZSColorListRight;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 43.5, ZSHEIGHT-15, 0.5)];
        lineView.backgroundColor = ZSColorLine;
        [cell addSubview:lineView];
    }
    
    if (tableView == self.provinceTable) {
        if (indexPath.section == 0){
            //湖南省
            global.provinceModel = self.firstProvinceModel;
            cell.textLabel.text = global.provinceModel.name;
        }else{
            if (self.provinceArray.count) {
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
    }else if (tableView == self.cityTable) {
        if (self.provinceArray.count) {
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
        }
    }else{
        if (self.provinceArray.count) {
            global.provinceModel = self.areaArray[indexPath.row];
            cell.textLabel.text = global.provinceModel.name;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView == self.provinceTable) {
        if (indexPath.section == 0){//湖南省
            global.provinceModel = self.firstProvinceModel;
        }else{//其余省份
            NSArray *cityArrays = [self.provinceDic objectForKey:SORT_ARRAY[indexPath.section-1]];
            global.provinceModel = [cityArrays objectAtIndex:indexPath.row];
        }
        [self getCitysList:global.provinceModel.ID];
        //block传值
        if (self.provinceModel) {
            self.provinceModel(global.provinceModel);
        }
    }
    else if (tableView == self.cityTable)
    {
        if (self.city_cell_select == false) {
            self.city_cell_select = true;
            global.provinceModel = self.cityArray[indexPath.row];
            [self getAreasList:global.provinceModel.ID];
            //block传值
            if (self.cityModel) {
                self.cityModel(global.provinceModel);
            }
        }
    }
    else
    {
        global.provinceModel = self.areaArray[indexPath.row];
        [self.navigationController popViewControllerAnimated:NO];
        //block传值
        if (self.areaModel) {
            self.areaModel(global.provinceModel);
        }
    }
}

// 右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.provinceTable) {
        return SORT_ARRAY;
    }
    return @[].mutableCopy;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
