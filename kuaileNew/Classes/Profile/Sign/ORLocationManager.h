//
//  ORLocationManager.h
//  UTX
//
//  Created by 欧阳荣 on 2017/4/24.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>


@interface ORLocationManager : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D currentLocationCoordinate;
@property (nonatomic, assign) AMapLocationReGeocode *regeocode;

+ (instancetype)sharedLManager;

- (void)startLocationWithBlock:(void(^)(AMapLocationReGeocode *regeocode, CLLocationCoordinate2D coordinte, NSString *errmsg))locationBlock;

@end
