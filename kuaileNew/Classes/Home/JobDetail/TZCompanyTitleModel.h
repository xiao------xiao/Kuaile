//
//  TZCompanyTitleModel.h
//  kuaile
//
//  Created by liujingyi on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TZCompanyTitleModel : NSObject

@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;

/** 通过认证 1  未通过 0   */
@property (nonatomic, strong) NSNumber *verify;

/** 公司名字 */
@property (nonatomic, copy) NSString *name;

/** 公司uid */
@property (nonatomic, copy) NSString *uid;

/** 公司规模 */
@property (nonatomic, copy) NSString *size;

/** 公司地址 */
@property (nonatomic, copy) NSString *street;

/** 公司简介 */
@property (nonatomic, copy) NSString *desc;

/** 公司类别 */
@property (nonatomic, copy) NSString *company_industry;

/** 公司星级 */
@property (nonatomic, copy) NSString *star;

/** 公司规模 */
@property (nonatomic, copy) NSString *company_scope;

/** 公司性质 */
@property (nonatomic, copy) NSString *company_property;

/** 公司logo */
@property (nonatomic, copy) NSString *logo;

/** 公司联系人 */
//@property (nonatomic, copy) NSString *contact_person;

/** 公司联系人电话 */
//@property (nonatomic, copy) NSString *contact_tel;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
