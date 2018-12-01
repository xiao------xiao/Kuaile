//
//  HWStatusTextView.m
//  黑马微博2期
//
//  Created by apple on 14/11/15.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWStatusTextView.h"
#import "HWSpecial.h"
#import "TZContactTool.h"
#import "HWEmotionAttachment.h"
#import "HWEmotion.h"

#define HWStatusTextViewCoverTag 999

@interface HWStatusTextView ()<UIGestureRecognizerDelegate>

@end

@implementation HWStatusTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSetting];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSetting];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSetting];
    }
    return self;
}

- (void)setupSetting {
    self.backgroundColor = [UIColor clearColor];
    self.editable = NO;
    self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
    // 禁止滚动, 让文字完全显示出来
    self.scrollEnabled = NO;
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = __kColorWithRGB(0x535751);
}

- (void)setupSpecialRects
{
    if (!self.attributedText.length) {
        return;
    }
    NSRange *range;
    NSArray *specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:&range];
    for (HWSpecial *special in specials) {
        if (special.ID.length) {
            NSRange newRange = NSMakeRange(special.range.location, special.range.length - 3 - special.ID.length);
            self.selectedRange = newRange;
        } else {
            self.selectedRange = special.range;
        }
        // self.selectedRange --影响--> self.selectedTextRange
        // 获得选中范围的矩形框
        NSArray *selectionRects = [self selectionRectsForRange:self.selectedTextRange];
        // 清空选中范围
        self.selectedRange = NSMakeRange(0, 0);
        
        NSMutableArray *rects = [NSMutableArray array];
        for (UITextSelectionRect *selectionRect in selectionRects) {
            CGRect rect = selectionRect.rect;
            
            if (rect.size.width == 0 || rect.size.height == 0) continue;
            
            // 添加rect
            [rects addObject:[NSValue valueWithCGRect:rect]];
        }
        special.rects = rects;
    }
}

/**
 找出被触摸的特殊字符串
 */
- (HWSpecial *)touchingSpecialWithPoint:(CGPoint)point
{
    if (!self.attributedText.length) {
        return nil;
    }
    NSRange *range;
    NSArray *specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:&range];
    for (HWSpecial *special in specials) {
        for (NSValue *rectValue in special.rects) {
            if (CGRectContainsPoint(rectValue.CGRectValue, point)) { // 点中了某个特殊字符串
                return special;
            }
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 触摸对象
    UITouch *touch = [touches anyObject];
    // 触摸点
    CGPoint point = [touch locationInView:self];
    // 初始化矩形框
    [self setupSpecialRects];
    // 根据触摸点获得被触摸的特殊字符串
    HWSpecial *special = [self touchingSpecialWithPoint:point];
    // 在被触摸的特殊字符串后面显示一段高亮的背景
    for (NSValue *rectValue in special.rects) {
        // 在被触摸的特殊字符串后面显示一段高亮的背景
        UIView *cover = [[UIView alloc] init];
        UIColor *bgColor = TZColorRGB(236);
        cover.backgroundColor = bgColor;
        cover.frame = rectValue.CGRectValue;
        cover.tag = HWStatusTextViewCoverTag;
        cover.layer.cornerRadius = 5;
        [self insertSubview:cover atIndex:0];
    }
    NSLog(@"touchesBegan----");
}

- (NSString *)handleStringWithString:(NSString *)str{
    
    NSString *result;
    NSString *firstCutStr = [str substringToIndex:str.length - 2];
    for (int i = 0; i < str.length; i++) {
        unichar c = [str characterAtIndex:i];
        if (c == '=') {
           result = [firstCutStr substringFromIndex:i + 1];
            break;
        }
    }
    return result;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 触摸对象
    UITouch *touch = [touches anyObject];
    // 触摸点
    CGPoint point = [touch locationInView:self];
    // 根据触摸点获得被触摸的特殊字符串
    HWSpecial *special = [self touchingSpecialWithPoint:point];
    if (special.ID.length) {
        // NSString *number = [self handleStringWithString:special.text];
        NSString *number = special.ID;
        if (_callBack) {
            _callBack(YES,number);
        }
        NSLog(@"点击了用户:%@",special.text);
    } else {
        // NSString *str = [special.text substringWithRange:NSMakeRange(1, special.text.length - 2)];
        if (_callBack) {
            _callBack(NO,special.url);
        }
        NSLog(@"点击了特殊字符串:%@",special.url);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchesCancelled:touches withEvent:event];
    });
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 去掉特殊字符串后面的高亮背景
    for (UIView *child in self.subviews) {
        if (child.tag == HWStatusTextViewCoverTag) [child removeFromSuperview];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return [super hitTest:point withEvent:event];
}

///**
// 告诉系统:触摸点point是否在这个UI控件身上
// */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    //if (self.noJump) return NO;
    // 初始化矩形框
    [self setupSpecialRects];
    
    // 根据触摸点获得被触摸的特殊字符串
    HWSpecial *special = [self touchingSpecialWithPoint:point];
    
    if (special) {
        return YES;
    } else {
        return NO;
    }
}

// 触摸事件的处理
// 1.判断触摸点在谁身上: 调用所有UI控件的- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
// 2.pointInside返回YES的控件就是触摸点所在的UI控件
// 3.由触摸点所在的UI控件选出处理事件的UI控件: 调用- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event

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

@end
