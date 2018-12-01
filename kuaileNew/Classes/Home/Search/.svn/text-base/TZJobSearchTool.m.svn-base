//
//  TZJobSearchTool.m
//  HappyWork
//
//  Created by liujingyi on 15/9/11.
//  Copyright (c) 2015年 memberwine. All rights reserved.
//

#import "TZJobSearchTool.h"

#define TZSearchJobsFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"searchJobs.plist"]

@implementation TZJobSearchTool

+ (void)saveSearchJobs:(NSArray *)jobs {
    BOOL isArchiverSuccess = [NSKeyedArchiver archiveRootObject:jobs toFile:TZSearchJobsFilePath];
    if (isArchiverSuccess == NO) {
        NSLog(@"保存搜索记录记录失败");
    }
}

+ (NSArray *)SearchJobs {
    NSArray *jobs = [NSKeyedUnarchiver unarchiveObjectWithFile:TZSearchJobsFilePath];
    if (jobs == nil) {
        jobs = [NSArray array];
    }
    return jobs;
}

+ (void)addSearchJob:(NSString *)job {
    
    if ([job isEqualToString:@""] || job ==nil) return;
    NSMutableArray *jobs = [NSKeyedUnarchiver unarchiveObjectWithFile:TZSearchJobsFilePath];
    if (jobs == nil) {
        jobs = [NSMutableArray array];
    }
    
    NSMutableArray *jobs_copy = jobs;
    for (NSString *item_job in jobs_copy) {
        if ([item_job isEqualToString:job]) {
            [jobs removeObject:item_job];break;
        }
    }
    
    [jobs insertObject:job atIndex:0];
    if (jobs.count > 10) { // 最多保存10个
        [jobs removeLastObject];
    }
    [self saveSearchJobs:jobs];
}

+ (void)deleteSearchJobs {
    BOOL isArchiverSuccess = [NSKeyedArchiver archiveRootObject:nil toFile:TZSearchJobsFilePath];
    if (isArchiverSuccess == NO) {
        NSLog(@"清除搜索记录失败");
    }
}


@end
