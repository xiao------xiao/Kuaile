//
//  ICELocationManager.m
//  kuaile
//
//  Created by ttouch on 15/10/23.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICELocationManager.h"

#define iOS8after [[[UIDevice currentDevice] systemVersion] floatValue] >= 8
@interface ICELocationManager ()<CLLocationManagerDelegate>
@end

@implementation ICELocationManager
- (void)startLocation {
    self.locationManager                 = [[CLLocationManager alloc] init];
    self.locationManager.delegate        = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter  = 5.0f;
    [self.locationManager startUpdatingLocation];
    
    if (iOS8after) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

#pragma mark - CLLocationManagerDelegate

// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [manager stopUpdatingLocation];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    
    // 保存经纬度信息
    [[NSUserDefaults standardUserDefaults] setObject:@(newLocation.coordinate.latitude) forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:@(newLocation.coordinate.longitude) forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
//            CLPlacemark *placemark = [array objectAtIndex:0];
//            NSString *whereStr = placemark.locality;
//            whereStr = [whereStr stringByReplacingOccurrencesOfString:@"市" withString:@""];
//            // 如果whereStr为空 做一些操作
//            if (whereStr == nil || [whereStr isEqualToString:@""] || whereStr.length < 1) {
//                whereStr = @"无锡";
//            }
            
            // 保存定位获得的用户城市信息
//            [[NSUserDefaults standardUserDefaults] setObject:whereStr forKey:@"userCity"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            // 发通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"didUpdateToLocation" object:self];
        }
    }];
    
    if (self.locationBlock) {
        self.locationBlock();
    }
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败, 错误: %@",error);
    if (self.locationBlockError) {
        self.locationBlockError();
    }
}

@end
