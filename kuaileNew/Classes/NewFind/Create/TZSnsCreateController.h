//
//  ZYYCreateTopicViewController.h
//  DemoProduct
//
//  Created by liujingyi on 16/1/5.
//  Copyright © 2016年 周毅莹. All rights reserved.
//
//#import "TZFindSnsModel.h"
#import <UIKit/UIKit.h>


//@class TZFindSnsModel;
@interface TZSnsCreateController : TZBaseViewController
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *team_id;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, assign) NSInteger index;
//@property (nonatomic, strong) TZFindSnsModel *model;
@property (nonatomic, copy) void(^refreshModel)();
@property (nonatomic, assign) BOOL iShow;
@property (nonatomic, copy) void(^callBack)();
@end
