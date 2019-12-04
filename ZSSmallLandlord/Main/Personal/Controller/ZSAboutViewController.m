//
//  ZSAboutViewController.m
//  ZSSmallLandlord
//
//  Created by cong on 17/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSAboutViewController.h"

@interface ZSAboutViewController ()

@end

@implementation ZSAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"关于";
    [self setLeftBarButtonItem];//返回按钮
    [self initViews];
}

- (void)initViews{
    //版本框
    UIView *whiteColorView = [[UIView alloc]initWithFrame:CGRectMake(16.5, 13, ZSWIDTH-16.5*2, ZSHEIGHT-26-64)];
    whiteColorView.backgroundColor = ZSColorWhite;
    whiteColorView.layer.cornerRadius = 10;
    whiteColorView.layer.borderColor  = ZSColorLine.CGColor;
    whiteColorView.layer.borderWidth  = 1;
    [self.view addSubview:whiteColorView];
    
    //图片
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((ZSWIDTH-90)/2, 123-64, 90, 90)];
    imgView.image = [UIImage imageNamed:@"about_logo_n"];
    [self.view addSubview:imgView];
    
    //版本
    UILabel *Version = [self LabelWithFrame:CGRectMake(0, 231-64, ZSWIDTH, 24) LabelText:[NSString stringWithFormat:@"版本号%@",[ZSTool localVersionShort]] LableColor:ZSColorListLeft];
    Version.font = [UIFont systemFontOfSize:15];
    
    //版权
    UILabel *copyright = [self LabelWithFrame:CGRectMake(0, ZSHEIGHT-35-40-64, ZSWIDTH, 20) LabelText:@"Copyright © 2018  All Rights Reserved" LableColor:ZSColor(102, 102, 102)];
    copyright.font = [UIFont systemFontOfSize:12];
    
    //公司
    UILabel *company = [self LabelWithFrame:CGRectMake(0, ZSHEIGHT-45-14-40-64, ZSWIDTH, 20) LabelText:@"湖南小房主金福网络科技有限公司    版权所有" LableColor:ZSColor(102, 102, 102)];
    company.font = [UIFont systemFontOfSize:12];
}

- (UILabel *)LabelWithFrame:(CGRect)frame LabelText:(NSString *)title LableColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc]init];
    label.frame = frame;
    label.text = title;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    return label;
}

@end
