//
//  TZMapManager.h
//  刷刷
//
//  Created by 谭真 on 16/2/4.
//  Copyright © 2016年 圣巴(上海)文化传播有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TZMapManager : NSObject

/*
/// 计算卡路里消耗 mileage:公里 speed:分钟/公里
+ (NSString *)getCalorieWithMileage:(NSString *)mileage speed:(NSString *)speed;

/// 获取两个坐标点的距离
+ (NSString *)getDistanceWithPoint1:(BMKMapPoint)point1 point2:(BMKMapPoint)point2;
 */

/// 地理编码：地名—>经纬度坐标
+ (void)geocodeWithAddress:(NSString *)address completion:(void (^)(NSDictionary *locationDict))completion;

@end
