//
//  TZJobExpectController.h
//  kuaile
//
//  Created by liujingyi on 15/9/22.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZResumeRootController.h"

typedef enum : NSUInteger {
    TZJobExpectControllerTypeResume,  // 从简历页进来，选择职位期望
    TZJobExpectControllerTypeProfile, // 从个人主页进来，选择职位期望
} TZJobExpectControllerType;

@class TZResumeModel;
typedef void(^ReturnJobExpect)();

@interface TZJobExpectController : TZResumeRootController
@property (nonatomic, strong) ReturnJobExpect returnJobExpect;
@property (nonatomic, strong) TZResumeModel *model;
@property (nonatomic, assign) TZJobExpectControllerType type;
@end
