//
//  HWTextPart.h
//  黑马微博2期
//
//  Created by apple on 14/11/15.
//  Copyright (c) 2014年 heima. All rights reserved.
//  文字的一部分

#import <Foundation/Foundation.h>

@interface HWTextPart : NSObject
/** 这段文字的内容（所有） */
@property (nonatomic, copy) NSString *text;
/** 这段文字的真实url */
@property (nonatomic, copy) NSString *url;
/** 这段文字的内容(只有用户昵称) */
@property (nonatomic, copy) NSString *textRealname;
/** 这段文字的范围 */
@property (nonatomic, assign) NSRange range;
/** 是否为@ */
@property (nonatomic, assign, getter = isAt) BOOL at;
/** @的ID */
@property (nonatomic, copy) NSString *atId;
/** 是否为特殊文字 */
@property (nonatomic, assign, getter = isSpecical) BOOL special;
/** 是否为表情 */
@property (nonatomic, assign, getter = isEmotion) BOOL emotion;
@end
