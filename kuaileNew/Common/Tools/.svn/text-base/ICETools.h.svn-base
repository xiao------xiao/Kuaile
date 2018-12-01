//
//  ICETools.h
//  YiYuanYun
//
//  Created by 陈冰 on 15/5/12.
//  Copyright (c) 2015年 Glacier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICETools : NSObject

// 手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

// 银行卡号
+ (BOOL)validateBankCardNumber: (NSString *)bankCardNumber;

// 身份证
+ (BOOL)validateIDCard:(NSString *)iDCard;

/** 将UIColor变换为UIImage */
+ (UIImage *)imageCreateWithColor:(UIColor *)color;

// 时间戳转换标准时间
+ (NSString *)standardTime:(NSString *)timeStamp;

// 时间转换时间戳
+ (NSString *)timeStamp:(NSString *)standardTime;

// 2个坐标距离
+ (NSString *)locationWithLatitude:(NSString *)firstLatitude withLongitude:(NSString *)firstLongitude WithLatitude:(NSString *)secondLatitude withLongitude:(NSString *)secondLongitude;


+ (NSString *)AddressMessage:(NSString *)lat withlon:(NSString *)lon;
@end
