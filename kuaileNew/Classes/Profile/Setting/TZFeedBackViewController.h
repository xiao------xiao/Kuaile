//
//  TZFeedBackViewController.h
//  刷刷
//
//  Created by 谭真 on 16/2/16.
//  Copyright © 2016年 圣巴(上海)文化传播有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TZInputVcTypeFeedBack,    // 意见反馈
} TZInputVcType;

@interface TZFeedBackViewController : TZBaseViewController

@property (nonatomic, assign) TZInputVcType type;
@property (nonatomic, copy) void(^returnUserInput)(NSString *);
@property (nonatomic, copy) NSString *textViewText;

@end
