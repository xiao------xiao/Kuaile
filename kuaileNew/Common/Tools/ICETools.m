//
//  ICETools.m
//  YiYuanYun
//
//  Created by 陈冰 on 15/5/12.
//  Copyright (c) 2015年 Glacier. All rights reserved.
//

#import "ICETools.h"
#import "math.h"

@implementation ICETools

//手机
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,183
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,177
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-9]|8[0-9]|4[0-9]|6[0-9]|7[0-9]|9[0-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[0-9]|5[0-9]|8[0-9])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-9]|5[0-9]|8[0-9])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,177
     22         */
    NSString * CT = @"^1((33|53|8[09]|77)[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//邮箱
+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//身份证
+ (BOOL)validateIDCard:(NSString *)iDCard {
    NSString *iDCardRegex = @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    NSPredicate *iDCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", iDCardRegex];
    return [iDCardTest evaluateWithObject:iDCard];
}

//qq
+ (BOOL)isQqNumber:(NSString *)qqNum {
    NSString *qqstr = @"[1-9][0-9]{4,}";
    NSPredicate *qqTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",qqstr];
    return [qqTest evaluateWithObject:qqNum];
}

//银行卡
+ (BOOL)validateBankCardNumber: (NSString *)bankCardNumber {
    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15,30})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];

    NSString *regex3 = @"^(支付宝)";
    NSPredicate *bankCardPredicate3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex3];

    NSString *regex4 = @"^(微信转账)";
    NSPredicate *bankCardPredicate4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex4];

    if (
        ([bankCardPredicate evaluateWithObject:bankCardNumber] == YES )||
        ([bankCardPredicate3 evaluateWithObject:bankCardNumber] == YES) ||
        ([bankCardPredicate4 evaluateWithObject:bankCardNumber] == YES)
        )
    {
        return YES;
    } else {
        return NO;
    }
}

// 时间戳转换标准时间
+ (NSString *)standardTime:(NSString *)timeStamp {
    double lastactivityInterval = [timeStamp doubleValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
    NSString *dateString = [formatter stringFromDate:date];
//    NSLog(@"format dateString:%@",dateString);
    return dateString;
}

// 时间转换时间戳
+ (NSString *)timeStamp:(NSString *)standardTime {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [formatter dateFromString:standardTime];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    //    NSLog(@"format dateString:%@",dateString);
    return timeSp;
}

/**
 * 将UIColor变换为UIImage
 *
 *  @param  color    颜色对象
 *
 *  return  theImage 图片对象
 *
 *  @since 1.0
 */
+ (UIImage *)imageCreateWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/*
常用到如image1.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(335));
CGAffineTransformMakeRotation中要填的是弧度，所以要转换一下。
下面是两个宏，来实现互转
1。弧度转角度
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
NSLog(@”Output radians as degrees: %f”, RADIANS_TO_DEGREES(0.785398));
2。角度转弧度
// Degrees to radians
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
NSLog(@”Output degrees as radians: %f”, DEGREES_TO_RADIANS(45));
M_PI 定义在Math.h内，其值为3.14159265358979323846264338327950288
*/
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
+ (NSString *)locationWithLatitude:(NSString *)firstLatitude withLongitude:(NSString *)firstLongitude WithLatitude:(NSString *)secondLatitude withLongitude:(NSString *)secondLongitude {
    double firLat = [firstLatitude doubleValue];
    double secLat = [secondLatitude doubleValue];
    double firLng = [firstLongitude doubleValue];
    double secLng = [secondLongitude doubleValue];
    
    double theta = firLng - secLng;
    double miles = (sin(DEGREES_TO_RADIANS(firLat)) * sin(DEGREES_TO_RADIANS(secLat))) + (cos(DEGREES_TO_RADIANS(firLat)) * cos(DEGREES_TO_RADIANS(secLat)) * cos(DEGREES_TO_RADIANS(theta)));
    miles = acos(miles);
    miles = RADIANS_TO_DEGREES(miles);
    miles = miles * 60 * 1.1515;// 英里
//    double feet = miles * 5280; // 英尺
    double kilometers = miles * 1.609344; // 千米
    kilometers = kilometers * 1000;
    kilometers = round(kilometers);
    NSString *milsStr = [NSString stringWithFormat:@"%0.f", kilometers];
    return milsStr;
}

#pragma mark - 获得位置信息
+ (NSString *)AddressMessage:(NSString *)lat withlon:(NSString *)lon{
    //http://api.map.baidu.com/geocoder/v2/?ak=oTfMooyyDDwq7pbh8N3xGt1F&callback=renderReverse&location=39.983424,116.322987&output=json&pois=0
    NSString * strUrl = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?ak=vPh9RWGUQFp9ah7PcrWadGmF&location=%@,%@&output=json&pois=0",lat,lon];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];//设置请求方式为POST，默认为GET
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString * strAD;
    if (received) {
        NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary * dicTemp = [jsonDic objectForKey:@"result"];
        strAD = [dicTemp objectForKey:@"formatted_address"];
    } else {
        DLog(@"失败");
    }
    return strAD;
    
}


@end
