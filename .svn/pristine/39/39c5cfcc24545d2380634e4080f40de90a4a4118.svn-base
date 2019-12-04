//
//  ZSHomeWebViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/13.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSHomeWebViewController.h"

@interface ZSHomeWebViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *mywebView;
@end

@implementation ZSHomeWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.str_title;
    [self setLeftBarButtonItem];
    if (self.str_url) {
        [self initWebView];
    }
    else
    {
        if ([APPDELEGATE.zsurlHead isEqualToString:KPreProductionUrl] ||
            [APPDELEGATE.zsurlHead isEqualToString:KPreProductionUrl_port]) {
            [self initViews:NO];
        }
        else{
            [self initViews:YES];
        }
    }
}

#pragma mark 手势代理方法
- (void)goBack
{
    self.mywebView.canGoBack ? [self.mywebView goBack]:[self.navigationController popViewControllerAnimated:YES];
}

- (void)initWebView
{
    self.mywebView  = [[UIWebView alloc]init];
    self.mywebView.delegate = self;
    self.mywebView.frame = CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-64);
    if ([self.str_url rangeOfString:@"http"].location != NSNotFound) {
    }else{
        self.str_url = [NSString stringWithFormat:@"http://%@",self.str_url];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.str_url]];
    [self.mywebView loadRequest:request];
    self.mywebView.scalesPageToFit = YES;
    self.mywebView.userInteractionEnabled = YES;
    [self.view addSubview:self.mywebView];
}

#pragma mark webviewDelegate
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [LSProgressHUD showToView:self.view message:@"数据加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webViews
{
    if (!self.str_title) {
        self.title = [self.mywebView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
    }
    [LSProgressHUD hideForView:self.view];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [LSProgressHUD hideForView:self.view];
    [ZSTool showMessage:@"加载失败" withDuration:DefaultDuration];
    NSLog(@"didFailLoadWithError,错误信息:%@", error);
}

#pragma mark 缺省页
- (void)initViews:(BOOL)isShow
{
    if (isShow) {
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake((ZSWIDTH-210)/2, (ZSHEIGHT-210-65-64)/2-50, 210, 210)];
        imgview.image = [UIImage imageNamed:@"list_in development_n"];
        [self.view addSubview:imgview];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgview.bottom, ZSWIDTH, 65)];
        label.textColor = ZSPageItemColor;
        label.text = @"程序猿正在努力研发中...";
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
    else
    {
        //随便给个缺省页
        [self configureErrorViewWithStyle:ZSErrorWithoutUploadFiles];
        self.errorView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
