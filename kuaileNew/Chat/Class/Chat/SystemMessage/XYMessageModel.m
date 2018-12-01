//
//  XYMessageModel.m
//  yinliaopifa
//
//  Created by 肖兰月 on 2016/12/7.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XYMessageModel.h"


@implementation ORParentModel

+ (instancetype)model {
    ORParentModel *model = [ORParentModel new];
    model.comment_notice = [NSMutableArray array];
    model.account_notice = [NSMutableArray array];
    model.reply_notice = [NSMutableArray array];
    model.system_notice = [NSMutableArray array];
    model.work_notice = [NSMutableArray array];
    model.zan_notice = [NSMutableArray array];
    return model;
}

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"comment_notice" : [XYMessageModel class],
             @"account_notice" : [XYMessageModel class],
             @"reply_notice" : [XYMessageModel class],
             @"system_notice" : [XYMessageModel class],
             @"work_notice" : [XYMessageModel class],
             @"zan_notice" : [XYMessageModel class]};
}

- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self modelCopy]; }



+ (NSString *)dataPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"orsysmsg.data"]];
}

+ (instancetype)readData {
    YYCache *cache = [[YYCache alloc] initWithName:@"cache"];
    ORParentModel *model = [cache objectForKey:[self cacheKey]];
    
    if (!model) {
        model = [ORParentModel model];
    }
    
    return model;
}

+ (void)removeMsgWithID:(NSString *)dataId {
    ORParentModel *model = [self readData];
    for (int i = 0; i < model.comment_notice.count; i ++ ) {
        if ([model.comment_notice[i].data_id isEqualToString:dataId]) {
            [model.comment_notice removeObject:model.comment_notice[i]];
            i --;
        }
    }
    for (int i = 0; i < model.zan_notice.count; i ++ ) {
        if ([model.zan_notice[i].data_id isEqualToString:dataId]) {
            [model.zan_notice removeObject:model.zan_notice[i]];
            i --;
        }
    }
    
//    [ORparentManageModel unreadCountsWith:[ORparentManageModel manageModelWith:model isLocal:YES]];
    YYCache *cache = [[YYCache alloc] initWithName:@"cache"];
    [cache setObject:model forKey:[self cacheKey]];
}

+ (void)updateWithModel:(ORParentModel *)model {
    YYCache *cache = [[YYCache alloc] initWithName:@"cache"];
    [cache setObject:model forKey:[self cacheKey]];
}

//+ (void)saveDataWith:(ORParentModel *)model {
//    
//}

//- (void)saveData {
//    ORParentModel *model = [ORParentModel readData];
//    
//    [model.comment_notice appendObjects:self.comment_notice];
//    [model.account_notice appendObjects:self.account_notice];
//    [model.reply_notice appendObjects:self.reply_notice];
//    [model.system_notice appendObjects:self.system_notice];
//    [model.work_notice appendObjects:self.work_notice];
//    [model.zan_notice appendObjects:self.zan_notice];
//
//    
//    YYCache *cache = [[YYCache alloc] initWithName:@"cache"];
//    [cache setObject:model forKey:@"orsysmsg"];
//
//}

- (void)saveDataWithType:(NSString *)type {
    
    ORParentModel *model = [ORParentModel readData];
    
    NSMutableArray<XYMessageModel *> *array = [model valueForKey:type];
    NSMutableArray<XYMessageModel *> *data = [self valueForKey:type];
//    [data reverse];
    
    //过滤
//    for (XYMessageModel *model in array) {
//        for (int i = 0; i < data.count; i ++) {
//            if (data[i].mid.integerValue == model.mid.integerValue) {
//                [data removeObjectAtIndex:i];
//                break;
//            }
//        }
//    }
    
    
    [array prependObjects:data];
    [data removeAllObjects];
    
//    [model.comment_notice appendObjects:self.comment_notice];
//    [model.account_notice appendObjects:self.account_notice];
//    [model.reply_notice appendObjects:self.reply_notice];
//    [model.system_notice appendObjects:self.system_notice];
//    [model.work_notice appendObjects:self.work_notice];
//    [model.zan_notice appendObjects:self.zan_notice];
    
    YYCache *cache = [[YYCache alloc] initWithName:@"cache"];
    [cache setObject:model forKey:[self cacheKey]];
    
}

+ (NSString *)cacheKey {
    return [NSString stringWithFormat:@"orsysmsg%@",[ICELoginUserModel sharedInstance].uid];
}

- (NSString *)cacheKey {
    return [NSString stringWithFormat:@"orsysmsg%@",[ICELoginUserModel sharedInstance].uid];
}

+ (instancetype)modelWithModel:(ORParentModel *)model {
    ORParentModel *aModel = [[ORParentModel alloc] init];
    aModel.system_notice = model.system_notice;
    aModel.comment_notice = model.comment_notice;
    aModel.work_notice = model.work_notice;
    aModel.reply_notice = model.reply_notice;
    aModel.account_notice = model.account_notice;
    aModel.zan_notice = model.zan_notice;
    return  aModel;

    
}

+ (NSString *)getMids {
    ORParentModel *model = [ORParentModel readData];
    NSMutableString *str = [NSMutableString string];
    
    NSMutableArray *data = [NSMutableArray arrayWithArray:model.system_notice];
    [data appendObjects:model.reply_notice];
    [data appendObjects:model.comment_notice];
    [data appendObjects:model.work_notice];
    [data appendObjects:model.account_notice];
    [data appendObjects:model.zan_notice];
    
    [data enumerateObjectsUsingBlock:^(XYMessageModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [str appendFormat:@"%@,",obj.mid];
        
    }];
    NSString *newstr = @"";
    if (str.length > 0) {
        newstr = [str substringToIndex:str.length-1];
    }
    NSLog(@"midS 11111111%@", str);
    return newstr;
    
}


@end

@implementation ORparentManageModel

+ (NSArray<ORparentManageModel *> *)manageModelWith:(ORParentModel *)model isLocal:(BOOL)isLocal{
        
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:6];
    [array addObject:[ORparentManageModel manageModelWithArray:model.system_notice isLocal:isLocal type:@"system_notice"]];
    [array addObject:[ORparentManageModel manageModelWithArray:model.work_notice isLocal:isLocal type:@"work_notice"]];
    [array addObject:[ORparentManageModel manageModelWithArray:model.account_notice isLocal:isLocal type:@"account_notice"]];
    [array addObject:[ORparentManageModel new]];
    [array addObject:[ORparentManageModel manageModelWithArray:model.comment_notice isLocal:isLocal type:@"comment_notice"]];
    [array addObject:[ORparentManageModel manageModelWithArray:model.zan_notice isLocal:isLocal type:@"zan_notice"]];
    
    [self unreadCountsWith:array];
    return [array copy];
    
}

+ (instancetype)manageModelWithArray:(NSArray *)array isLocal:(BOOL)isLocal type:(NSString *)type {
    ORparentManageModel *model = [[ORparentManageModel alloc] init];
    model.unreadCount = isLocal ? 0 : array.count;
    
    model.isReadNil = ![ORParentModel readData];
    
    if (array.count == 0) {
        NSArray *array1 = [[ORParentModel readData] valueForKey:type];
        model.lastModel = array1.lastObject;
    }else {
        model.lastModel = array.lastObject;
    }
    
    return model;
}

+ (NSInteger)unreadCountsWith:(NSArray<ORparentManageModel *> *)models {
    __block NSInteger unread = 0;
    
    if (models.count > 0) {
        [models enumerateObjectsUsingBlock:^(ORparentManageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            unread += obj.unreadCount;
        }];
    }else {
        unread = [[mUserDefaults objectForKey:@"unread"] integerValue];
    }
    
    [mUserDefaults setObject:@(unread) forKey:@"unread"];
    [mUserDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiSysMessageListchange object:nil userInfo:nil];
    return unread;
}

@end

@implementation XYMessageModel

- (NSString *)updated_at {
    return [CommonTools getTimeStrBytimeStamp:_update_at dateFormat:@"MM-dd HH:mm"];
}

- (NSString *)created_at {
    return [CommonTools getTimeStrBytimeStamp:_create_at dateFormat:@"MM-dd HH:mm"];
}

- (void)setTime:(NSString *)time {
    _time = time;
    if (!_create_at) {
        _create_at = time;
    }
    if (!_update_at) {
        _update_at = time;
    }
}

- (void)setContent:(NSString *)content {
    _content = content;
    NSInteger contentH = [CommonTools sizeOfText:content fontSize:13 width:mScreenWidth - 77].height + 1;
    _cellHeight = 85 + contentH;
}

- (NSNumber *)is_read {
    if (_is_read==nil) {
        _is_read = @0;
    }
    return _is_read;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@".....%@ %@ %@", _uid, _create_at, _unickname];
}

- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self modelCopy]; }



@end
