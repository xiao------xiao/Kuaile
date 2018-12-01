//
//  AppDelegate+GeTui.m
//  kuaile
//
//  Created by ttouch on 15/9/15.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "AppDelegate+GeTui.h"
#import <UserNotifications/UserNotifications.h>

//------------------------------------
// 个推
//------------------------------------

static const CGFloat kDefaultPlaySoundInterval = 10.0;

#import "GeTuiSdk.h"
#define kAppId           @"GHKqfTtHZv9q9fYKPsKqE8"
#define kAppKey          @"Y71BiOKEki6Cx7LuMKui88"
#define kAppSecret       @"JiB1eEkOox9WsSHfxLSoI6"

NSString* const NotificationCategoryIdent  = @"ACTIONABLE";
NSString* const NotificationActionOneIdent = @"ACTION_ONE";
NSString* const NotificationActionTwoIdent = @"ACTION_TWO";


@interface AppDelegate () <GeTuiSdkDelegate> {

}
@property (assign, nonatomic) int lastPayloadIndex;

@end

@implementation AppDelegate (GeTui)

//----------------------------------------
// 个推
//----------------------------------------
#pragma mark -初始化个推
- (void)initGeTui:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
//    [GeTuiSdk startSdkWithAppId:kAppId appKey:kAppKey appSecret:kAppSecret delegate:self];
    //[2]:注册APNS
    [self registerRemoteNotification];
    
    // [ GTSdk ]：是否运行电子围栏Lbs功能和是否SDK主动请求用户定位
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
    
    // [ GTSdk ]：自定义渠道
//    [GeTuiSdk setChannelId:@"GT-Channel"];
    
    //［2-EXT]: 获取启动时收到的APN数据
    NSDictionary* message=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (message) {
        NSString*payloadMsg = [message objectForKey:@"payload"];
        NSString*record = [NSString stringWithFormat:@"[APN]%@,%@",[NSDate date],payloadMsg];
        NSLog(@"record00 = %@",record);
    }
}

- (void)registerRemoteNotification {
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        //IOS8 新的通知机制category注册
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"取消"];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:@"回复"];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:NotificationCategoryIdent];
        [actionCategory setActions:@[action1, action2]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                        UIUserNotificationTypeSound|
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                       UIRemoteNotificationTypeSound|
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                   UIRemoteNotificationTypeSound|
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif

}

#pragma mark 个推注册
///唤醒
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //[5] Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark 像APPLE请求Token



/// 请求Token
- (void)geTuiApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *strDeviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"deviceToken:%@", strDeviceToken);
    DEF_PERSISTENT_SET_OBJECT(strDeviceToken, DEF_DEVICETOKEN);
    // [3]:向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:strDeviceToken];
    DEF_PERSISTENT_SET_OBJECT([GeTuiSdk clientId], CLIENT_ID);
}

/// 如果APNS注册失败通知个推服务器
- (void)geTuiApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    //[3-EXT]:如果APNS注册失败，通知个推服务器
    [GeTuiSdk registerDeviceToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]];
}

/// 后台运行加载APNs传过来的数据
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark 启动GeTui
- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret {
    NSError *err = nil;
    //[1-1]:通过 AppId、 appKey 、appSecret 启动SDK
    
    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:self];
    //[1-2]:设置是否后台运行开关
    [GeTuiSdk runBackgroundEnable:YES];
    //[1-3]:设置电子围栏功能，开启LBS定位服务 和 是否允许SDK 弹出用户定位请求
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
}

- (void)stopSdk {
//    [GeTuiSdk enterBackground];
}

/// SDK启动成功返回clientId
#pragma mark - GeTuiSdkDelegate
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //[4-EXT-1]: 个推SDK已注册，返回clientId
    //获取完ClientID保存在本地
    DEF_PERSISTENT_SET_OBJECT(clientId, CLIENT_ID);
    if (DEF_PERSISTENT_GET_OBJECT(DEF_DEVICETOKEN))
    {
        [GeTuiSdk registerDeviceToken:DEF_PERSISTENT_GET_OBJECT(DEF_DEVICETOKEN)];
    }
}

/// ios的话 可以把要跳转的信息写到setpushinfo的payload里面 客户端收到payload之后去解析跳转 也可以把跳转信息放到透传消息里面 客户端收到透传之后解析跳转
#pragma mark -SDK收到透传消息回调

- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    if (payloadData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingAllowFragments error:nil];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            DLog(@"收到APNs推送消息 %@", dict);
            NSLog(@"%d",[mUserDefaults boolForKey:@"Foreground"]);

            if ([dict[@"data_type"] length] > 0) {
//                if ([mUserDefaults boolForKey:@"Foreground"]) {
////                    UITabBarController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
////                    vc.selectedIndex = 3;
//                    
//                    
//                    
//                }
                
                if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UITabBarController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
                        vc.selectedIndex = 3;
                        
                    });
                     [[NSNotificationCenter defaultCenter] postNotificationName:kNotiSysMessageListchangeJump object:nil userInfo:dict];
                }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiSysMessageListchange object:nil userInfo:dict];
                }
                
                
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                });
                
            }            
            
            if ([dict[@"type"] integerValue] == 1 || [dict[@"data_type"] integerValue] == 401) {
                [mNotificationCenter postNotificationName:@"didEditUserInfoNoti" object:nil];
            }
            
            NSNumber *typeNum = [dict objectForKey:@"type"]; // type 1:求职者 2:业务员 3:全部
            
//            [self showNotificationWithMessage:dict];

            
//            if (typeNum.integerValue == 1 || typeNum.integerValue == 3) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSString *title = [dict objectForKey:@"title"];
//                    if ([title isEqualToString:@"系统消息"] || [title isEqualToString:@"求职意向"] || [title isEqualToString:@"抽奖提醒"] || [title isEqualToString:@"投递提醒"] || [title isEqualToString:@"职位推荐"]) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiTabBarItemShowNum object:@YES];
//                    }
//                });
//            }
        });
        

        
//        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
//        if (state != UIApplicationStateActive ) {
//            if ([TZUserManager isLogin]) {
//                UITabBarController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
//                [vc setSelectedIndex:3];
//            }
//        }else {
//            
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:dict[@"title"] message:[dict[@"content"] stringByAppendingString:@""] preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                UITabBarController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
//                [vc setSelectedIndex:3];
//            }]];
//            
//            [[UIViewController currentViewController] presentViewController:alert animated:YES completion:nil];
//        }

        
        // 如果程序在后台，推送一个本地通知
//        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
//        switch (state) {
//            case UIApplicationStateBackground: [self showNotificationWithMessage:dict]; break;
//            default: break;
//        }
    }
}


// SDK收到sendMessage消息回调
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    NSLog(@"record %ld",(long)record);
}

// SDK遇到错误回调
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //[EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"个推错误返回%ld %@",(long)error.code,error.localizedDescription);
}

// SDK运行状态通知
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    NSLog(@"%d",aStatus);
}

#pragma mark - 私有方法

// 发送本地推送
- (void)showNotificationWithMessage:(NSDictionary *)msgDict {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置通知的提醒时间
        notification.timeZone = [NSTimeZone localTimeZone]; // 使用本地时区
        notification.fireDate = [NSDate date];
        // 设置重复间隔
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:msgDict];
        notification.userInfo = userInfo;
        // 设置提醒的文字内容
        notification.alertBody   = msgDict[@"content"];
        notification.alertTitle = msgDict[@"title"];
        if (notification.alertBody.length > 40) {
            notification.alertBody = [notification.alertBody substringToIndex:39];
        }
        // iOS8.2及以上，才有alertTitle属性
//        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.2f) {
//            notification.alertTitle = msgDict[@"title"] ? msgDict[@"title"] : @"新消息";
//            if (msgDict[@"uname"]) {
//                notification.alertTitle = [NSString stringWithFormat:@"%@ %@",msgDict[@"uname"],msgDict[@"title"]];
//            }
//            if (notification.alertTitle.length > 15) {
//                notification.alertTitle = [notification.alertTitle substringToIndex:14];
//            }
//        }
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 将通知添加到系统中
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    
    
    // 发送本地推送
//    NSString *alertBody = [NSString stringWithFormat:@"%@", msgDict[@"content"] ? msgDict[@"content"] : @""];
//    if (NSClassFromString(@"UNUserNotificationCenter")) {
//        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
//        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
//        BOOL playSound = NO;
//        if (!self.lastPlaySoundDate || timeInterval >= kDefaultPlaySoundInterval) {
//            self.lastPlaySoundDate = [NSDate date];
//            playSound = YES;
//        }
//        if (playSound) {
//            content.sound = [UNNotificationSound defaultSound];
//        }
//        content.body = alertBody;
//        content.userInfo = msgDict;
//        NSString *mid = [NSString stringWithFormat:@"%@",msgDict[@"mid"]];
//        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:mid content:content trigger:trigger];
//        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
//    } else {
//        UILocalNotification *notification = [[UILocalNotification alloc] init];
//        if (!notification) return;
//        // 设置通知的提醒时间
//        notification.fireDate = [NSDate date]; // 触发通知的时间
//        // 设置提醒的文字内容
//        notification.alertBody = alertBody;
//        notification.timeZone = [NSTimeZone defaultTimeZone];
//        
//        notification.userInfo = msgDict;
//        // 8.2以后才有alertTitle
//        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.2f) {
//            notification.alertTitle = msgDict[@"title"] ? msgDict[@"title"] : @"新消息";
//        }
//        notification.soundName = UILocalNotificationDefaultSoundName;
//        // 将通知添加到系统中
//        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
//        [UIApplication sharedApplication].applicationIconBadgeNumber += 1;
//    }
}


@end
