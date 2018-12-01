//
//  LocationDemoViewController.m
//  BaiduMapSdkSrc
//
//  Created by baidu on 13-4-15.
//  Copyright (c) 2013年 baidu. All rights reserved.
//
#import "LocationDemoViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@implementation LocationDemoViewController {
    bool isGeoSearch;
    BMKGeoCodeSearch* _geocodesearch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    _locService = [[BMKLocationManager alloc]init];
    _locService.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    _locService.distanceFilter = 3;
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    self.navigationController.fd_interactivePopDisabled     = NO;
    self.title = @"用户签到";
    [_locService startUpdatingLocation];
    
  
    _mapView.showsUserLocation = NO; // 先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;// 设置定位的状态
    _mapView.zoomLevel = 18;
    _mapView.showsUserLocation = YES;// 显示定位图层
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [sendButton setTitle:@"签到" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithRed:32 / 255.0 green:134 / 255.0 blue:158 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [sendButton addTarget:self action:@selector(backLocationInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:sendButton]];
}

- (void)onClickReverseGeocode {
    isGeoSearch = false;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    if (self.userLocationInfo.location != nil) {
        pt = (CLLocationCoordinate2D){
            self.userLocationInfo.location.coordinate.latitude,
            self.userLocationInfo.location.coordinate.longitude
        };
    }
    
    BMKReverseGeoCodeSearchOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeocodeSearchOption.location = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag) {
        DLog(@"反geo检索发送成功");
    } else {
        DLog(@"反geo检索发送失败");
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        if (self.didGetLocationInfoBlock) {
            double lat = self.userLocationInfo.location.coordinate.latitude;
            double lng = self.userLocationInfo.location.coordinate.longitude;
            self.didGetLocationInfoBlock(lat,lng,result.address);
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"地址解析失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }
}

- (void)backLocationInfo {
    [_locService stopUpdatingLocation];
    _mapView.showsUserLocation = NO;
    [self onClickReverseGeocode];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _geocodesearch.delegate = nil; // 不用时，置nil
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    [_mapView updateLocationData:userLocation];
    self.userLocationInfo = userLocation;
    
    DLog(@"heading is %@",userLocation.heading);
    DLog(@"%@", userLocation.location);
}

/**
 * 用户位置更新后，会调用此函数
 * @param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [_mapView updateLocationData:userLocation];
    self.userLocationInfo = userLocation;
    DLog(@"%@", userLocation.location);
}

/**
 * 定位失败后，会调用此函数
 * @param mapView 地图View
 * @param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    DLog(@"location error");
}

- (void)dealloc {
    if (_geocodesearch != nil) { _geocodesearch = nil; }
    if (_mapView) { _mapView = nil; }
}

@end
