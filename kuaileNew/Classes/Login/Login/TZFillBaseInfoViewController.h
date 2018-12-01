//
//  TZFillBaseInfoViewController.h
//  kuaile
//
//  Created by ttouch on 16/3/25.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import "TZResumeRootController.h"
#import <ShareSDK+InterfaceAdapter.h>

@interface TZFillBaseInfoViewController : TZBaseViewController
@property (nonatomic, assign) ShareType shareType;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, strong) id userInfo;
@property (nonatomic, copy) NSString *password;
@end
