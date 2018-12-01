//
//  XYAlertView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/30.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYAlertView.h"

@implementation XYAlertView


+ (instancetype)xy_alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delagate cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitles:(NSString *)confirmButtonTitles {
    
    XYAlertView *alertView = [[XYAlertView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = TZColorRGB(80);
    titleLabel.font = [UIFont systemFontOfSize:16];
    [alertView addSubview:titleLabel];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = message;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = TZColorRGB(160);
    messageLabel.font = [UIFont systemFontOfSize:15];
    [alertView addSubview:messageLabel];
    
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    
    
    return alertView;
}







@end
