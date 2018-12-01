//
//  XYMoreFriendNotiController.h
//  kuaile
//
//  Created by 肖兰月 on 2017/3/27.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "TZTableViewController.h"

typedef NS_ENUM(NSInteger, XYMoreFriendNotiControllerType) {
    XYMoreFriendNotiControllerTypeFriend,
    XYMoreFriendNotiControllerTypeGroups,
};

@interface XYMoreFriendNotiController : TZTableViewController

@property (nonatomic, strong) NSMutableArray *addFriends;

@property (nonatomic, assign) XYMoreFriendNotiControllerType type;

@end
