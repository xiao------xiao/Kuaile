/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

@class XYRecommendFriendModel;

typedef enum{
    ApplyStyleFriend            = 0,
    ApplyStyleGroupInvitation,
    ApplyStyleJoinGroup,
    ApplyStyleFriendResult,
}ApplyStyle;

@interface ApplyViewController : TZBaseViewController
{
    NSMutableArray *_dataSource;
}

@property (strong, nonatomic, readonly) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *recommentLists;


+ (instancetype)shareController;

- (void)addNewApply:(NSDictionary *)dictionary;
- (void)didAddNewApply:(XYRecommendFriendModel *)friendModel;

- (void)loadDataSourceFromLocalDB;

- (void)clear;

@end
