//
//  ZSHousInfoDetailViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/6/4.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSHousInfoDetailViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

#define leftSpacing  15
#define webViewWidth ZSWIDTH-leftSpacing*2

@interface ZSHousInfoDetailViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong) WKWebView      *mywebView;
@property (nonatomic,strong) UIProgressView *progressView;
@end

@implementation ZSHousInfoDetailViewController

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
    //UI
    self.title = @"资讯详情";
    self.view.backgroundColor = ZSColorWhite;
    [self setLeftBarButtonItem];
    self.imgView_left.image = [UIImage imageNamed:@"tool_guanbi_n"];
    [self initWebView];
}

- (void)initWebView
{
    //进度条初始化
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, 5)];
    self.progressView.progressTintColor = ZSColorGreen;
    [self.view addSubview:self.progressView];
    
    //webview
    self.mywebView = [[WKWebView alloc]initWithFrame:CGRectMake(leftSpacing, 0, webViewWidth, ZSHEIGHT + 50)];
    self.mywebView.UIDelegate = self;
    self.mywebView.navigationDelegate = self;
    self.mywebView.scrollView.scrollEnabled = YES;
    self.mywebView.backgroundColor = ZSColorWhite;
    self.mywebView.scrollView.backgroundColor = ZSColorWhite;
    self.mywebView.scrollView.showsVerticalScrollIndicator = NO;
    //修复图片和文字失调的问题
    NSString *htmlstr = [NSString stringWithFormat:@"<html> \n"
                         "<head> \n"
                         "<style type=\"text/css\"> \n"
                         "body {font-size:45px;}\n"
                         "</style> \n"
                         "</head> \n"
                         "<body>"
                         "<script type='text/javascript'>"
                         "window.onload = function(){\n"
                         "var $img = document.getElementsByTagName('img');\n"
                         "for(var p in  $img){\n"
                         " $img[p].style.width = '100%%';\n"
                         "$img[p].style.height ='auto'\n"
                         "}\n"
                         "}"
                         "</script>%@"
                         "</body>"
                         "</html>",self.model.content];
    [self.mywebView loadHTMLString:htmlstr baseURL:nil];
    [self.view addSubview:self.mywebView];
    
    //监听当前网页加载的进度和title
    [self.mywebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.mywebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    //----------------------------------------------帖子上面的内容----------------------------------------------
    //1.先计算标题高度
    CGFloat titleHeight = [ZSTool getStringHeight:self.model.title withframe:CGSizeMake(webViewWidth, 500) withSizeFont:[UIFont systemFontOfSize:22]];
    CGFloat topViewHeight = 10 + titleHeight + 10 + 20 + 45;
    
    //2.设置额外滚动大小
    self.mywebView.scrollView.contentInset = UIEdgeInsetsMake(topViewHeight, 0, topViewHeight, 0);
    UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, -topViewHeight, webViewWidth, topViewHeight)];
    [self.mywebView.scrollView addSubview:topBgView];
    
    //帖子标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, webViewWidth, titleHeight)];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = ZSColorBlack;
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = [ZSTool setTextString:[NSString stringWithFormat:@"%@",self.model.title] withSizeFont:[UIFont systemFontOfSize:22]];
    [topBgView addSubview:titleLabel];
    
    //帖子来源 + /帖子时间
    UILabel *sourceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.bottom + 15, webViewWidth, 20)];
    sourceLabel.font = [UIFont systemFontOfSize:14];
    sourceLabel.textColor = ZSColorListLeft;
    sourceLabel.text = [NSString stringWithFormat:@"%@  %@",self.model.source,self.model.pubTime];
    [topBgView addSubview:sourceLabel];
}

#pragma mark webviewDelegate
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
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
//    NSLog(@"加载完成");
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
//    NSLog(@"加载失败");
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
