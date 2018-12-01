//
//  TZCraeteResumeControllerNew.h
//  kuaile
//
//  Created by liujingyi on 15/10/14.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZResumeRootController.h"

typedef enum : NSUInteger {
    TZCreateResumeControllerNormal,  // 正常状态，创建简历
    TZCreateResumeControllerEdit,    // 编辑状态，编辑简历
} TZCreateResumeControllerType;

@class TZResumeModel;
typedef void(^ReturnResumeModel)(TZResumeModel *);

@class TZResumeModel;
@interface TZCraeteResumeControllerNew : TZResumeRootController
@property (nonatomic, strong) TZResumeModel *model;
@property (nonatomic, copy) ReturnResumeModel returnResumeModel;
@property (nonatomic, assign) TZCreateResumeControllerType type;
@property (nonatomic, copy) NSString *resume_id;
@end
