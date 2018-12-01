//
//  ICEEditPwdViewController.h
//  kuaile
//
//  Created by ttouch on 15/9/18.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICEEditPwdViewController : TZBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *textFieldOldPwd;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNewPwd;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCheckPwd;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end
