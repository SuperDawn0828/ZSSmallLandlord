//
//  ZSBasePopView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/27.
//  Copyright © 2018 黄曼文. All rights reserved.
//  弹窗类base

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSBasePopView : UIView<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
//UI
@property (nonatomic, strong) UIView       *blackBackgroundView;
@property (nonatomic, strong) UIView       *whiteBackgroundView;
@property (nonatomic, strong) UILabel      *titleLabel;
//底部按钮
@property (nonatomic, strong) UIButton     *submitBtn;
//tableView
@property (nonatomic, strong) UITableView  *tableView;
//输入框
@property (nonatomic, strong) UIScrollView *inputBgScroll;
@property (nonatomic, strong) UITextView   *inputTextView;
@property (nonatomic, strong) UILabel      *placeholderLabel;

//UI
- (void)configureViews;
//底部按钮
- (void)configureSubmitBtn:(NSString *)titleString;
- (void)submitBtnAction;
//tableView
- (void)configureTableView:(CGRect)frame withStyle:(UITableViewStyle)style;
//输入框
- (void)configureInputViewWithFrame:(CGRect)frame withString:(NSString *)string;
- (void)hideKeyboard;
//展示和隐藏
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
