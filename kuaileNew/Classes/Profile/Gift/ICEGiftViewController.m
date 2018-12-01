//
//  ICEGiftViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICEGiftViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "ICEGiftView.h"
#import <ShareSDK+InterfaceAdapter.h>

@interface ICEGiftViewController ()
@property (nonatomic, strong, getter=getBackView)   UIView      *backView;
@property (nonatomic, strong, getter=getSheetView)  UIView      *sheetView;
@property (nonatomic, strong, getter=getGiftView)   ICEGiftView *giftView;
@end

@implementation ICEGiftViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享邀请";
    [self configGiftBtn];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.backView removeFromSuperview];
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
    
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    NSURL *shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ApiShare,userModel.uid]];
    NSString *shareContent = @"我正在使用开心工作APP，找工作，赢大奖，享服务。";
    // v3.3.0版 分享
    if (type == ShareTypeSinaWeibo) {
        shareContent = [shareContent stringByAppendingString:shareURL.absoluteString];
    }
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:shareContent
                                     images:shareImage
                                        url:shareURL
                                      title:@"[有人@你] 下载开心工作APP，开开心心找工作"
                                       type:SSDKContentTypeAuto];
    [shareParams SSDKSetupWeChatParamsByText:@"我正在使用开心工作APP，找工作，赢大奖，享服务。" title:@"[有人@你] 下载开心工作APP，开开心心找工作" url:shareURL thumbImage:shareImage image:shareImage musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
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
            RACSignal *sign = [ICEImporter shareIntegralWithParams:params];
            [sign subscribeNext:^(id x) {  } error:^(NSError *error) { }];
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

#pragma mark - life cycle

/** 将当前 View 添加到 Ctrl 的 View 上 */
-(void)addSubview {
    UIViewController *toVC = [self appRootViewController];
    if (toVC.tabBarController != nil) {
        [toVC.tabBarController.view addSubview:self.backView];
    }else if (toVC.navigationController != nil){
        [toVC.navigationController.view addSubview:self.backView];
    }else{
        [toVC.view addSubview:self.backView];
    }
}

- (UIViewController *)appRootViewController {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
#pragma mark - UICollectionView Delegate

#pragma mark - Event Response

- (IBAction)activityRuleBtnClick:(UIButton *)sender {
    NSString *url = [mUserDefaults objectForKey:@"huodongguize"];
    if (!url) {
        url = @"http://mp.weixin.qq.com/s?__biz=MzI3NjA3ODEwMA==&mid=2651619356&idx=2&sn=2f22004ec4576fc3ca85e5d3e0c03276&chksm=f0832b67c7f4a27162a79c967b74fe8392979a69bb0f44a98b2a938e87c2ffdc434e6b726c8f&scene=4#wechat_redirect";
    }
    [self pushWebVcWithUrl:url title:@"活动规则"];
}

- (IBAction)actionGift:(id)sender {
    DLog(@"立即邀请");
    [self showSheet];
    [self showPhotoActionSheet];
}

- (void)showSheet {
    [self.navigationController.view addSubview:self.backView];
    [self.backView addSubview:self.sheetView];
    [self.sheetView addSubview:self.giftView];
}

#pragma mark - Private Methods

/** 显示 */
- (void)showPhotoActionSheet {
    CGRect frame = self.sheetView.frame;
    DLog(@"%@", _sheetView);
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

@end
