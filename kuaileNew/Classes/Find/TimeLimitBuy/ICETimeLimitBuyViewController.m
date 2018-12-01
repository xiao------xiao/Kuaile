//
//  ICETimeLimitBuyViewController.m
//  kuaile
//
//  Created by ttouch on 15/10/16.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICETimeLimitBuyViewController.h"
#import "TZToolBar.h"

@interface ICETimeLimitBuyViewController () <TZToolBarDelegate, UIScrollViewDelegate, UIWebViewDelegate>
@property (nonatomic, strong) TZToolBar *toolBar; ///< 2个选项卡
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView; ///< 大scrollView
@property (nonatomic, strong) UIWebView *leftWebView;    ///< leftWebView
@property (nonatomic, strong) UIWebView *rightWebView;   ///< rightWebView
@property (nonatomic, copy) NSString *leftWebViewURL;
@property (nonatomic, copy) NSString *rightWebViewURL;
@end

@implementation ICETimeLimitBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"限时抢兑";
    [self configToolBar];
    [self configBigScrollView];
    [self configLeftView];
    [self configRightView];
}

- (void)configToolBar {
    _toolBar = [TZToolBar toolBar];
    _toolBar.frame = CGRectMake(0, 0, __kScreenWidth, 50);
    _toolBar.delegate = self;
    [_toolBar.leftBtn setTitle:@"限时抢购" forState:UIControlStateNormal];
    [_toolBar.rightBtn setTitle:@"积分兑换" forState:UIControlStateNormal];
    [self.view addSubview:_toolBar];
}

- (void)configBigScrollView {
    self.view.backgroundColor = __kColorWithRGBA(248, 248, 248, 1.0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(__kScreenWidth*2, __kScreenHeight - 64 - 50);
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
}

/** 限时抢购 */
- (void)configLeftView {
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, __kScreenWidth,__kScreenHeight - 64 - 50);
    _leftWebView = [[UIWebView alloc] initWithFrame:leftView.bounds];
    _leftWebView.delegate = self;
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    NSString *apiURL = [ApiMoneyGoods stringByAppendingString:userModel.uid];
    self.leftWebViewURL = apiURL;
    NSURL* url = [NSURL URLWithString:apiURL];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_leftWebView loadRequest:request];//加载
    [leftView addSubview:_leftWebView];
    [self.scrollView addSubview:leftView];
}

/** 积分兑换 */
- (void)configRightView {
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(__kScreenWidth, 0, __kScreenWidth,__kScreenHeight - 64 - 50);
    rightView.backgroundColor = [UIColor yellowColor];
    _rightWebView = [[UIWebView alloc] initWithFrame:rightView.bounds];
    _rightWebView.delegate = self;
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    NSString *apiURL = [ApiIntegralGoods stringByAppendingString:userModel.uid];
    self.rightWebViewURL = apiURL;
    NSURL* url = [NSURL URLWithString:apiURL];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_rightWebView loadRequest:request];//加载
    [rightView addSubview:_rightWebView];
    [self.scrollView addSubview:rightView];
}

#pragma mark ToolBar被点击时的代理方法

- (void)toolBar:(TZToolBar *)toolBar didClickButtonWithType:(ToolBarButtonType)buttonType {
    switch (buttonType) {
        case ToolBarButtonTypeLeft: { // 左边按钮  职位信息
            [UIView animateWithDuration:0.15 animations:^{
                CGPoint point = self.scrollView.contentOffset;
                point.x = 0;
                self.scrollView.contentOffset = point;
            }]; }
            break;
        case ToolBarButtonTypeRight: { // 右边按钮  公司信息
            [UIView animateWithDuration:0.15 animations:^{
                CGPoint point = self.scrollView.contentOffset;
                point.x = __kScreenWidth;
                self.scrollView.contentOffset = point;
            }]; }
            break;
        default:
            break;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    DLog(@"%@", request.URL.absoluteString);
    if ([webView isEqual:self.leftWebView]) {
        if (![self.leftWebViewURL isEqualToString:request.URL.absoluteString]) {
            [self pushWebVcWithUrl:request.URL.absoluteString title:@"立即抢购"];
            return NO;
        }
    } else if ([webView isEqual:self.rightWebView]) {
        if (![self.rightWebViewURL isEqualToString:request.URL.absoluteString]) {
            [self pushWebVcWithUrl:request.URL.absoluteString title:@"立即兑换"];
            return NO;
        }
    }
    return YES;
}

@end
