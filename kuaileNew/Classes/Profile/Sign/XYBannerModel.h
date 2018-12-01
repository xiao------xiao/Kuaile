//
//  XYBannerModel.h
//  yinliaopifa
//
//  Created by 肖兰月 on 2016/12/29.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYBannerModel : NSObject

@property (nonatomic, copy) NSString *brand_path;
@property (nonatomic, assign) NSInteger bid;
@property (nonatomic, copy) NSString *gids;
@end


//banner = [
//{
//    brand_base_path = https://app.ttouch.com.cn/drink/storage/web/source,
//    brand_path = 1/bVKtt2HRU1NXC0jVn8mz15lIyxy3unJc.jpeg,
//    gids = 4,3,
//    created_at = 1482904696,
//    updated_at = 1482904749,
//    bid = 2,
//    brand_name = 第二个
//},
