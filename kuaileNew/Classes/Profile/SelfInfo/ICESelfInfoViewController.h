//
//  ICESelfInfoViewController.h
//  kuaile
//
//  Created by ttouch on 15/9/16.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZResumeRootController.h"

typedef NS_ENUM(NSInteger, ICESelfInfoViewControllerType) {
    ICESelfInfoViewControllerTypeOther,
    ICESelfInfoViewControllerTypeSelf,
};

@class NearPeople;
@interface ICESelfInfoViewController : TZResumeRootController

@property (nonatomic, assign) ICESelfInfoViewControllerType type;
@property (nonatomic, strong) NearPeople *model;
@property (nonatomic, copy) NSString *otherUsername;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nickName;


@property (nonatomic, copy) void(^addBlock)(BOOL isAdd);

@end
