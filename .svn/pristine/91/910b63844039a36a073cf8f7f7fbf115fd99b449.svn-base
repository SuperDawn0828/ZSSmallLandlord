//
//  ZSToolWebViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/7/4.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSToolWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

@interface ZSToolWebViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong) WKWebView      *mywebView;
@property (nonatomic,strong) UIProgressView *progressView;
@end

@implementation ZSToolWebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启返回手势
    [self openInteractivePopGestureRecognizerEnable];
    //导航栏标题
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:ZSColorBlack}];
    //导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[ZSTool createImageWithColor:ZSColor(249, 249, 249)] forBarPosition:UIBarPositionAny  barMetrics:UIBarMetricsDefault];
    //设置状态栏字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //返回按钮
    [self setLeftBarButtonItem];
    self.imgView_left.image = [UIImage imageNamed:@"tool_guanbi_n"];
    //加载webview
    [self initWebView];
    [self JavaScriptGetOc];
}

- (void)goBack
{
    self.mywebView.canGoBack ? [self.mywebView goBack]:[self.navigationController popViewControllerAnimated:YES];
}

- (void)initWebView
{
    //进度条初始化
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, 5)];
    self.progressView.progressTintColor = ZSColorGreen;
    [self.view addSubview:self.progressView];
    
    //webview
    self.mywebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight)];
    self.mywebView.UIDelegate = self;
    self.mywebView.navigationDelegate = self;
    NSURLRequest *requese = [NSURLRequest requestWithURL:[NSURL URLWithString:self.stringUrl]];
    [self.mywebView loadRequest:requese];
    [self.view addSubview:self.mywebView];
    //监听当前网页加载的进度和title
    [self.mywebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.mywebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark JS调用OC
- (void)JavaScriptGetOc
{
    if ([self.type containsString:@"通讯录"])
    {
        JSContext *content = [self.mywebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        content[@"contactTelephone"] = ^(NSString *str) {
            if (str) {
                NSLog(@"电话号码:%@",str);
                [ZSTool callPhoneStr:str withVC:self];
            }
        };
    }
}

#pragma mark webviewDelegate
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"加载完成");
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"加载失败");
}

//在监听方法中获取网页加载的进度，并将进度赋给progressView.progress
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //进度值
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.mywebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            self.progressView.hidden = YES;
        }
    }
    //网页title
    else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.mywebView)
        {
            self.title = self.mywebView.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark 移除观察者
- (void)dealloc
{
    [self.mywebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.mywebView removeObserver:self forKeyPath:@"title"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
