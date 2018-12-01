//
//  XYMapResultModel.h
//  kuaile
//
//  Created by 肖兰月 on 2017/5/7.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AMapSearchKit/AMapSearchKit.h>


@interface XYMapResultModel : NSObject

@property (nonatomic, copy)   NSString     *uid;
///名称
@property (nonatomic, copy)   NSString     *name;
///兴趣点类型
@property (nonatomic, copy)   NSString     *type;
///类型编码
@property (nonatomic, copy)   NSString     *typecode;
///经纬度
@property (nonatomic, copy)   AMapGeoPoint *location;
///地址
@property (nonatomic, copy)   NSString     *address;


@end

//address = "\U671d\U9633\U95e8\U5317\U5927\U88578\U53f7";
//adname = "\U4e1c\U57ce\U533a";
//"biz_ext" =     (
//);
//"biz_type" =     (
//);
//cityname = "\U5317\U4eac\U5e02";
//distance =     (
//);
//id = B000A7OZT3;
//importance =     (
//);
//location = "116.436073,39.931339";
//name = "\U5bcc\U534e\U5927\U53a6F\U5ea7";
//pname = "\U5317\U4eac\U5e02";
//poiweight =     (
//);
//shopid =     (
//);
//shopinfo = 0;
//tel = "010-65543181";
//type = "\U5546\U52a1\U4f4f\U5b85;\U697c\U5b87;\U5546\U52a1\U5199\U5b57\U697c";
//typecode = 120201;
