//
//  public.h
//  乐游
//
//  Created by qianfeng on 14-11-5.
//  Copyright (c) 2014年 Guo. All rights reserved.
//

/**
 *  常用宏
 */
#ifndef ___public_h
#define ___public_h

#ifdef __OBJC__
    #import <UIKit/UIKit.h>
    #import <Foundation/Foundation.h>
#endif

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \



/** 内存管理 */
#if ! __has_feature(objc_arc) // Non-ARC
    #define ICEAutorelease(__v) ([__v autorelease]);
    #define ICEReturnAutoreleased ICEAutorelease
    #define ICERetain(__v) ([__v retain]);
    #define ICEReturnRetained FMDBRetain
    #define ICERelease(__v) if (__v != nil) {\
                                            [__v release];\
                                            __v = nil;\
                                            } else {\
                                            __v = nil;\
                                            }
    #define ICEDispatchQueueRelease(__v) (dispatch_release(__v));
#else // ARC
    #define ICEAutorelease(__v)
    #define ICEReturnAutoreleased(__v) (__v)
    #define ICERetain(__v)
    #define ICEReturnRetained(__v) (__v)
    #define ICERelease(__v)
#endif

/** 主要是警告信息，在非ARC项目中没有这个警告 消除:performSelector may cause a leak because its selector is unknown */
#define __kSuppressPerformSelectorLeakWarning(Stuff) \
    do { \
        _Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        Stuff; \
        _Pragma("clang diagnostic pop") \
    } while (0)

/************************************************************************************/
/** 获取设备系统版本号 */
#define __kDeviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]

/** 获取屏幕高宽 **/
#define __kScreenHeight [UIScreen mainScreen].bounds.size.height
#define __kScreenWidth [UIScreen mainScreen].bounds.size.width

/** 颜色信息 **/
#define __kColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define __kColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define __kColorWithRGBA1(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define __kNaviBarColor [UIColor colorWithRed:55/255.0 green:189/255.0 blue:243/255.0 alpha:1.0]

#define __kUIColorFromArc4random [UIColor colorWithRed:0.1+0.1*(arc4random()%10) green:0.1+0.1*(arc4random()%10) blue:0.1+0.1*(arc4random()%10) alpha:0.1+0.1*(arc4random()%10)]
/************************************************************************************/

typedef void(^completeResult)(id result);
typedef void(^failResult)(NSError* error);

//------------------------------------------------------------------------
//// 支付宝
//#import <AlipaySDK/AlipaySDK.h>
//#import "Order.h"
//#import "DataSigner.h"
////------------------------------------------------------------------------
//// 微信支付
//#import "getIPhoneIP.h"
//#import "DataMD5.h"
//#import <CommonCrypto/CommonDigest.h>
//#import "XMLDictionary.h"
//#import "AFNetworking.h"
//#import "WXApi.h"
//------------------------------------------------------------------------



//#import "ReactiveCocoa.h"// 响应式编程基础



#import "PublicColor.h"             // 颜色函数
#import "ICEPersistent.h"           // 存储KEY VALUE
#import "ICEMessage.h"              // 全局宏
#import "CMPopTipView.h"            // 指示器弹窗
#import "SGInfoAlert.h"             // 指示器
#import "MJExtension.h"             // JSON数据转换模型数据
#import "MJRefresh.h"               // 上下拉刷新
#import "UIImageView+WebCache.h"    // 图片缓存管理类
#import "interface.h"               // 接口
//#import "UIViewExt.h"               // 视图边界类
#import "ICEImporter.h"             // 网络回调接口
#import "GeTuiSdk.h"                // 个推
//#import "IQKeyboardManager.h"       // 智能键盘
#import "ICELoginUserModel.h"       // 用户信息类
#import "ICETools.h"                // 验证工具
#import "AFNetworking.h"
#import "Masonry.h"
#import "PublicView.h"
#import "UIButton+FillColor.h"
#endif



