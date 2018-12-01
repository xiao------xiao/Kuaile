//
//  ICEToolManager.m
//  ZhangChu
//
//  Created by 陈冰 on 15/1/23.
//  Copyright (c) 2015年 Glacier. All rights reserved.
//

#import "ICEToolManager.h"

@implementation ICEToolManager

+ (ICEToolManager *)sharedToolManager
{
    static ICEToolManager *tm = nil;
    @synchronized(self) {
        if (tm == nil) {
            tm = [[ICEToolManager alloc] init];
        }
    }
    return tm;
}

- (NSDictionary *)getRespondingDictionaryWithController:(UIViewController *)viewController
{
    return [self getRespondingDictionaryWithControllerClass:[viewController class]];
} // 类别判定
 
- (NSDictionary *)getRespondingDictionaryWithControllerClass:(Class)aClass
{
    NSString *className = NSStringFromClass(aClass);
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"handleKitchen" ofType:@"plist"]];
    dict = dict[className];
    return dict;
} // 获取plist里面的数据，用于快速布局，便于统一

+ (CGFloat)getHeightForiOS
{
    if ([UIDevice currentDevice].systemVersion.floatValue > 7.0) {
        return 64;
    } else {
        return 0;
    }
} // 通过操作系统版本判断是否需要变更高度

#pragma mark - 文字高度计算
+ (CGRect)sizeWithStr:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size
{
#if 0
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    [mdic setObject:font forKey:NSFontAttributeName];
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine;

    CGRect strRect = [str boundingRectWithSize:size options:options attributes:mdic context:nil];
    return strRect;
    
#else
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange allRange = [str rangeOfString:str];
    
    [attrStr addAttribute:NSFontAttributeName
                    value:font
                    range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor redColor]
                    range:allRange];
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine;
    
    CGRect strRect = [attrStr boundingRectWithSize:size options:options context:nil];
    return strRect;
#endif
} // 计算多大文字的的情况下，label大小

+ (CGFloat)heightWithLabelString:(NSString *)labelStr andFontNum:(CGFloat)fontNum andWidth:(CGFloat)labelWidth
{
    CGRect strRect = [self sizeWithStr:labelStr andFont:[UIFont systemFontOfSize:fontNum] andMaxSize:CGSizeMake(labelWidth, CGFLOAT_MAX)];
    CGFloat labelHeight = ceilf(strRect.size.height);
    return labelHeight+2; // 加两个像素,防止emoji被切掉.
} // label的高度

+(NSString *)stringFromChURL:(NSString *)str
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)str, NULL, NULL,  kCFStringEncodingUTF8 ));
} //解决网址里面有中文的情况

#pragma mark - 判断邮箱输入是否正确
+ (BOOL)validateEmail:(NSString *)candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
} // 判断邮箱是否正确

#pragma mark - 二维码
#define QRCodeStringRecognizer @"||||" //在字符串中植入一个唯一标识符号
- (NSString *)getQRCodeStringWithUrl:(NSString *)string indexOfModel:(NSInteger)index
{
    return [NSString stringWithFormat:@"%@%@%ld",string,QRCodeStringRecognizer,index];
} // 根据string和index获取一个codeString, 插入标识符号

- (BOOL)isQRCodeStringFitForApp:(NSString *)codeString
{
    if ([codeString rangeOfString:QRCodeStringRecognizer].location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
} // 验证这个标识符号是否存在

- (NSString *)getUrlFromQRCodeString:(NSString *)codeString
{
    NSArray * array = [codeString componentsSeparatedByString:QRCodeStringRecognizer];
    return array[0];
} // 将唯一标识别符号拆开，只获取URL

- (NSInteger)getIndexOfModelFromQRCodeString:(NSString *)codeString
{
    NSArray * array = [codeString componentsSeparatedByString:QRCodeStringRecognizer];
    NSString * indexString = [array lastObject];
    return indexString.integerValue;
}



/**
 * 将数字转换成中文数字
 * @author Prosper
 *
 */
/*
public static String intToZH(int i)
{
    String[] zh = {"零", "一", "二", "三", "四", "五", "六", "七", "八", "九"};
    String[] unit = {"", "十", "百", "千", "万", "十", "百", "千", "亿", "十"};
    String str = "";
    StringBuffer sb = new StringBuffer(String.valueOf(i));
    sb = sb.reverse();
    int r = 0;
    int l = 0;
    for (int j = 0; j < sb.length(); j++)
    {
        //  当前数字
        r = Integer.valueOf(sb.substring(j, j+1));
        if (j != 0)
         // 上一个数字
            l = Integer.valueOf(sb.substring(j-1, j));
        if (j == 0)
        {
            if (r != 0 || sb.length() == 1)
                str = zh[r];
            continue;
        }
        if (j == 1 || j == 2 || j == 3 || j == 5 || j == 6 || j == 7 || j == 9)
        {
            if (r != 0)
                str = zh[r] + unit[j] + str;
            else if (l != 0)
                str = zh[r] + str;
            continue;
        }
        if (j == 4 || j == 8)
        {
            str =  unit[j] + str;
            if ((l != 0 && r == 0) || r != 0)
                str = zh[r] + str;
            continue;
        }
    }
    return str;
}
}
*/
+ (NSString *)intToZH:(NSInteger)num {
    NSArray *zh = @[@"零", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九"];
    NSArray *unit = @[@"", @"十", @"百", @"千", @"万", @"十", @"百", @"千", @"亿", @"十"];
    NSString *str = @"";
    NSString *sb = [NSString stringWithFormat:@"%ld", num];
    int r = 0;
    int l = 0;
    for (int j = 0; j < sb.length; j++)
    {
        //  当前数字
        r = [[sb substringWithRange:NSMakeRange(j, j+1)] intValue];
        if (j != 0)
            // 上一个数字
            l = [[sb substringWithRange:NSMakeRange(j-1, j)] intValue];
        if (j == 0)
        {
            if (r != 0 || sb.length == 1)
                str = zh[r];
            continue;
        }
        if (j == 1 || j == 2 || j == 3 || j == 5 || j == 6 || j == 7 || j == 9)
        {
            if (r != 0)
                str = [NSString stringWithFormat:@"%@%@%@",zh[r],unit[j],str];
            else if (l != 0)
                str = [NSString stringWithFormat:@"%@%@",zh[r],str];
            continue;
        }
        if (j == 4 || j == 8)
        {
            str = [NSString stringWithFormat:@"%@%@",unit[j],str];
            if ((l != 0 && r == 0) || r != 0)
                str = [NSString stringWithFormat:@"%@%@",zh[r],str];
            continue;
        }
    }

    return str;
}

@end
