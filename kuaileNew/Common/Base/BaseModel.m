//
//  BaseModel.m
//  MyAi-Xianmian
//
//  Created by qianfeng on 14-10-22.
//  Copyright (c) 2014年 Guo. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+ (NSMutableArray *)parsingJSonWithData:(NSData *)data
{
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictResult = (NSDictionary *)result;
        NSArray *homePageArray = dictResult[@"data"];
        for (NSDictionary *dict in homePageArray) {
             id model = [[self alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [array addObject:model];
        }
    }
    return array;
}

+ (id)parsingJSonForModelWithData:(NSData *)data
{
    DLog(@"子类未实现",nil);
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
