//
//  ICELocationManager.h
//  DemoProduct
//
//  Created by ttouch on 15/11/9.
//  Copyright © 2015年 iCE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol ICELocationManagerDelegate <NSObject>

- (void)getLocationLatitude:(CGFloat)latitude
                  longitude:(CGFloat)longitude
                 andAddress:(NSString *)address;

- (void)getLocationFail;

@end

@interface ICELocationManagerNEW : NSObject

@property (nonatomic, assign) id<ICELocationManagerDelegate> delegate;

+ (id)sharedInstance;

- (void)startLocation;

@end
