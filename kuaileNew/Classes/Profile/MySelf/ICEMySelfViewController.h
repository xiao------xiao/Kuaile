//
//  ICEMySelfViewController.h
//  hxjjyh
//
//  Created by ttouch on 15/8/19.
//  Copyright (c) 2015年 陈冰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ICEIdentVerifyType) {
    ICEIdentVerifyNoCheck,     // 0未认证 1审核中 2审核未通过 3审核通过
    ICEIdentVerifyProceed,
    ICEIdentVerifyNotYet,
    ICEIdentVerifyPass
};

@interface ICEMySelfViewController : TZTableViewController

@end
