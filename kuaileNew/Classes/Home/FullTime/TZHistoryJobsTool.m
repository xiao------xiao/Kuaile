//
//  TZHistoryJobsTool.m
//  HappyWork
//
//  Created by liujingyi on 15/9/11.
//  Copyright (c) 2015年 memberwine. All rights reserved.
//

#import "TZHistoryJobsTool.h"

#define TZHistoryJobsFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"historyJobs.plist"]

@implementation TZHistoryJobsTool

+ (void)saveHistoryJobs:(NSArray *)jobs {
    BOOL isArchiverSuccess = [NSKeyedArchiver archiveRootObject:jobs toFile:TZHistoryJobsFilePath];
    if (isArchiverSuccess == NO) {
        NSLog(@"保存历史职位记录失败");
    }
}

+ (NSArray *)historyJobs {
    NSArray *jobs = [NSKeyedUnarchiver unarchiveObjectWithFile:TZHistoryJobsFilePath];
    if (jobs == nil) {
        jobs = [NSArray array];
    }
    return jobs;
}

+ (void)addHistoryJob:(NSDictionary *)job {
    
    if ([job[@"title"] isEqualToString:@""] || job == nil) return;
    NSMutableArray *jobs = [NSKeyedUnarchiver unarchiveObjectWithFile:TZHistoryJobsFilePath];
    if (jobs == nil) {
        jobs = [NSMutableArray array];
    }
    
    NSMutableArray *jobs_copy = jobs;
    for (NSDictionary *item_job in jobs_copy) {
        if ([item_job[@"title"] isEqualToString:job[@"title"]]) {
            [jobs removeObject:item_job];break;
        }
    }
    
    [jobs insertObject:job atIndex:0];
    if (jobs.count > 6) { // 最多保存6个
        [jobs removeLastObject];
    }
    [self saveHistoryJobs:jobs];
}

+ (void)deleteHistoryJobs {
    BOOL isArchiverSuccess = [NSKeyedArchiver archiveRootObject:nil toFile:TZHistoryJobsFilePath];
    if (isArchiverSuccess == NO) {
        NSLog(@"清除历史职位记录失败");
    }
}


@end
