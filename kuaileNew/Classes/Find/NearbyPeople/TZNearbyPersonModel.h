//
//  TZNearbyPersonModel.h
//  kuaile
//
//  Created by 谭真 on 15/10/25.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TZNearbyPersonModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *last_login;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *username;
@end

/*
	avatar = <null>,
	uid = 14,
	distance = 0,
	nickname = 汪小舞,
	last_login = 1445740281,
	username = 18817325735,
	lng = 121.4927955266088,
	lat = 31.06903607276011,
	desc = 追求卓越，完善自我
 */