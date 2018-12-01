//
//  XYMapViewController.h
//  kuaile
//
//  Created by 肖兰月 on 2017/5/7.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "TZBaseViewController.h"

typedef NS_ENUM(NSInteger, XYMapViewControllerType) {
    XYMapViewControllerTypeShow, // 只是展示地图
    XYMapViewControllerTypeCanHandle, // 可以操作
};

@interface XYMapViewController : TZBaseViewController

@property (nonatomic, assign) XYMapViewControllerType type;

@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;

@property (nonatomic, copy) NSString *searchWord;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) void (^didSelecteAddressBlock)(NSString *address);
@end
