//
//  LocationDemoViewController.h
//  BaiduMapSdkSrc
//
//  Created by baidu on 13-4-15.
//  Copyright (c) 2013年 baidu. All rights reserved.
//
#import <Foundation/Foundation.h>

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BMKLocationKit/BMKLocationComponent.h>
//#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface LocationDemoViewController :  UIViewController <BMKMapViewDelegate,BMKLocationManagerDelegate,BMKGeoCodeSearchDelegate>{
    IBOutlet BMKMapView* _mapView;
    BMKLocationManager* _locService;
}

@property (nonatomic, copy) void (^didGetLocationInfoBlock)(double lat,double lng,NSString *address);

@property (nonatomic, strong) BMKUserLocation *userLocationInfo;

@end

