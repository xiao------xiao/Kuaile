//
//  XYSystemDetailController.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/13.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "TZTableViewController.h"
@class XYMessageModel;
@interface XYSystemMessageDetailController : TZTableViewController

@property (nonatomic, copy) NSString *titleText;

@property (nonatomic, strong) NSArray <XYMessageModel *>* unreadMeg;

@end

