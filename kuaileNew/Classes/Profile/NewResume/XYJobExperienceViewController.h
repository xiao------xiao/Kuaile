//
//  XYJobExperienceViewController.h
//  kuaile
//
//  Created by 肖兰月 on 2017/3/2.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "TZTableViewController.h"

typedef NS_ENUM(NSInteger, XYJobExperienceViewControllerType) {
    XYJobExperienceViewControllerTypeNormal,
    XYJobExperienceViewControllerTypeEdit,
};

@interface XYJobExperienceViewController : TZTableViewController

@property (nonatomic, copy) NSString *resume_id;
@property (nonatomic, assign) XYJobExperienceViewControllerType type;
@property (nonatomic, strong) NSMutableArray *jobExps;
@property (nonatomic, assign) BOOL isEditingJobExp;

@property (nonatomic, copy) void (^returnJobExps)(NSMutableArray *array);

@end
