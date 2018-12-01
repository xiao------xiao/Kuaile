//
//  HWEmotionTextView.h
//  黑马微博2期
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWTextView.h"
@class HWEmotion;

@interface HWEmotionTextView : HWTextView

- (void)insertEmotion:(HWEmotion *)emotion;

- (BOOL)isLostAtIdWithText:(NSString *)text;

/// 把特殊字符串 变成 普通字符串
- (NSString *)fullText;
/// 把特殊字符串 变成 普通字符串，在@后拼接=id=:
- (NSString *)fullTextWithID;
/// 把特殊字符串 变成 普通字符串，在@后拼接=id=:   拼接ID后是否移除用户模型
- (NSString *)fullTextWithIDRemoveModel:(BOOL)removeModel;

@property (nonatomic, strong) NSMutableArray *userArray;

@end
