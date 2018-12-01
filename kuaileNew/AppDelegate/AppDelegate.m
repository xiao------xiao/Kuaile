/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "AppDelegate.h"
#import "MainTabViewController.h"
#import "ICEFindViewController.h"
#import "TZFindHomeController.h"

#import "AppDelegate+EaseMob.h"
#import "AppDelegate+Location.h"
//#import "AppDelegate+HelpDesk.h"

#import "AppDelegate+GeTui.h"
#import "AppDelegate+Share.h"

#import "ZYHomeViewController.h"
#import "ICELoginViewController.h"
#import "TZNaviController.h"

#import "IQKeyboardManager.h"
#import "ChatListViewController.h"
#import "WZLBadgeImport.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <CrashMaster/CrashMaster.h>
#import <ShareSDK+InterfaceAdapter.h>
#import "WXApi.h"
#import <UserNotifications/UserNotifications.h>

#import <Bugly/Bugly.h>

BMKMapManager* _mapManager;

@interface AppDelegate () <UITabBarControllerDelegate, BMKGeneralDelegate,CrashMasterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    self.justLaunch = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.justLaunch = NO;
    });
    
//    [Bugly startWithAppId:@"fc9e7cca88"];    老版本

    [Bugly startWithAppId:@"06c296eed4"];
    
//        [NSThread sleepForTimeInterval:2.0];
    
    // JSPatch
    // [JSPatch testScriptInBundle];
//    [JSPatch setupUserData:@{@"uid":[mUserDefaults objectForKey:@"userUid"]}];
//    [JSPatch startWithAppKey:@"b396c9c918756fc4"];
//    [JSPatch sync];
    
    [WXApi registerApp:@"wxeb8c2418a8ace030"];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self configMainCtrl];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
   
    _connectionState = eEMConnectionConnected;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:KNOTIFICATION_LOGINCHANGE object:nil];

    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
    manager.toolbarDoneBarButtonItemText = @"";
    
    [TZEaseMobManager autoLogin];
    // 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    [self initGeTui:launchOptions];
    
    [self initShare];
    // 登录状态改变
    [self loginStateChange:nil];
    [self startLocation];
    
    // 高德地图
    [AMapServices sharedServices].apiKey = @"ec6c542ecc7faeaac443d9c2a0b74d67";
    
    // 要使用百度地图，请先启动BaiduMapManager
//    _mapManager = [[BMKMapManager alloc]init];
//    BOOL ret = [_mapManager start:@"N97izgk4myQ3RMzHcRYFmwN6" generalDelegate:self];
//    if (!ret) {
//        NSLog(@"manager start failed!");
//    }
    // 崩溃抓取
    CrashMasterConfig* config = [CrashMasterConfig defaultConfig];
    config.printLogForDebug = YES;
    // 初始化接口，appkey从网站新建应用获得，渠道号自行定义
    [CrashMaster init:@"4e894d060af27a74f073c802c54bd3a4" channel:@"AppStore" config:config];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    return YES;
}

/// 注册推送成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [self geTuiApplication:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

/// 注册推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [self geTuiApplication:application didFailToRegisterForRemoteNotificationsWithError:error];
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}


/// 远程推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (_mainController) {
        [_mainController didReceiveLocalNotification:userInfo];
    }
}

/// 本地推送
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (_mainController) {
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state != UIApplicationStateActive || self.justLaunch) {
            [_mainController didReceiveLocalNotification:notification.userInfo];
        }
    }
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    [[UIViewController currentViewController] showInfo:@"completionHandler"];
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state != UIApplicationStateActive) {
        // 处理APN
        if (_mainController) {
            [_mainController didReceiveLocalNotification:userInfo];
        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    if (_mainController) {
        NSDictionary *userInfo = response.notification.request.content.userInfo;
        [_mainController didReceiveLocalNotification:userInfo];
    }
    completionHandler();
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    
    [mUserDefaults setBool:YES forKey:@"Foreground"];
    NSLog(@"%d",[mUserDefaults boolForKey:@"Foreground"]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [mUserDefaults setBool:NO forKey:@"Foreground"];
    });
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [BMKMapView didForeGround];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [CrashMaster terminate];
}

- (void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        NSLog(@"联网成功");
    } else {
        NSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        NSLog(@"授权成功");
    } else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (void)configMainCtrl {
    _mainController = [[MainTabViewController alloc] init];
    _mainController.delegate = self;
    _mainController.tabBar.translucent = NO;
    self.window.rootViewController = _mainController;
    [self.window makeKeyAndVisible];
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

#pragma mark - private

- (void)loginStateChange:(NSNotification *)notification {
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    if (isAutoLogin || loginSuccess) { // 登陆成功加载主窗口控制器
        // 加载申请通知的数据
        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
    }
    
    if (!loginSuccess) { // 注销/退出登录
        [[ApplyViewController shareController] clear];
        // 设置全局单例对象登录信息
        ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
        userModel.hasHXLogin = NO;
        // 注销成功，把各种badgeView置为nil
        for (NSInteger i = 0; i < [UIViewController currentViewController].tabBarController.childViewControllers.count; i++) {
            UIViewController *vc = [UIViewController currentViewController].tabBarController.childViewControllers[i];
            vc.tabBarItem.badgeValue = nil;
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiTabBarItemShowNumSS object:nil];
    }
}

#pragma mark - 点击 判断登录
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    TZNaviController *naviCtrl = (TZNaviController *)viewController;
    id viewCtrl = [naviCtrl.viewControllers firstObject];
    if ([viewCtrl isKindOfClass:[ZYHomeViewController class]] || [viewCtrl isKindOfClass:[TZFindHomeController class]]) {
        return YES;
    }
    
    if ([TZUserManager isLogin]) {
        if ([viewCtrl isKindOfClass:[ChatListViewController class]]) {
            UITabBarItem *item = tabBarController.tabBar.items[3];
            [item clearBadge];
        }
    } else {
        return NO;
    }
    return YES;
}

@end
