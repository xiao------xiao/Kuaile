//
//  XYChatSettingController.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/10.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "TZTableViewController.h"

@interface XYChatSettingController : TZTableViewController

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) void (^didHandleScreenBlock)(BOOL isScreen);
@property (nonatomic, copy) void (^didHandleAttentionBlock)(BOOL isAttented);

@end

@interface ORUserInfoModel : NSObject

@property (nonatomic, copy) NSString *attention_num;
@property (nonatomic, copy) NSString *fans_num;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *background;
@property (nonatomic, copy) NSString *banned;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *hometown;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *is_attention;

@property (nonatomic, copy) NSString *nickname;



@end
