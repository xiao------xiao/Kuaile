//
//  ICEToolManager.h
//  ZhangChu
//
//  Created by 陈冰 on 15/1/23.
//  Copyright (c) 2015年 Glacier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICEToolManager : NSObject

/**
 *  ICEToolManager 单例对象
 */
+ (ICEToolManager *)sharedToolManager;

/**
 *  获取 ViewController（对应视图控制器）对应存储了数据的字典
 */
- (NSDictionary *)getRespondingDictionaryWithController:(UIViewController *)viewController;

/**
 *  获取 aClass（对应类）对应存储了数据的字典
 */
- (NSDictionary *)getRespondingDictionaryWithControllerClass:(Class)aClass;

/**
 *  依靠操作系统版本号，来确定是否需要增加高度
 */
+ (CGFloat)getHeightForiOS;

/**
 *  计算多大文字的的情况下，label大小
 *
 *  @param str  需要计算的字符串
 *  @param font 字体大小
 *  @param size 计算的size高度
 *
 *  @return label的rect大小
 */
+ (CGRect)sizeWithStr:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size;

/**
 *  一串文字的在一定宽度下的高度
 *
 *  @param labelStr   需要计算的字符串
 *  @param fontNum    字体号数
 *  @param labelWidth 字符串宽度
 *
 *  @return label的高度 默认会在基本的数据上＋2 防止被切割
 */
+ (CGFloat)heightWithLabelString:(NSString *)labelStr andFontNum:(CGFloat)fontNum andWidth:(CGFloat)labelWidth;

/**
 *  判读邮箱是否正确
 *
 *  @param candidate 需要验证的邮箱字符串
 *
 *  @return 是否符合要求
 */
+ (BOOL)validateEmail:(NSString *)candidate;


/**
 *  根据string和index获取一个codeString, 插入标识符号
 *
 *  @param string URL
 *  @param index  索引位置
 *
 *  @return 可以编码字符串
 */
- (NSString *)getQRCodeStringWithUrl:(NSString *)string indexOfModel:(NSInteger)index;

/**
 *  验证这个标识符号是否存在
 *
 *  @param codeString 需要验证的字符串
 *
 *  @return YES表示存在，NO表示不存在
 */
- (BOOL)isQRCodeStringFitForApp:(NSString *)codeString;

/**
 *  将唯一标识别符号拆开，只获取URL
 *
 *  @param codeString 需要验证的字符串
 *
 *  @return URL
 */
- (NSString *)getUrlFromQRCodeString:(NSString *)codeString;


+ (NSString *)intToZH:(NSInteger)num;
@end
