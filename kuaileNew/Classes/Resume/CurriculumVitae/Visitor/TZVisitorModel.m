//
//  TZVisitorModel.m
//  kuaile
//
//  Created by liujingyi on 15/9/23.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZVisitorModel.h"

@implementation TZVisitorModel

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    TZVisitorModel *model = [[TZVisitorModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end
