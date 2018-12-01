//
//  TZMapManager.m
//  刷刷
//
//  Created by 谭真 on 16/2/4.
//  Copyright © 2016年 圣巴(上海)文化传播有限公司. All rights reserved.
//

#import "TZMapManager.h"

@implementation TZMapManager

/*
/// 计算卡路里消耗 1. mileage:公里 2. speed:分钟/公里
+ (NSString *)getCalorieWithMileage:(NSString *)mileage speed:(NSString *)speed {
    // 轮滑的卡路里消耗 44大卡/km
    // 跑步           88大卡/km
    
    // 1. 卡路里消耗数 = 公里数 * 44
    CGFloat calorieF = mileage.floatValue * 44;
    // 2. 根据速度的不同，乘以一定的系数
    if (speed.floatValue >= 10) {
        calorieF = calorieF * 0.7;
    } else if (speed.floatValue >= 7) {
        calorieF = calorieF * 0.8;
    } else if (speed.floatValue >= 5) {
        calorieF = calorieF * 0.9;
    } else if (speed.floatValue >= 3) {
        calorieF = calorieF * 1.1;
    } else {
        calorieF = calorieF * 1.3;
    }
    NSString *calorie = [NSString stringWithFormat:@"%.2f",calorieF];
    return calorie;
}

/// 计算两点的空间距离
+ (NSString *)getDistanceWithPoint1:(BMKMapPoint)point1 point2:(BMKMapPoint)point2 {
    CLLocationDistance locationDistance = BMKMetersBetweenMapPoints(point1,point2);
    NSString *distance = [NSString stringWithFormat:@"%.2f",locationDistance];
    NSRange range = [distance rangeOfString:@"."];
    if (range.location > 2) { // km
        distance = [NSString stringWithFormat:@"%.2f",locationDistance / 1000.0];
        distance = [distance stringByAppendingString:@"km"];
    } else { // m
        distance = [NSString stringWithFormat:@"%.0f",locationDistance];
        distance = [distance stringByAppendingString:@"m"];
    }
    return distance;
}
 */

/// 地理编码：地名—>经纬度坐标
+ (void)geocodeWithAddress:(NSString *)address completion:(void (^)(NSDictionary *))completion{
    __block NSDictionary *locationDict =  @{@"lat":[mUserDefaults objectForKey:@"lat"],@"lng":[mUserDefaults objectForKey:@"lng"]};
    if (address.length < 1) { completion(locationDict); return; }
    // 调用下面的方法开始编码，不管编码是成功还是失败都会调用block中的方法
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //如果有错误信息，或者是数组中获取的地名元素数量为0，那么说明没有找到
        if (error || placemarks.count==0) {
            NSLog(@"地理编码错误：%@",error.localizedDescription);
        } else {
            /* name:名称 locality:城市 country:国家  postalCode:邮政编码  */
            for (CLPlacemark *placemark in placemarks) {
                NSLog(@"name=%@ locality=%@ country=%@ postalCode=%@",placemark.name,placemark.locality,placemark.country,placemark.postalCode);
            }
            // 取出获取的地理信息数组中的第一个
            CLPlacemark *firstPlacemark = [placemarks firstObject];
            CLLocationDegrees latitude = firstPlacemark.location.coordinate.latitude;   // 纬度
            CLLocationDegrees longitude = firstPlacemark.location.coordinate.longitude; // 经度
            locationDict = @{@"lat":[NSString stringWithFormat:@"%f",latitude],@"lng":[NSString stringWithFormat:@"%f",longitude]};
            if (completion) {
                completion(locationDict);
            }
        }
    }];
}

@end
