//
//  XYCollectedJobViewController.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/22.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "TZTableViewController.h"

typedef NS_ENUM(NSInteger, XYCollectedJobViewControllerType) {
    XYCollectedJobViewControllerTypeApply,
    XYCollectedJobViewControllerTypeCollect,
};



@interface XYCollectedJobViewController : TZTableViewController

@property (nonatomic, copy) NSString *titleText;

@property (nonatomic, assign) XYCollectedJobViewControllerType type;

@end
