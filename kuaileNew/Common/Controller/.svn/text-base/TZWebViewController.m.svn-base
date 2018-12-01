//
//  TZSystemDetailController.m
//  DemoProduct
//
//  Created by 谭真 on 16/1/21.
//  Copyright © 2016年 iCE. All rights reserved.
//

#import "TZWebViewController.h"
#import "MJPhotoBrowser.h"
//#import "WXApi.h"
//#import "ICEForgetViewController.h"
#import "XYInquireWageViewController.h"
//#import "Zyysha"

#import "ICEGiftView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK+InterfaceAdapter.h>

@interface TZWebViewController () {
    BOOL _showWebTitle;
}
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *tipLable;

@property (nonatomic, strong, getter=getGiftView) ICEGiftView *giftView;
@property (nonatomic, strong, getter=getBackView)   UIView      *backView;
@property (nonatomic, strong, getter=getSheetView)  UIView      *sheetView;
@end

@implementation TZWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.navigationItem.title.length) {
        self.navigationItem.title = @"加载中...";
        _showWebTitle = YES;
    }
    
    [self configWebView];
    [self configActivityView];
    [self initWebViewJavascriptBridge];
    [self setupLeftBarButtonItems];
    if (self.shareModel) {
        self.rightNavImageName = @"分享-8 copy";
    }
}

- (void)didClickRightNavAction {
    [self showSheet];
    [self showPhotoActionSheet];
    [self configGiftBtn];
}

#pragma mark - Getters And Setters
- (ICEGiftView *)getGiftView {
    if (_giftView == nil) {
        _giftView = [[ICEGiftView alloc] init];
        _giftView.frame = CGRectMake(0, 0, __kScreenWidth, 300);
    }
    return _giftView;
}
/** 底板SheetView*/
- (UIView *)getSheetView{
    if (_sheetView == nil) {
        CGRect frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 300);
        _sheetView = [[UIView alloc] initWithFrame:frame];
        _sheetView.backgroundColor = [UIColor lightGrayColor];
    }
    return _sheetView;
}

- (UIView *)getBackView{
    if (_backView == nil) {
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _backView = [[UIView alloc] initWithFrame:frame];
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _backView.alpha = 0;
    }
    return _backView;
}


- (void)showSheet {
    [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
    [self.backView addSubview:self.sheetView];
    [self.sheetView addSubview:self.giftView];
}
/** 显示 */
- (void)showPhotoActionSheet {
    CGRect frame = self.sheetView.frame;
    
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - 300;
    [UIView animateWithDuration:.25f animations:^{
        self.sheetView.frame = frame;
        self.backView.alpha = 1;
    } completion:^(BOOL finished) {
        DLog(@"完成");
    }];
}

/** 隐藏 */
- (void)cancelAnimation:(void (^)(void))comple {
    CGRect frame = self.sheetView.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:.25f animations:^{
        self.sheetView.frame = frame;
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        if (comple) {
            comple();
        }
        [self.backView removeFromSuperview];
    }];
}


- (void)configGiftBtn {
    [[self.getGiftView.btnQQ rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeQQ];
    }];
    [[self.getGiftView.btnWeChat rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeWeixiSession];
    }];
    [[self.getGiftView.btnSina rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeSinaWeibo];
    }];
    [[self.getGiftView.btnQzone rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeQQSpace];
    }];
    [[self.getGiftView.btnWeChatFriend rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeWeixiTimeline];
    }];
    [[self.getGiftView.btnCancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self cancelAnimation:^{
            [self.backView removeFromSuperview];
        }];
    }];
}


- (void)shareButtonClickHandler:(ShareType)type
{
    UIImage *shareImage = [UIImage imageNamed:@"Icon-40"];
    
    NSURL *shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.hap-job.com/index.php/app/sns/messageView?mid=%@",self.shareModel.mid]];
    NSString *share = [self.shareContent stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    NSString * shareContent = self.shareModel.content;
    if (shareContent.length <= 0) {
        shareContent = @"开心工作-系统消息";
    }
    // v3.3.0版 分享
    if (type == ShareTypeSinaWeibo) {
        shareContent = [shareContent stringByAppendingString:shareURL.absoluteString];
    }
    
    NSString *shareTitle = self.shareModel.title;
    if (shareTitle.length <= 0) {
        shareTitle = @"开心工作-系统消息";
    }

    if (self.shareModel.data_avatar.length > 0) {
        shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareModel.data_avatar]]];
    }
    
    if (shareImage.size.width > 200 || shareImage.size.height > 200) {
        shareImage = [CommonTools imageScale:shareImage size:CGSizeMake(200, 200)];
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:shareContent
                                     images:shareImage
                                        url:shareURL
                                      title:shareTitle
                                       type:SSDKContentTypeAuto];
    //    [shareParams SSDKSetupWeChatParamsByText:shareContent title:shareTitle url:shareURL thumbImage:shareImage image:shareImage musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    NSInteger typeInt = type;
    SSDKPlatformType shareType = typeInt;
    if (shareType == SSDKPlatformTypeSinaWeibo) {
        [self cancelAnimation:^{
            [self.backView removeFromSuperview];
        }];
        BOOL ret = [ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo];
        if (ret) {
            [[UIViewController currentViewController] showTextHUDWithStr:@"分享中..."];
        }
    }
    [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            [[UIViewController currentViewController] showSuccessHUDWithStr:@"分享成功"];
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"uid": userModel.uid }];
            [ICEImporter shareIntegralWithParams:params];
        } else if (state == SSDKResponseStateFail) {
            NSLog(@"分享失败! %@",error);
            [[UIViewController currentViewController] showErrorHUDWithError:@"分享失败"];
        } else if (state == SSDKResponseStateCancel) {
            NSLog(@"取消分享 %@",userData);
        }
        [[UIViewController currentViewController] hideTextHud];
        [self cancelAnimation:^{
            [self.backView removeFromSuperview];
        }];
    }];
}

- (void)configWebView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, __kScreenWidth, __kScreenHeight - 64)];
    if (_url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
        [_webView loadRequest:request];
    } else if (_filename) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:self.filename ofType:nil];
        NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    }else if (_htmlString) {
        
        UIFont *font = [UIFont systemFontOfSize:12];
        NSString * htmlStr = [NSString stringWithFormat:@"<html> \n"
                 "<head> \n"
                 "<style type=\"text/css\"> \n"
                 "body {font-size:15px;}\n"
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
                 "</html>",_htmlString];;
        
        [self.webView loadHTMLString:htmlStr baseURL:nil];

    }
    
    
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupLeftBarButtonItems];
    });
}

- (void)setupLeftBarButtonItems {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"message_close"] style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    if ([_webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[backItem,closeItem];
    } else {
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

- (void)configActivityView {
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.frame = CGRectMake(mScreenWidth / 2 - 15 - 40, mScreenHeight / 2 - 20 - 64, 40, 40);
    [self.view addSubview:_activityView];
    
    _tipLable  = [[UILabel alloc] init];
    _tipLable.frame = CGRectMake(mScreenWidth / 2 - 15, mScreenHeight / 2 - 20 - 64, 70, 40);
    _tipLable.text = @"加载中...";
    _tipLable.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_tipLable];
}

- (void)initWebViewJavascriptBridge {
    if (_bridge) { return; }
    [WebViewJavascriptBridge enableLogging];
    // 0.建桥接
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//        DLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    // 1.预览大图
    [_bridge registerHandler:@"showImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSArray *imgs = data[@"imgs"];
        NSMutableArray *items = [NSMutableArray new];
        for (NSUInteger i = 0 ; i < imgs.count ; i++) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:imgs[i]];
            [items addObject:photo];
        }
        MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
        photoBrowser.photos = items;
        photoBrowser.currentPhotoIndex = [data[@"index"] integerValue];
        // [photoBrowser showWithContentView:self.navigationController.view];
    }];
    // 2.先去验证手机号
    [_bridge registerHandler:@"validatePhone" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self shouldPushBindPhoneVc];
    }];
}

#pragma mark - 点击事件

- (void)shareBtnClick {
//     [[ZYYShareManager manager] shareWithTitle:self.navigationItem.title content:self.navigationItem.title url:self.link_url imageUrl:self.imageUrlStr];
}

- (void)back {
    
    if ([self.shareTitle isEqualToString:@"抽奖活动"]) {
        
        [mNotificationCenter postNotificationName:@"pointDidUpdate" object:nil];
        [mNotificationCenter postNotificationName:@"didEditUserInfoNoti" object:nil];

        
    }
    
    if (_webView.canGoBack) {
        [_webView goBack];
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)close {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_activityView startAnimating];
    _tipLable.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"网页加载失败");
    [_activityView stopAnimating];
    _tipLable.hidden = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self webViewDidFinishLoad];
}

- (void)webViewDidFinishLoad {
    [_activityView stopAnimating];
    _tipLable.hidden = YES;
    if (_showWebTitle) {
        self.navigationItem.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    if (self.isMsgHtml) {
        [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '270%'"];
    }
    
    [self setupLeftBarButtonItems];
}


#pragma mark - 私有方法

/// 检测是否需要去绑定手机号
- (BOOL)shouldPushBindPhoneVc {
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    NSString *phone = DEF_PERSISTENT_GET_OBJECT(DEF_USERNAME);
    if ([userModel.is_bind isEqualToString:@"2"]) {
        // 没有绑定手机号
//        ICEForgetViewController *iCEForget = [[ICEForgetViewController alloc] init];
//        iCEForget.uid = userModel.uid;
//        iCEForget.navigationItem.title = @"绑定手机号";
//        iCEForget.typeOfVc = ICEForgetViewControllerTypeBindPhone;
//        [self.navigationController pushViewController:iCEForget animated:YES];
        
        XYInquireWageViewController *bindVc = [[XYInquireWageViewController alloc] init];
        bindVc.titleText = @"绑定手机号";
        bindVc.commitBtnText = @"绑定手机号";
        [self.navigationController pushViewController:bindVc animated:YES];
        
        return YES;
    }
    return NO;
}

@end
