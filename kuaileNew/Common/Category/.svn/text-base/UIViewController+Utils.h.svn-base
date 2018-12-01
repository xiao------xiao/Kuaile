//
//  UIViewController+ICENoneData.h
//  DemoProduct
//
//  Created by ttouch on 16/1/25.
//  Copyright © 2016年 iCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utils)

#pragma mark - 显示暂无数据

/// 显示无数据tipView
- (void)showNoneData:(UIView *)showView;
/// 隐藏无数据tipView
- (void)hiddenNoneData:(UIView *)hiddenView;

#pragma mark - JGProgressHUD

/// 提示请稍后...HUD
- (void)showTextHUDWithPleaseWait;
/// 提示strHUD
- (void)showTextHUDWithStr:(NSString *)text;
/// 提示操作成功
- (void)showSuccessHUDWithStr:(NSString *)text;
/// 提示操作失败
- (void)showErrorHUDWithError:(NSString *)text;
/// 隐藏HUD
- (void)hideTextHud;

#pragma mark - 纯文字的TipLable

/// 显示一个纯文字的tipLable 会自己dismiss
- (void)showInfo:(NSString *)message;
- (void)showInfoWithPleaseExpect;
- (void)showInfo:(NSString *)message vertical:(CGFloat)vertical;

/// 气泡
- (void)showPopTipView:(NSString *)info showInView:(UIView *)inView;

#pragma mark - 其他

/// 缩放图片
- (UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize) size;

/// 获取当前正在显示的ViewController
- (UIViewController *)currentViewController;
+ (UIViewController *)currentViewController;

@end

