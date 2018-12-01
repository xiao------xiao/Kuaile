//
//  UIAlertView+TZAlertView.m
//  kuaile
//
//  Created by liujingyi on 15/9/21.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "UIAlertView+TZAlertView.h"

@implementation UIAlertView (TZAlertView)

+ (UIAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)messgae delegate:(id)delegate{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:messgae delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *nameField = [alertView textFieldAtIndex:0];
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.placeholder = title;
    return alertView;
}

@end
