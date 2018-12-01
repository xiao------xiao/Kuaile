//
//  HWStatusTextView.h
//  黑马微博2期
//
//  Created by apple on 14/11/15.
//  Copyright (c) 2014年 heima. All rights reserved.
//  用来显示微博正文的textView

#import <UIKit/UIKit.h>

@interface HWStatusTextView : UITextView

@property (nonatomic, assign) BOOL noJump;

/** 所有的特殊字符串(里面存放着HWSpecial) */
@property (nonatomic, strong) NSArray *specials;
@property (nonatomic, copy) void(^callBack)(BOOL isMember,NSString *touchStr);

/// 把特殊字符串 变成 普通字符串
- (NSString *)fullText;

@end
