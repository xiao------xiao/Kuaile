//
//  ICELocationManager.m
//  DemoProduct
//
//  Created by ttouch on 15/11/9.
//  Copyright © 2015年 iCE. All rights reserved.
//

#import "ICELocationManagerNEW.h"

@interface ICELocationManagerNEW () <CLLocationManagerDelegate>
@property (nonatomic, copy)     NSString            *addressString;
@property (nonatomic, strong)   CLLocationManager   *locationManager;

@end

@implementation ICELocationManagerNEW

+ (id)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (void)startLocation {
    if([CLLocationManager locationServicesEnabled]){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 1;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation; //kCLLocationAccuracyBest;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
        [_locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __weak typeof(self) weakSelf = self;
    // 根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error) {
         if (!error && array.count > 0) {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             NSLog(@"\n name:%@\n  country:%@\n postalCode:%@\n ISOcountryCode:%@\n ocean:%@\n inlandWater:%@\n locality:%@\n subLocality:%@\n administrativeArea:%@\n subAdministrativeArea:%@\n thoroughfare:%@\n subThoroughfare:%@\n",
                   placemark.name,
                   placemark.country,
                   placemark.postalCode,
                   placemark.ISOcountryCode,
                   placemark.ocean,
                   placemark.inlandWater,
                   placemark.administrativeArea,
                   placemark.subAdministrativeArea,
                   placemark.locality,
                   placemark.subLocality,
                   placemark.thoroughfare,
                   placemark.subThoroughfare
                   );
             // 将获得的所有信息
             weakSelf.addressString = placemark.name;
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             NSLog(@"city = %@", city);
             
             if (_delegate && [_delegate respondsToSelector:@selector(getLocationLatitude:longitude:andAddress:)]) {
                 [_delegate getLocationLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude andAddress:_addressString];
             }
         }
     }];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败, 错误: %@",error);
    if (_delegate && [_delegate respondsToSelector:@selector(getLocationFail)]) {
        [_delegate getLocationFail];
    } else {
        // [self showHint:@"坐标获取失败!"];
    }
}

@end
