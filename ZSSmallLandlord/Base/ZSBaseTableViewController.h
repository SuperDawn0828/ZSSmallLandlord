//
//  ZSBaseTableViewController.h
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/2.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSBaseViewController.h"

@interface ZSBaseTableViewController :ZSBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, assign) UITableViewStyle style;
@property (nonatomic, assign) BOOL canScroll;   //是否可以滑动

- (instancetype)initWithStyle:(UITableViewStyle)style;

@end
