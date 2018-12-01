//
//  TZJobSearchTool.h
//  HappyWork
//
//  Created by liujingyi on 15/9/11.
//  Copyright (c) 2015年 memberwine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TZJobSearchTool : NSObject

+ (void)saveSearchJobs:(NSArray *)jobs;

+ (NSArray *)SearchJobs;

+ (void)addSearchJob:(NSString *)job;

+ (void)deleteSearchJobs;

@end
