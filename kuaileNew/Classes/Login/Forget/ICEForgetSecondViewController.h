//
//  ICEForgetSecondViewController.h
//  kuaile
//
//  Created by ttouch on 15/9/15.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICEForgetSecondViewController : TZBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPwdCheck;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (nonatomic, copy) NSString *strPhone;
@property (nonatomic, copy) NSString *strSmsCode;
@property (nonatomic, copy) NSString *strSessionId;
@end
