//
//  XYAlertView.h
//  kuaile
//
//  Created by 肖兰月 on 2017/3/30.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYAlertView;

@protocol XYAlertViewDelegate <NSObject>

- (void)xy_alertView:(XYAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface XYAlertView : UIView

+ (instancetype)xy_alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id /*<XYAlertViewDelegate>*/)delagate cancelButtonTitle:(nullable NSString *)cancelButtonTitle confirmButtonTitles:(nullable NSString *)confirmButtonTitles;



@end
