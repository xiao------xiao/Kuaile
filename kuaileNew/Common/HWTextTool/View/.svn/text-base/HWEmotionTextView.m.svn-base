//
//  HWEmotionTextView.m
//  黑马微博2期
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWEmotionTextView.h"
#import "HWEmotion.h"
#import "HWEmotionAttachment.h"
#import "HWEmotionTool.h"
#import "HWTextPart.h"
#import "RegexKitLite.h"
#import "HWSpecial.h"
#import "NSString+Emoji.h"
#import "NSAttributedString+Utils.h"
#import "UITextView+Extension.h"

@interface HWEmotionTextView ()
@property (nonatomic, copy) NSString *lastFullText;
@end

@implementation HWEmotionTextView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [mNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 文字改变的通知
        [mNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (NSMutableArray *)userArray {
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

- (BOOL)isLostAtIdWithText:(NSString *)text {
    BOOL ret = YES;

    NSMutableArray *parts = [NSAttributedString partsArrayFromText:self.fullText forShow:NO];
    for (HWTextPart *part in parts) {
        if (part.special) { // 非表情的特殊文字
            /* // 这里已经有ID了，但是其他地方不好拿，先舍弃吧
            if (part.atId.length) {
                ret = NO;
                continue;
            }*/
            if ([part.text hasPrefix:@"@"]) {
                NSString *username = [part.text substringFromIndex:1];
                NSArray *userArr = [NSArray arrayWithArray:self.userArray];
                ret = YES;
                for (ICELoginUserModel *model in userArr) {
                    if ([model.username isEqualToString:username]) {
                        ret = NO;
                        break;
                    }
                }
            } else {
                ret = NO;
            }
        } else {
            ret = NO;
        }
    }
    return ret;
}

- (void)insertEmotion:(HWEmotion *)emotion {
    if (emotion.code) {
        // insertText : 将文字插入到光标所在的位置
        [self insertText:emotion.code.emoji];
    } else if (emotion.png) {
        // 加载图片
        HWEmotionAttachment *attch = [[HWEmotionAttachment alloc] init];
        
        // 传递模型
        attch.emotion = emotion;
        
        // 设置图片的尺寸
        CGFloat attchWH = self.font.lineHeight;
        attch.bounds = CGRectMake(0, -4, attchWH, attchWH);
        
        // 根据附件创建一个属性文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        
        // 插入属性文字到光标位置
        [self insertAttributedText:imageStr settingBlock:^(NSMutableAttributedString *attributedText) {
            // 设置字体
            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        }];
    }
}

- (NSString *)fullText {
    NSMutableString *fullText = [NSMutableString string];
    // 遍历所有的属性文字（图片、emoji、普通文字）
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        // 如果是图片表情
        HWEmotionAttachment *attch = attrs[@"NSAttachment"];
        if ([attch isKindOfClass:[HWEmotionAttachment class]] && attch) { // 图片
            [fullText appendString:attch.emotion.chs];
        } else { // emoji、普通文本
            // 获得这个范围内的文字
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    return fullText;
}

- (NSString *)fullTextWithID {
    return [self fullTextWithIDRemoveModel:NO];
}

- (NSString *)fullTextWithIDRemoveModel:(BOOL)removeModel {
    NSMutableString *attributedText = [[NSMutableString alloc] init];
    
    NSMutableArray *parts = [NSAttributedString partsArrayFromText:self.fullText forShow:NO];
    
    // 按顺序拼接每一段文字
    for (HWTextPart *part in parts) {
        // 等会需要拼接的子串
        NSMutableString *substr = [NSMutableString stringWithString:part.text];
        if (part.special) { // 非表情的特殊文字
            if (part.atId.length) {
                if (removeModel) {
                    [self removeUserModelWithRealName:part.textRealname];
                }
                continue;
            }
            if ([part.text hasPrefix:@"@"]) {
                NSString *username = [part.text substringFromIndex:1];
                NSArray *userArr = [NSArray arrayWithArray:self.userArray];
                for (ICELoginUserModel *model in userArr) {
                    if ([model.username isEqualToString:username]) {
                        [substr appendFormat:@"=%@=:",model.uid];
                        if (removeModel) {
                            [self.userArray removeObject:model];
                        }
                        break;
                    }
                }
            }
        }
        [attributedText appendString:substr];
    }
    if ([attributedText hasPrefix:@"@"]) {
        // [self handleStringWithString:attributedText];
    }
    return attributedText;
}

- (void)removeUserModelWithRealName:(NSString *)realname {
    NSArray *userArr = [NSArray arrayWithArray:self.userArray];
    for (ICELoginUserModel *model in userArr) {
        if ([model.username isEqualToString:realname]) {
            [self.userArray removeObject:model];
            break;
        }
    }
}

- (NSMutableAttributedString*)handleStringWithString : (NSMutableAttributedString*)string {
    NSInteger strLength = string.length;
    BOOL isSecond = 0;
    // DLog(@"%ld",string.length);
    NSInteger location = 0;
    NSInteger subLength = 0;
    NSString *subStr = [string.string substringToIndex:strLength - 2];
    for (int i = 0; i < subStr.length; i ++) {
        unichar c = [subStr characterAtIndex:i];
        if (c == '=') {
            if (!isSecond) {
                location = i;
                isSecond = YES;
            } else {
                subLength = i - location + 1;
                break;
            }
        }
    }
    [string deleteCharactersInRange:NSMakeRange(location, subLength)];
    return string;
}



- (void)dealloc {
    [mNotificationCenter removeObserver:self];
}

/**
 selectedRange :
 1.本来是用来控制textView的文字选中范围
 2.如果selectedRange.length为0，selectedRange.location就是textView的光标位置
 
 关于textView文字的字体
 1.如果是普通文字（text），文字大小由textView.font控制
 2.如果是属性文字（attributedText），文字大小不受textView.font控制，应该利用NSMutableAttributedString的- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;方法设置字体
 **/
@end
