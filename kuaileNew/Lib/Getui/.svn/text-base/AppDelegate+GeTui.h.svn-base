//
//  AppDelegate+GeTui.h
//  kuaile
//
//  Created by ttouch on 15/9/15.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (GeTui)

- (void)initGeTui:(NSDictionary *)launchOptions;

/// 注册推送成功
- (void)geTuiApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

/// 注册推送失败
- (void)geTuiApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error;

@end
