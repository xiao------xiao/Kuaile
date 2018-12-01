//
//  ZYYSnsDetailController.h
//  DemoProduct
//
//  Created by 一盘儿菜 on 16/6/25.
//  Copyright © 2016年 周毅莹. All rights reserved.
//

#import "TZFindSnsModel.h"
#import "TZSnsListRootController.h"
typedef NS_ENUM (NSUInteger, Type) {
    Reply = 0,
    Comment,
};

@class TZFindSnsModel;
@interface ZYYSnsDetailController : TZSnsListRootController

@property (nonatomic, strong) TZFindSnsModel *model;

@property (nonatomic, copy) void (^didDeleteSnsDataBlock)();

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) void (^refreshUIBlock)();
@property (nonatomic, copy) void (^refreshDeleteUIBlock)(TZFindSnsModel *model,NSString *sid);
@property(nonatomic,assign) Type type;

@property (nonatomic, assign) NSInteger shareIndex;

- (void)refreshSnsDetailData;

@end
