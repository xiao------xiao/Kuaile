//
//  XYCreateResumeViewController.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/22.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "TZTableViewController.h"
#import "TZResumeRootController.h"

@class TZResumeModel;



typedef NS_ENUM(NSInteger, XYCreateResumeViewControllerType) {
    XYCreateResumeViewControllerTypeNormal,
    XYCreateResumeViewControllerTypeEdit,
};

@interface XYCreateResumeViewController : TZResumeRootController

@property (nonatomic, copy) NSString *resume_id;

@property (nonatomic, strong) TZResumeModel *model;

@property (nonatomic, assign) XYCreateResumeViewControllerType type;

@property (nonatomic, copy) void (^returnResumeModelBlock)(TZResumeModel *model);

@end
