//
//  TZBannerCell.h
//  刷刷
//
//  Created by ttouch on 16/7/10.
//  Copyright © 2016年 圣巴(上海)文化传播有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface TZBannerCell : UITableViewCell

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) NSArray *bannerModels;
@property (nonatomic, assign) NSInteger topInset;
@property (nonatomic, assign) NSInteger bottomInset;

@end


@interface TZBannerModel : NSObject
@property (nonatomic, copy) NSString *ads_id;
@property (nonatomic, copy) NSString *ads_title;
@property (nonatomic, copy) NSString *href;
@property (nonatomic, copy) NSString *img_path;
@property (nonatomic, copy) NSString *img_base_url;

@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *url;
@end

/*
 "ads_id": "29",
 "ads_title": "加拿大榜单，赶紧围观~",
 "href": "http:\/\/www.baidu.com\/",
 "img_path": "1\/RF4DQHllc9MVL04cEorS1G1SDS8LO1Gs.png",
 "img_base_url": "http:\/\/match.app.letusport.com\/storage\/web\/source"

 */
