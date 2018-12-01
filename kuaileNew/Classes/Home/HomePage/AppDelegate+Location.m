//
//  AppDelegate+Location.m
//  kuaile
//
//  Created by liujingyi on 15/10/13.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "AppDelegate+Location.h"
#import <MapKit/MapKit.h>

@interface AppDelegate ()<CLLocationManagerDelegate>
@end

@implementation AppDelegate (Location)

- (void)startLocation {
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
}

#pragma mark - CLLocationManagerDelegate

// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [manager stopUpdatingLocation];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
      
    // 保存经纬度信息
    [[NSUserDefaults standardUserDefaults] setObject:@(newLocation.coordinate.latitude) forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:@(newLocation.coordinate.longitude) forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 保存 Device 的现语言 (英语 法语 ，，，)

    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSMutableArray
    *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                             objectForKey:@"AppleLanguages"];
    
    
    // 强制 成 简体中文
    [[NSUserDefaults
      standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",
                                       nil] forKey:@"AppleLanguages"];

    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *whereStr = placemark.locality;
            whereStr = [whereStr stringByReplacingOccurrencesOfString:@"市" withString:@""];
            // 如果whereStr为空 做一些操作
            if (whereStr == nil || [whereStr isEqualToString:@""] || whereStr.length < 1) {
                whereStr = @"无锡";
            }
            
            // 保存定位获得的用户城市信息
            [mUserDefaults setObject:whereStr forKey:@"userCity"];
            [mUserDefaults synchronize];
            // 发通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didUpdateToLocation" object:self];
        }
    }];
    // 还原Device 的语言
    [[NSUserDefaults
      standardUserDefaults] setObject:userDefaultLanguages
     forKey:@"AppleLanguages"];

}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败, 错误: %@",error);
}

@end
