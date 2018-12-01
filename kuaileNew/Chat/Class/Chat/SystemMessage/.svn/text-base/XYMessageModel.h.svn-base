//
//  XYMessageModel.h
//  yinliaopifa
//
//  Created by 肖兰月 on 2016/12/7.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYKit.h"
@class XYMessageModel;

@class ORparentManageModel;

@interface ORParentModel : NSObject

@property (nonatomic, strong) NSMutableArray <XYMessageModel *> *comment_notice;
@property (nonatomic, strong) NSMutableArray <XYMessageModel *> *account_notice;//301
@property (nonatomic, strong) NSMutableArray <XYMessageModel *> *reply_notice;//303
@property (nonatomic, strong) NSMutableArray <XYMessageModel *> *system_notice;//101
@property (nonatomic, strong) NSMutableArray <XYMessageModel *> *work_notice;//201
@property (nonatomic, strong) NSMutableArray <XYMessageModel *> *zan_notice;//302


+ (instancetype)model;

- (void)saveData;

- (void)saveDataWithType:(NSString *)type;

+ (instancetype)readData;

+ (void)removeMsgWithID:(NSString *)dataId;

+ (NSString *)getMids;

+ (void)updateWithModel:(ORParentModel *)model;

@end



@interface ORparentManageModel : NSObject

@property (nonatomic, strong) XYMessageModel *lastModel;
@property (nonatomic, assign) NSInteger unreadCount;

@property (nonatomic, assign) BOOL isReadNil;

+ (NSArray<ORparentManageModel *> *)manageModelWith:(ORParentModel *)model isLocal:(BOOL)isLocal;

+ (NSInteger)unreadCountsWith:(NSArray<ORparentManageModel *> *)models;
+ (void)saveUnReadCount;


@end


@interface XYMessageModel : NSObject<NSCoding>

@property (nonatomic, copy) NSNumber *mid; //
@property (nonatomic, copy) NSString *title; //
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *uname;
@property (nonatomic, copy) NSString *uavatar; //
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *data_type; //
@property (nonatomic, copy) NSString *data_id;
@property (nonatomic, copy) NSString *content;//
@property (nonatomic, copy) NSString *data;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *data_avatar;

@property (nonatomic, copy) NSString * images; //


@property (nonatomic, copy) NSString *create_at;//
@property (nonatomic, copy) NSString *updated_at;//
@property (nonatomic, copy) NSString *message_id;
@property (nonatomic, copy) NSString *buid;
@property (nonatomic, copy) NSString *link_url; //
@property (nonatomic, strong) NSNumber *is_read;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat nameWidth;
@property (nonatomic, copy) NSString *update_at;//

@property (nonatomic, copy) NSString *unickname; //
@property (nonatomic, copy) NSString *html; //



@property (nonatomic, strong) NSDictionary *data_content;

//data_content

//@property (nonatomic, copy) NSString *create_at;

/*
 content = 1111122;
 "created_at" = 1473824359;
 data = "";
 "data_id" = "";
 "data_type" = "";
 "link_url" = "";
 mid = 43;
 title = "\U6d4b\U8bd5\U63a8\U9001\U6d88\U606f1111";
 type = 1;
 uavatar = "";
 uid = "";
 uname = "";
 "updated_at" = 1473824359;
 */

/*
 
 content = "\U4e00\U5b57\U9a6cs";
 "create_at" = 1490666443;
 "data_content" = "<null>";
 "data_type" = 101;
 images = "";
 "link_url" = "www.baidu.com";
 mid = 71;
 title = "\U7cfb\U7edf\U6d88\U606f";
 type = 1;
 uavatar = "http://wx.qlogo.cn/mmopen/QRaX7icguXSRVWCdfKZ33UIK5DExMKrqKVdP8nPTr1atJM8oUGnP4uuWoYNAZpj01wZPtVZia66avl8bBXQ9VcvRcxhJZoXs2J/0";
 uid = 19479;
 unickname = "\U67d1\U6a58\U67e0\U6aac";
 "update_at" = 1490666443;

 */


//+ (NSArray <XYMessageModel *> *)modelWithDataArray:(NSArray *)data;


@end
