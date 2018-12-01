//
//  UIViewController+ICENoneData.m
//  DemoProduct
//
//  Created by ttouch on 16/1/25.
//  Copyright © 2016年 iCE. All rights reserved.
//

#import "UIViewController+Utils.h"
#import "JGProgressHUD.h"
#import "SGInfoAlert.h"

@implementation UIViewController (Utils)

#pragma mark - 显示暂无数据

/// 显示无数据tipView
- (void)showNoneData:(UIView *)showView {
    [self hiddenNoneData:showView];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.tag = 1234;
    imgView.frame = CGRectMake(showView.width / 2 - 80, showView.height / 2 - 80, 160, 160);
    imgView.contentMode = UIViewContentModeCenter;
    imgView.image = [UIImage imageNamed:@"nodata"];
    [showView addSubview:imgView];
    [showView insertSubview:imgView atIndex:99];
}

/// 隐藏无数据tipView
- (void)hiddenNoneData:(UIView *)hiddenView {
    if ([hiddenView viewWithTag:1234]) {
        [[hiddenView viewWithTag:1234] removeFromSuperview];
    }
}

#pragma mark - JGProgressHUD

/// 提示请稍后...HUD
- (void)showTextHUDWithPleaseWait {
    [self showTextHUDWithStr:@"请稍后..."];
}

/// 提示strHUD
- (void)showTextHUDWithStr:(NSString *)text {
    [self hideTextHud];
    
    JGProgressHUD *HUD = [self getJGProgressHUD];
    HUD.textLabel.text = text;
    HUD.userInteractionEnabled = YES;
    HUD.position = JGProgressHUDPositionCenter;
    HUD.marginInsets = (UIEdgeInsets) {
        .top = 0.0f,
        .bottom = 20.0f,
        .left = 10.0f,
        .right = 10.0f,
    };
    HUD.tag = 1111;
    [HUD showInView:self.view];
}

/// 提示操作成功
- (void)showSuccessHUDWithStr:(NSString *)text {
    [self hideTextHud];
    
    JGProgressHUD *HUD = [self getJGProgressHUD];
    HUD.textLabel.text = text;
    HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    HUD.square = YES;
    [HUD showInView:self.navigationController.view];
    [HUD dismissAfterDelay:1.5];
}

/// 提示操作失败
- (void)showErrorHUDWithError:(NSString *)text {
    [self hideTextHud];
    
    JGProgressHUD *HUD = [self getJGProgressHUD];
    HUD.textLabel.text = text;
    HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    HUD.square = YES;
    [HUD showInView:self.navigationController.view];
    [HUD dismissAfterDelay:1.5];
}

/// 隐藏HUD
- (void)hideTextHud {
    [self hideHud];
    
    UIView *HUD = [self.navigationController.view viewWithTag:1111];
    [HUD removeFromSuperview];
}

- (JGProgressHUD *)getJGProgressHUD {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    HUD.animation = [JGProgressHUDFadeZoomAnimation animation];
    HUD.userInteractionEnabled = NO;
    return HUD;
}

#pragma mark - 纯文字的HUD

/// 显示一个纯文字的tipLable
- (void)showInfo:(NSString *)message {
    [self showInfo:message vertical:0.5];
}

- (void)showInfoWithPleaseExpect {
    [self showInfo:@"即将开通，敬请期待" vertical:0.5];
}

- (void)showInfo:(NSString *)message vertical:(CGFloat)vertical {
    [self hideTextHud];
    [SGInfoAlert showInfo:message bgColor:[[UIColor darkGrayColor] CGColor] fgColor:[[UIColor whiteColor] CGColor] inView:[UIApplication sharedApplication].keyWindow vertical:vertical];
}

// 气泡
- (void)showPopTipView:(NSString *)info  showInView:(UIView *)inView {
    CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:info];
    //popTipView.delegate = self;
    
    //    popTipView.disableTapToDismiss = YES;
    popTipView.preferredPointDirection = PointDirectionAny;
    popTipView.hasGradientBackground = NO;
    //    popTipView.cornerRadius = 2.0;
    //    popTipView.sidePadding = 30.0f;
    //    popTipView.topMargin = 20.0f;
    //    popTipView.pointerSize = 50.0f;
    popTipView.hasShadow = NO;
    //    popTipView.has3DStyle = (BOOL)(arc4random() % 2);
    popTipView.backgroundColor = kCOLOR_MAIN;
    popTipView.animation = arc4random() % 2;
    popTipView.has3DStyle = NO;
    popTipView.borderWidth = 0;
    
    popTipView.dismissTapAnywhere = YES;
    [popTipView autoDismissAnimated:YES atTimeInterval:1.5];
    
    [popTipView presentPointingAtView:inView inView:self.view animated:YES];
}

#pragma mark - 其他

/// 缩放图片
- (UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/// 获取当前正在显示的ViewController
+ (UIViewController *)currentViewController {
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [rootVc findBestViewController:rootVc];
}

/// 获取当前正在显示的ViewController
- (UIViewController *)currentViewController {
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:rootVc];
}

- (UIViewController *)findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *)vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *)vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *)vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

@end
