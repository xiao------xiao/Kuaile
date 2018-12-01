//
//  CommonTools.m
//  housekeep
//
//  Created by ttouch on 16/5/8.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "CommonTools.h"
#import "math.h"
#import "ProgressHUD.h"

@implementation CommonTools

#pragma mark - 应用信息

+ (void)callPhoneWithPhoneNumber:(NSString *)phoneNumber {
    
    if (phoneNumber.length <= 0) {
        NSLog(@"tool : phonenumber Error");
        //        [ProgressHUD show:@"phonenumber Error"];
        return;
    }
    
    {
        static int retap = 1;
        if (retap != 1) { return; }
        retap = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            retap = 1;
        });
    }
    
    [ProgressHUD show:@"请稍后..."];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:url]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
    //    [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES} completionHandler:nil];
}


+ (NSString *)appDisplayName {
    NSString *appDisplayName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
    if (!appDisplayName) appDisplayName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
    return appDisplayName;
}

+ (NSString *)appBundleName {
    return [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
}

+ (NSString *)appVersion {
    NSString *version = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    return version;
}

+ (BOOL)needShowNewFeature {
    NSString *lastVersion = [mUserDefaults objectForKey:@"lastversion"];
    if (!lastVersion || ![lastVersion isEqualToString:[self appVersion]]) {
        NSString *versionStr = [self appVersion];
        [mUserDefaults setObject:versionStr forKey:@"lastversion"];
        [mUserDefaults synchronize];
        return YES;
    }
    return NO;
}

#pragma mark - 文本计算

/// 计算文字size
+ (CGSize)sizeOfText:(NSString *)text fontSize:(CGFloat)fontSize {
    return [self sizeOfText:text fontSize:fontSize width:CGFLOAT_MAX height:5000];
}

+ (CGSize)sizeOfText:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width {
    return [self sizeOfText:text fontSize:fontSize width:width height:5000];
}

+ (CGSize)sizeOfText:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width height:(NSInteger)height {
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}

/// 生成富文本
+ (NSMutableAttributedString *)createAttrStrWithStrArray:(NSArray *)strArray colorArray:(NSArray *)colorArray {
    return [self createAttrStrWithStrArray:strArray colorArray:colorArray fontArray:nil];
}

+ (NSMutableAttributedString *)createAttrStrWithStrArray:(NSArray *)strArray colorArray:(NSArray *)colorArray fontArray:(NSArray *)fontArray {
    NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] init];
    for (NSInteger i = 0; i < strArray.count; i++) {
        NSString *str = strArray[i];
        
        UIColor *color = [UIColor blackColor];
        if (i < colorArray.count) {
            id colorItem = colorArray[i];
            if ([colorItem isKindOfClass:[UIColor class]]) {
                color = colorItem;
            } else if ([colorItem isKindOfClass:[NSNumber class]]) {
                color = TZColorRGB([colorItem integerValue]);
            }
        }
        
        UIFont *font = [UIFont systemFontOfSize:16];
        if (i < fontArray.count) {
            id fontItem = fontArray[i];
            if ([fontItem isKindOfClass:[UIFont class]]) {
                font = fontItem;
            } else if ([fontItem isKindOfClass:[NSNumber class]]) {
                font = [UIFont systemFontOfSize:[fontItem integerValue]];
            }
        }
        
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName : color}];
        [mAttrStr appendAttributedString:attrStr];
    }
    return mAttrStr;
}

+ (NSMutableAttributedString *)createAttrStrWithAttriString:(NSAttributedString *)attrStr attachImage:(UIImage *)attchImage {
    NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithAttributedString:attrStr];
    NSTextAttachment *attchment = [[NSTextAttachment alloc] init];
    attchment.image = attchImage;
    //CGFloat attchH = attrStr.font.lineHeight;
    CGFloat attchH = 10;
    attchment.bounds = CGRectMake(3, -4, attchImage.size.width, attchH);
    NSAttributedString *attrImageStr = [NSAttributedString attributedStringWithAttachment:attchment];
    [mAttrStr appendAttributedString:attrImageStr];
    return mAttrStr;
}

#pragma mark - 提示文本

/// 显示一个纯文字的tipLable
+ (void)showInfo:(NSString *)message {
    [SGInfoAlert showInfo:message bgColor:[[UIColor darkGrayColor] CGColor] fgColor:[[UIColor whiteColor] CGColor] inView:[UIApplication sharedApplication].keyWindow vertical:0.5];
}

+ (void)popTipShowHint:(NSString *)hint atView:(UIView *)view inView:(UIView *)inView {
    [self popTipShowHint:hint atView:view inView:inView direction:PointDirectionAny];
}

+ (void)popTipShowHint:(NSString *)hint atView:(UIView *)view inView:(UIView *)inView direction:(PointDirection)dire {
    CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:hint];
    //    popTipView.disableTapToDismiss = YES;
    //    popTipView.cornerRadius = 2.0;
    //    popTipView.sidePadding = 30.0f;
    //    popTipView.topMargin = 20.0f;
    //    popTipView.pointerSize = 50.0f;
    //    popTipView.has3DStyle = (BOOL)(arc4random() % 2);
    //    popTipView.animation = arc4random() % 2;
    //    popTipView.hasGradientBackground = NO;
    //    popTipView.hasShadow = NO;
    popTipView.preferredPointDirection = dire;
    popTipView.backgroundColor = TZMainColor;
    popTipView.has3DStyle = NO;
    popTipView.borderWidth = 0;
    popTipView.dismissTapAnywhere = YES;
    [popTipView autoDismissAnimated:NO atTimeInterval:2.0f];
    [popTipView presentPointingAtView:view inView:inView animated:YES];
}

#pragma mark - 正则验证

/// 是否是身份证
+ (BOOL)isIdentityCard: (NSString *)identityCard {
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

/// 是否是手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,183
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,177
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-9]|8[0-9]|7[0-9])\\d{8}$";
    NSString * CM = @"^1(34[0-9]|(3[0-9]|5[0-9]|8[0-9])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09]|77)[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm     = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu     = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct     = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    return (([regextestmobile evaluateWithObject:mobileNum]) || ([regextestcm evaluateWithObject:mobileNum]) || ([regextestct evaluateWithObject:mobileNum]) || ([regextestcu evaluateWithObject:mobileNum]));
}

/// 是否是邮箱
+ (BOOL)isEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/// 是否是QQ
+ (BOOL)isQqNumber:(NSString *)qqNum {
    NSString *qqstr = @"[1-9][0-9]{4,}";
    NSPredicate *qqTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",qqstr];
    return [qqTest evaluateWithObject:qqNum];
}

/// 是否是银行卡
+ (BOOL)isBankCardNumber: (NSString *)bankCardNumber {
    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15,30})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}

#pragma mark - 颜色相关

/// 返回随机颜色
+ (UIColor *)colorLightRandom {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 );  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

/// 以UIColor生成一张UIImage
+ (UIImage *)imageCreateWithColor:(UIColor *)color {
    return [self imageCreateWithColor:color size:CGSizeMake(1.0, 1.0)];
}

+ (UIImage *)imageCreateWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - 图片相关

/// 压缩图片尺寸,方便上传服务器
+ (UIImage *)imageScale:(UIImage *)img size:(CGSize)size{
    if (img.size.width <= size.width) {
        return img;
    }
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

/// 用 文字+背景色 来生成一张图片
+ (UIImage *)createImageWithTitle:(NSString *)title bgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius {
    CGSize imageSize = [CommonTools sizeOfText:title fontSize:12];
    UIImage *image = [self imageCreateWithColor:bgColor size:CGSizeMake((int)imageSize.width + 4, (int)imageSize.height + 4)];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = view.bounds;
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = view.bounds;
    [label setTitle:title font:@12 color:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
    [view addSubview:label];
    view.layer.cornerRadius = cornerRadius;
    view.clipsToBounds = YES;
    
    image = [self convertViewToImage:view];
    return image;
}

/// 将UIView渲染成UIImage对象
+ (UIImage *)convertViewToImage:(UIView *)view {
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 时间戳 <-> 时间字符串 转换

/// 时间戳 -> 时间字符串 dateFormat默认为yyyy-MM-dd
+ (NSString *)getTimeStrBytimeStamp:(NSString *)timeStamp {
    return [self getTimeStrBytimeStamp:timeStamp dateFormat:@"yyyy-MM-dd "];
}

+ (NSString *)getTimeStrWithHourBytimeStamp:(NSString *)timeStamp {
    return [self getTimeStrBytimeStamp:timeStamp dateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)getTimeStrBytimeStamp:(NSString *)timeStamp dateFormat:(NSString *)dataFormat {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dataFormat];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString ? dateString : @"";
}

/// 时间字符串 -> 时间戳 dateFormat默认为yyyy-MM-dd
+ (NSString *)getTimeStampBytimeStr:(NSString *)timeStr {
    return [self getTimeStampBytimeStr:timeStr dateFormat:@"yyyy-MM-dd "];
}
+ (NSString *)getTimeStampWithHourBytimeStr:(NSString *)timeStr {
    return [self getTimeStampBytimeStr:timeStr dateFormat:@"yyyy-MM-dd HH:mm:ss"];
}
+ (NSString *)getTimeStampBytimeStr:(NSString *)timeStr dateFormat:(NSString *)dataFormat {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat = dataFormat;
    NSDate *date = [formatter dateFromString:timeStr];
    NSString *timeSp = [NSString stringWithFormat:@"%.f",[date timeIntervalSince1970]];
    return timeSp;
}

+ (NSString *)getFriendTimeFromTimeStamp:(NSString *)timeStamp {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeStamp.floatValue];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    if ([createDate isYesterday]) { // 昨天
        return @"一天前";
    } else if ([createDate isToday]) { // 今天
        if (cmps.hour >= 1) {
            return [NSString stringWithFormat:@"%d小时前", (int)cmps.hour];
        } else if (cmps.minute >= 1) {
            return [NSString stringWithFormat:@"%d分钟前", (int)cmps.minute];
        } else {
            return @"刚刚";
        }
    } else { // 今年的其他日子
//        fmt.dateFormat = @"yyyy-MM-dd";
//        return [fmt stringFromDate:createDate];
        NSInteger day = cmps.day > 5 ? 5 : cmps.day;
        return [NSString stringWithFormat:@"%ld天前",day];
    }
}

#pragma mark - 富文本字符串处理

/// 返回NSAttributedString，左侧String为灰色，右侧为kMainColor
+ (NSAttributedString *)getAttributedStringWithFirstString:(NSString *)firstStr firstColor:(UIColor *)firstColor lastString:(NSString *)lastStr lastColor:(UIColor *)lastColor fontSize:(CGFloat )fontSize {
    UIFont *font = [UIFont fontWithName:@"ZhaimiMedium-" size:fontSize];
    NSMutableAttributedString *p1 = [[NSMutableAttributedString alloc] initWithString:firstStr attributes:@{ NSFontAttributeName : font, NSForegroundColorAttributeName :firstColor }];
    NSMutableAttributedString *p2 = [[NSMutableAttributedString alloc] initWithString:lastStr attributes:@{ NSFontAttributeName : font, NSForegroundColorAttributeName :lastColor }];
    [p1 appendAttributedString:p2];
    return p1;
}

#pragma mark - 距离计算

/*
 2个坐标距离
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

#pragma mark - 其他

/// 防止nil，如果是nil,返回空字符串
+ (NSString *)avoidNil:(NSString *)str {
    if (!str) return @"";
    if ([str isEqualToString:@"(null)"]) return @"";
    return str;
}

/// 检查value是否为空，是空则返回NO,非空返回YES
+ (BOOL)isNotNull:(id)value {
    if (!value) return NO;
    if ([value isKindOfClass:[NSNull class]]) return NO;
    return YES;
}

+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

/// 判断文件夹是否存在
+ (BOOL)isExistFile:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(!(isDirExist && isDir)) {
        return false;
    }
    return true;
}

/// 通用的警告框提示
+ (void)alertFormatofTitle:(NSString *)title withMessage:(NSString *)message withCancelBtnTitle:(NSString *)cancelTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil];
    [alert show];
}

/// 生成所有属性
+ (void)printPropertyWithDict:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSMutableString *strM = [NSMutableString stringWithString:@"\n"];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *str;
        //NSLog(@"%@",[obj class]);
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")] || [obj isKindOfClass:NSClassFromString(@"NSTaggedPointerString")] || [obj isKindOfClass:NSClassFromString(@"__NSCFConstantString")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) int %@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSArray *%@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSDictionary *%@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
        }
        if ([obj isKindOfClass:[NSNull class]]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",key];
        }
        [strM appendFormat:@"%@\n",str];
    }];
    NSLog(@"%@",strM);
}

@end
