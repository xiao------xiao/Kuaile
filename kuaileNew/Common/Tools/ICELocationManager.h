//
//  ICELocationManager.h
//  kuaile
//
//  Created by ttouch on 15/10/23.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef void(^ICELocationBlock)();
typedef void(^ICELocationBlockError)();

@interface ICELocationManager : NSObject

@property (nonatomic, copy) ICELocationBlock locationBlock;
@property (nonatomic, copy) ICELocationBlockError locationBlockError;
@property (nonatomic, strong) CLLocationManager *locationManager;

- (void)startLocation;

@end
