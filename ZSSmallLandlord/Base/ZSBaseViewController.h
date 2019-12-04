//
//  ZSBaseViewController.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/2.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSErrorView.h"
#import "ZSSmallLandlord-Swift.h"

@interface ZSBaseViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIView             *navLine;         //导航条分割线
@property (nonatomic,strong) UIButton           *leftBtn;         //左侧返回按钮
@property (nonatomic,strong) UIImageView        *imgView_left;    //最侧返回按钮图片
@property (nonatomic,strong) UIButton           *rightBtn;        //右侧一个按钮
@property (nonatomic,strong) UIView             *bottomView;      //底部按钮背景view
@property (nonatomic,strong) UIButton           *bottomBtn;       //底部按钮
@property (nonatomic,strong) UITableView        *tableView;       //tableView
@property (nonatomic,strong) ZSErrorView        *errorView;
//订单详情用的
@property (nonatomic,copy  ) NSString           *prdType;         //产品类型
@property (nonatomic,copy  ) NSString           *orderIDString;   //订单id
@property (nonatomic,assign) BOOL               isFromCreatOrder; //是否来自创建订单（来自创建订单，从详情返回的时候不直接返回上一层）

#pragma mark 返回手势
- (void)openInteractivePopGestureRecognizerEnable;//开启返回手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;//返回手势代理方法

#pragma mark 返回按钮
- (void)setLeftBarButtonItem;//创建返回按钮
- (void)leftAction;//返回事件

#pragma mark 右侧导航栏按钮
- (void)configureRightNavItemWithTitle:(NSString*)title withNormalImg:(NSString*)norImg withHilightedImg:(NSString*)hilightedImg;//一个
- (void)configureRightNavItemWithTitleArray:(NSArray*)titleArray withNormalImgArray:(NSArray*)norImgArray withHilightedImg:(NSArray*)hilightedImgArray;//两个
- (void)RightBtnAction:(UIButton*)sender;//右侧导航栏点击事件,需重写

#pragma mark 底部按钮
- (void)configuBottomButtonWithTitle:(NSString *)title OriginY:(CGFloat)Y;//位置不固定
- (void)configuBottomButtonWithTitle:(NSString *)title;//位置固定
- (void)configuBottomBtnsWithTitles:(NSArray *)titlesArray;//位置固定的多个按钮
- (void)setBottomBtnBackgroundColorWithWhite;//修改按钮样式(白色)
- (void)setBottomBtnBackgroundColorWithRed;//修改按钮样式(红色)
- (void)setBottomBtnEnable:(BOOL)enable;//底部按钮是否可点击
- (void)bottomClick:(UIButton *)sender;//底部按钮触发,需重写

#pragma mark 创建tableview
- (void)configureTableView:(CGRect)frame withStyle:(UITableViewStyle)style;

#pragma mark 键盘添加工具栏
- (UIToolbar *)addToolbar;
- (void)hideKeyboard;//键盘隐藏

#pragma mark 上下拉刷新
- (void)endRefresh:(UITableView *)myTableView array:(NSMutableArray *)myArray;
- (void)requestFail:(UITableView *)myTableView array:(NSMutableArray *)myArray;//收到请求失败的通知

#pragma mark 无数据
- (void)configureErrorViewWithStyle:(NSInteger)style;

#pragma mark 订单详情页tableView的高度
- (void)resetTableViewHeight;

@end
