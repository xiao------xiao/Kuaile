//
//  NSObject+Utils.m
//  cgdream
//
//  Created by ttouch on 16/6/2.
//  Copyright © 2016年 织梦网. All rights reserved.
//

#import "NSObject+Utils.h"

@implementation NSObject (Utils)

- (UIAlertView *)showAlertViewWithTitle:(NSString *)title {
    return [self showAlertViewWithTitle:title message:nil];
}

- (UIAlertView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    return alert;
}

- (UIAlertView *)showAlertViewWithMessage:(NSString *)message {
    return [self showAlertViewWithTitle:@"提示" message:message cancelBtnHandle:nil okBtnHandle:nil];
}

- (UIAlertView *)showAlertViewWithMessage:(NSString *)message okBtnHandle:(void (^)())okBtnHandle {
    return [self showAlertViewWithTitle:@"提示" message:message cancelBtnHandle:nil okBtnHandle:okBtnHandle];
}

- (UIAlertView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message okBtnHandle:(void (^)())okBtnHandle {
    return [self showAlertViewWithTitle:title message:message cancelBtnHandle:nil okBtnHandle:okBtnHandle];
}

- (UIAlertView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelBtnHandle:(void (^)())cancelBtnHandle okBtnHandle:(void (^)())okBtnHandle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *x) {
        if (x.integerValue == 0) {
            if (cancelBtnHandle) {
                cancelBtnHandle();
            }
        } else if (x.integerValue == 1) {
            if (okBtnHandle) {
                okBtnHandle();
            }
        }
    }];
    [alert show];
    return alert;
}

@end
