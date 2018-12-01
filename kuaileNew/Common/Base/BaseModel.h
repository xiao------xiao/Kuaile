//
//  BaseModel.h
//  MyAi-Xianmian
//
//  Created by qianfeng on 14-10-22.
//  Copyright (c) 2014年 Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __string(__k__)             @property (nonatomic, copy)         NSString *__k__
#define __array(__k__)              @property (nonatomic, copy)         NSArray *__k__
#define __dictionary(__k__)         @property (nonatomic, copy)         NSDictionary *__k__
#define __number(__k__)             @property (nonatomic, strong)       NSNumber *__k__
#define __mutableString(__k__)      @property (nonatomic, strong)       NSMutableString *__k__
#define __mutableArray(__k__)       @property (nonatomic, strong)       NSMutableArray *__k__
#define __mutableDictionary(__k__)  @property (nonatomic, strong)       NSMutableDictionary *__k__
#define __interger(__k__)           @property (nonatomic, assign)       NSInteger __k__
#define __float(__k__)              @property (nonatomic, assign)       CGFloat __k__
#define __size(__k__)               @property (nonatomic, assign)       CGSize __k__

@interface BaseModel : NSObject

　
+ (NSMutableArray *)parsingJSonWithData:(NSData *)data;

+ (id)parsingJSonForModelWithData:(NSData *)data;

@end
