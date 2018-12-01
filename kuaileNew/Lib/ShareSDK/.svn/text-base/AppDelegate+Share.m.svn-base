//
//  AppDelegate+Share.m
//  kuaile
//
//  Created by ttouch on 15/9/16.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "AppDelegate+Share.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <ShareSDK+InterfaceAdapter.h>

/***
 腾讯开发平台：账号3315872098
 密码：r1s7GOu8Bo
 
 新浪开发平台：账号wesker.zhou@webrain.com.cn
 密码：r1s7GOu8Bo
 
 微信开发平台账号：hap-job@webrain.com.cn
 密码：82111770
 */

@implementation AppDelegate (Share)

- (void)initShare {

    [ShareSDK registerApp:@"b53aad29c3a8"];
    
    //添加新浪微博应用 注册网址 http://open.weibo.com  wdl@pmmq.com 此处需要替换成自己应用的
    [ShareSDK connectSinaWeiboWithAppKey:@"4000600220"
                               appSecret:@"1118596252fb93abe41b8ac06e33da04"
                             redirectUri:@"http://tongyu.com.cn"];
    
    //添加腾讯微博应用
    [ShareSDK connectTencentWeiboWithAppKey:@"1104843227"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"];
    
    //添加QQ空间应用 注册网址  http://connect.qq.com/intro/login/ wdl@pmmq.com 此处需要替换成自己应用的
    [ShareSDK connectQZoneWithAppKey:@"1104952059"
                           appSecret:@"S3aBkmvoSgzHAWMB"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用 该参数填入申请的QQ AppId wdl@pmmq.com 此处需要替换成自己应用的
    [ShareSDK connectQQWithQZoneAppKey:@"1104952059"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectWeChatWithAppId:@"wxeb8c2418a8ace030"
                           appSecret:@"d4624c36b6795d1d99dcf0547af5443d"
                           wechatCls:[WXApi class]];
    
    // [ShareSDK connectWeChatWithAppId:@"wxeb8c2418a8ace030"
    //                       wechatCls:[WXApi class]];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    if ([url.scheme isEqualToString:@"tongyu.com.cn://tongyu.com.cn"]) {
        return YES;
    }
    
    return [ShareSDK handleOpenURL:url wxDelegate:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"tongyu.com.cn://tongyu.com.cn"]) {
        return YES;
    }
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:nil];
}

#pragma mark - WXApiDelegate

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
//-(void) onReq:(BaseReq*)req{
//    
//}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
//-(void) onResp:(BaseResp*)resp{
//    
//}

@end
