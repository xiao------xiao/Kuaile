//
//  ORLocationManager.m
//  UTX
//
//  Created by 欧阳荣 on 2017/4/24.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import "ORLocationManager.h"

@interface ORLocationManager    ()

@property (strong, nonatomic)AMapLocationManager *locationManager;//定位管理者

@end

@implementation ORLocationManager

+ (instancetype)sharedLManager {
    static ORLocationManager * manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ORLocationManager alloc] init];
    });
    return manager;
}

- (void)startLocationWithBlock:(void (^)(AMapLocationReGeocode *, CLLocationCoordinate2D, NSString *))locationBlock {
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        _currentLocationCoordinate = location.coordinate;
        _regeocode = regeocode;
        if (locationBlock) {
            locationBlock(regeocode, location.coordinate, error.localizedDescription);
        }
    }];
}


- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        //1.带逆地理信息的一次定位（返回坐标和地址信息）(百米)
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        //2.定位超时时间，最低2s，此处设置为2s
        _locationManager.locationTimeout = 2;
        //3.逆地理请求超时时间，最低2s，此处设置为2s
        _locationManager.reGeocodeTimeout = 2;
    }
    return _locationManager;
}

@end
