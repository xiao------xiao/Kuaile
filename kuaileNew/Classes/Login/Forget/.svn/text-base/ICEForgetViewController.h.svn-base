//
//  ICEForgetViewController.h
//  kuaile
//
//  Created by ttouch on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ICEForgetViewControllerTypeVerifyPhone,   /// 第三方登录时，验证手机号
    ICEForgetViewControllerTypeForgetPassword,
    ICEForgetViewControllerTypeBindPhone,
    ICEForgetViewControllerTypeUnbindPhone,
} ICEForgetViewControllerType;

@interface ICEForgetViewController : TZBaseViewController

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) ICEForgetViewControllerType typeOfVc;

@property (weak, nonatomic) IBOutlet UITextField *textFieldPhone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSmsCheck;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnSmsCode;

@property (nonatomic, copy) void (^didBindPhoneSuccessHandle)(NSString *phone);
@property (nonatomic, copy) void (^didUnbindPhoneSuccessHandle)();
@property (nonatomic, copy) void (^didVerifyPhoneSuccessHandle)(NSString *phone);

@end
