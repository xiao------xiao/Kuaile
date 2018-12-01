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

#import <UIKit/UIKit.h>
#import "MainTabViewController.h"
#import "ApplyViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, IChatManagerDelegate> {
    CLLocationManager *locationManager; // 定位分类里用到
    EMConnectionState _connectionState;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL justLaunch;
@property (strong, nonatomic) MainTabViewController *mainController;
@property (nonatomic, strong) UIImageView *splashView;

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end
