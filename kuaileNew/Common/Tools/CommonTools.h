//
//  CommonTools.h
//  housekeep
//
//  Created by ttouch on 16/5/8.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPopTipView.h"

@interface CommonTools : NSObject

#pragma mark - 应用信息
+ (void)callPhoneWithPhoneNumber:(NSString *)phoneNumber;

+ (NSString *)appDisplayName;
+ (NSString *)appBundleName;
+ (NSString *)appVersion;
+ (BOOL)needShowNewFeature;

#pragma mark - 文本计算

/// 计算文字size
+ (CGSize)sizeOfText:(NSString *)text fontSize:(CGFloat)fontSize;
+ (CGSize)sizeOfText:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width;
+ (CGSize)sizeOfText:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width height:(NSInteger)height;
/// 生成富文本
+ (NSMutableAttributedString *)createAttrStrWithStrArray:(NSArray *)strArray colorArray:(NSArray *)colorArray;
+ (NSMutableAttributedString *)createAttrStrWithStrArray:(NSArray *)strArray colorArray:(NSArray *)colorArray fontArray:(NSArray *)fontArray;
+ (NSMutableAttributedString *)createAttrStrWithAttriString:(NSAttributedString *)attrStr attachImage:(UIImage *)attchImage;

#pragma mark - 提示文本

/// 显示一个纯文字的tipLable 会自己dismiss
+ (void)showInfo:(NSString *)message;
/// 在atView下面显示一个提示框
+ (void)popTipShowHint:(NSString *)hint atView:(UIView *)view inView:(UIView *)inView;
+ (void)popTipShowHint:(NSString *)hint atView:(UIView *)view inView:(UIView *)inView direction:(PointDirection)dire;

#pragma mark - 正则验证

/// 是否是身份证
+ (BOOL)isIdentityCard: (NSString *)identityCard;
/// 验证手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
/// 验证电子邮件
+ (BOOL)isEmail:(NSString *)email;
/// 验证qq
+ (BOOL)isQqNumber:(NSString *)qqNum;
/// 验证银行卡号
+ (BOOL)isBankCardNumber:(NSString *)bankCardNumber;

#pragma mark - 颜色相关

/// 随机颜色
+ (UIColor *)colorLightRandom;
/// 以UIColor生成一张UIImage
+ (UIImage *)imageCreateWithColor:(UIColor *)color;
+ (UIImage *)imageCreateWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark - 图片相关

/// 压缩图片尺寸，方便上传服务器
+ (UIImage *)imageScale:(UIImage *)img size:(CGSize)size;
/// 用 文字+背景色 来生成一张图片
+ (UIImage *)createImageWithTitle:(NSString *)title bgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius;
/// 将UIView渲染成UIImage对象
- (UIImage *)convertViewToImage:(UIView *)view;

#pragma mark - 时间戳 <-> 时间字符串 转换

/// 时间戳 -> 时间字符串 dateFormat默认为yyyy-MM-dd
+ (NSString *)getTimeStrBytimeStamp:(NSString *)timeStam;
+ (NSString *)getTimeStrWithHourBytimeStamp:(NSString *)timeStamp;
+ (NSString *)getTimeStrBytimeStamp:(NSString *)timeStamp dateFormat:(NSString *)dataFormat;
/// 时间字符串 -> 时间戳 dateFormat默认为yyyy-MM-dd
+ (NSString *)getTimeStampBytimeStr:(NSString *)timeStr;
+ (NSString *)getTimeStampWithHourBytimeStr:(NSString *)timeStr;
+ (NSString *)getTimeStampBytimeStr:(NSString *)timeStr dateFormat:(NSString *)dataFormat;
/// 友好时间 MM:dd
+ (NSString *)getFriendTimeFromTimeStamp:(NSString *)timeStamp;

#pragma mark - 富文本字符串处理

/// 返回NSAttributedString，左侧String为灰色，右侧为TZMainColor
+ (NSAttributedString *)getAttributedStringWithFirstString:(NSString *)firstStr firstColor:(UIColor *)firstColor lastString:(NSString *)lastStr lastColor:(UIColor *)lastColor fontSize:(CGFloat )fontSize;

#pragma mark - 距离计算

/// 2个坐标距离
+ (NSString *)locationWithLatitude:(NSString *)firstLatitude withLongitude:(NSString *)firstLongitude WithLatitude:(NSString *)secondLatitude withLongitude:(NSString *)secondLongitude;

#pragma mark - 其他

/// 防止nil，如果是nil,返回空字符串
+ (NSString *)avoidNil:(NSString *)str;
/// 检查value是否为空，是空则返回NO,非空返回YES
+ (BOOL)isNotNull:(id)value;
/// 判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string;
/// 判断文件夹是否存在
+ (BOOL)isExistFile:(NSString *)path;
/// 通用的警告框提示
+ (void)alertFormatofTitle:(NSString *)title withMessage:(NSString *)message withCancelBtnTitle:(NSString *)cancelTitle;

/// 生成所有属性
+ (void)printPropertyWithDict:(NSDictionary *)dict;

@end
