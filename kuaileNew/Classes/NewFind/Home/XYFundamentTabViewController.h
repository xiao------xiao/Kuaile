//
//  XYFundamentTabViewController.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/15.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "TZTableViewController.h"
#import "TZFindSnsModel.h"

@class TZFindSnsModel;
@interface XYFundamentTabViewController : TZBaseViewController

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, assign) NSInteger sid;
@property (nonatomic, strong) TZFindSnsModel * model;
@property (nonatomic, assign) CGFloat rowH;

@end
