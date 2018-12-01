//
//  NSAttributedString+Utils.m
//  DemoProduct
//
//  Created by 谭真 on 16/6/10.
//  Copyright © 2016年 周毅莹. All rights reserved.
//

#import "NSAttributedString+Utils.h"
#import "HWTextPart.h"
#import "RegexKitLite.h"
#import "HWSpecial.h"
#import "HWEmotionTool.h"
#import "NSString+Emoji.h"
#import "HWEmotion.h"
#import "HWEmotionAttachment.h"

@implementation NSAttributedString (Utils)

/**
 *  普通文字 --> 属性文字
 *
 *  @param text 普通文字
 *
 *  @return 属性文字
 */
+ (NSAttributedString *)attributedTextWithText:(NSString *)string {
    return [self attributedTextWithText:string textColor:[UIColor blackColor] fontSize:15];
}

+ (NSAttributedString *)attributedTextWithText:(NSString *)string textColor:(UIColor *)textColor {
    return [self attributedTextWithText:string textColor:textColor fontSize:14];
}

+ (NSAttributedString *)attributedTextWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize {
    if (!text || !text.length) {
        return nil;
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    NSMutableArray *parts = [self partsArrayFromText:text];
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSMutableArray *specials = [NSMutableArray array];
    // 按顺序拼接每一段文字
    for (HWTextPart *part in parts) {
        // 等会需要拼接的子串
        NSAttributedString *substr = nil;
        if (part.isEmotion) { // 表情
            HWEmotionAttachment *attch = [[HWEmotionAttachment alloc] init];
            attch.emotion = [HWEmotionTool emotionWithChs:part.text];
            NSString *name = [HWEmotionTool emotionWithChs:part.text].png;
            if (name) { // 能找到对应的图片
                attch.image = [UIImage imageNamed:name];
                attch.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                substr = [NSAttributedString attributedStringWithAttachment:attch];
            } else { // 表情图片不存在
                substr = [[NSAttributedString alloc] initWithString:part.text];
            }
        } else if (part.special) { // 非表情的特殊文字
            substr = [[NSAttributedString alloc] initWithString:part.text attributes:@{NSForegroundColorAttributeName : TZMainColor}];
            // 创建特殊对象
            HWSpecial *s = [[HWSpecial alloc] init];
            s.text = part.text;
            s.url = part.url;
            if (part.isAt) {
                s.ID = part.atId;
                s.text = part.textRealname;
                substr = [[NSAttributedString alloc] initWithString:part.textRealname attributes:@{NSForegroundColorAttributeName : TZMainColor}];
            }
            NSUInteger loc = attributedText.length;
            NSUInteger len = part.text.length;
            if (part.url.length) { // 是网页链接，加一个图标
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                attch.image = [UIImage imageNamed:@"timeline_card_small_web"];
                attch.bounds = CGRectMake(0, 0, font.lineHeight - 6, font.lineHeight - 6);
                NSAttributedString *iconSubstr = [NSAttributedString attributedStringWithAttachment:attch];
                [attributedText appendAttributedString:iconSubstr];
                len = part.text.length + 1;
            }
            s.range = NSMakeRange(loc, len);
            [specials addObject:s];
        } else { // 非特殊文字
            substr = [[NSAttributedString alloc] initWithString:part.text attributes:@{NSForegroundColorAttributeName:textColor}];
        }
        [attributedText appendAttributedString:substr];
    }
    
    // 一定要设置字体,保证计算出来的尺寸是正确的
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
    [attributedText addAttribute:@"specials" value:specials range:NSMakeRange(0, 1)];
    
    if ([attributedText.string hasPrefix:@"@"]) {
        [self handleStringWithString:attributedText];
    }
    
    return attributedText;
}

+ (NSMutableArray *)partsArrayFromText:(NSString *)text {
    return [self partsArrayFromText:text forShow:YES];
}

+ (NSMutableArray *)partsArrayFromText:(NSString *)text forShow:(BOOL)forShow {
    // 表情的规则
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    // @的规则
    NSString *atPattern = @"@[\p{Z}\s0-9a-zA-Z\\u4e00-\\u9fa5-_]+=[0-9]+=:";
    NSString *atPattern1 = @"@[\p{Z}\s0-9a-zA-Z\\u4e00-\\u9fa5-_]+";
    NSString *atPattern2 = @"@.{1,}：";
    NSString *atPattern3 = @" [\p{Z}\s0-9a-zA-Z\\u4e00-\\u9fa5-_]+=[0-9]+=:";
    NSString *atPattern4 = @" [\p{Z}\s0-9a-zA-Z\\u4e00-\\u9fa5-_]+=[0-9]+=:";
    // url链接的规则(微博url的正则)
    NSString *urlPattern = @"([hH]ttp[s]{0,1})://[a-zA-Z0-9\.\-]+\.([a-zA-Z]{2,4})(:\d+)?(/[a-zA-Z0-9\-~!@#$%^&*+?:_/=<>.',;]*)?";
    NSString *urlPattern1 = @"([hH]ttp[s]{0,1})://[a-zA-Z0-9\.\-]+\.([a-zA-Z]{2,4})(:\d+)?(/[a-zA-Z0-9\-~!@#$%^&*+?:_/=<>]*)?";
    NSString *urlPattern2 = @"(?i)https?://[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+([-A-Z0-9a-z_\$\.\+!\*\(\)/,:;@&=\?~#%]*)*";
    NSString *urlPattern3 = @"^http?://[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+(\/[\w-. \/\?%@&+=\u4e00-\u9fa5]*)?$";
    // #话题#的规则
    NSString *topicPattern = @"#[\p{Z}\s0-9a-zA-Z\\u4e00-\\u9fa5-_]+#";
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@", emotionPattern, atPattern, atPattern1 ,atPattern2, atPattern3, atPattern4, urlPattern , urlPattern1, urlPattern2, urlPattern3 ,topicPattern];
    // 遍历所有的特殊字符串
    NSMutableArray *parts = [NSMutableArray array];
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        HWTextPart *part = [[HWTextPart alloc] init];
        part.special = YES;
        part.text = *capturedStrings;
        part.emotion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
        part.range = *capturedRanges;
        part.at = [part.text hasPrefix:@"@"] || [part.text hasSuffix:@"=:"];
        if (part.isAt) {
            NSArray *array = [part.text componentsSeparatedByString:@"="];
            if (array.count > 1) {
                part.atId = array[1];
            }
            part.textRealname = array[0];
            part.textRealname = [part.textRealname stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSRange newRange = NSMakeRange(part.range.location, part.textRealname.length);
            part.range = newRange;
        }
        if (forShow) {
            if ([part.text hasPrefix:@"http://"] || [part.text hasPrefix:@"https://"]) {
                part.url = part.text;
                part.text = @"网页链接";
            }
        }
        [parts addObject:part];
    }];

    // 遍历所有的非特殊字符
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        HWTextPart *part = [[HWTextPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    
    // 排序
    // 系统是按照从小 -> 大的顺序排列对象
    [parts sortUsingComparator:^NSComparisonResult(HWTextPart *part1, HWTextPart *part2) {
        // NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
        // 返回NSOrderedSame:两个一样大
        // NSOrderedAscending(升序):part2>part1
        // NSOrderedDescending(降序):part1>part2
        if (part1.range.location > part2.range.location) {
            // part1>part2
            // part1放后面, part2放前面
            return NSOrderedDescending;
        }
        // part1<part2
        // part1放前面, part2放后面
        return NSOrderedAscending;
    }];
    return parts;
}

+ (NSMutableAttributedString*)handleStringWithString : (NSMutableAttributedString*)string {
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


@end
