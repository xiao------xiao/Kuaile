//
//  TZVisitorModel.h
//  kuaile
//
//  Created by liujingyi on 15/9/23.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TZVisitorModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *company_industry;
@property (nonatomic, copy) NSString *star;
@property (nonatomic, copy) NSString *uid;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
