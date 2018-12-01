//
//  UIWebView+ClearBackground.m
//  Lvmm
//
//  Created by zhouyi on 13-5-10.
//  Copyright (c) 2013年 Lvmama. All rights reserved.
//

#import "UIWebView+Utils.h"

@implementation UIWebView (Utils)

#pragma mark - ClearBackground

+ (void)webViewWithNumber:(NSString *)number{
    UIWebView *webView = [[UIWebView alloc] init];
    NSString *urlStr = [NSString stringWithFormat:@"tel://%@",number];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [[UIApplication sharedApplication].keyWindow addSubview:webView];
}

// 去掉UIWebView上下滚动出边界时的黑色阴影
- (void)clearWebViewBackgroundWithColor{
    for (UIView *view in [self subviews]){
        if ([view isKindOfClass:[UIScrollView class]]){
            for (UIView *shadowView in view.subviews){
                // 上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
                if ([shadowView isKindOfClass:[UIImageView class]]){
                    shadowView.hidden = YES;
                }
            }
        }
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self clearWebViewBackgroundWithColor];
}

#pragma mark - VideoControl

- (BOOL)hasVideo {
    __block BOOL hasVideoTag = NO;
    NSString * hasVideoTestString = @"document.documentElement.getElementsByTagName(\"video\").length";
    NSString * result = [self stringByEvaluatingJavaScriptFromString:hasVideoTestString];
    hasVideoTag = [result integerValue] >= 1? YES : NO;
    return hasVideoTag;
}

- (NSString *)getVideoTitle {
    __block NSString * title = nil;
    NSString *currentURL = [self stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    title = [self stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"++++ URL:%@",currentURL);
    NSLog(@"++++ title:%@", title);
    return title;
}

- (double)getVideoDuration {
    __block double duration = 0;
    if ([self hasVideo]) {
        NSString * requestDurationString = @"document.documentElement.getElementsByTagName(\"video\")[0].duration.toFixed(1)";
        NSString * result = [self stringByEvaluatingJavaScriptFromString:requestDurationString];
        NSLog(@"+++ Web Video Duration:%@",result);
        duration = [result doubleValue];
    }
    return duration;
}

- (double)getVideoCurrentTime {
    __block double currentTime = 0;
    if ([self hasVideo]) {
        NSString * requestDurationString = @"document.documentElement.getElementsByTagName(\"video\")[0].currentTime.toFixed(1)";
        NSString * result = [self stringByEvaluatingJavaScriptFromString:requestDurationString];
        NSLog(@"+++ Web Video CurrentTime:%@",result);
        currentTime = [result doubleValue];
    }
    return currentTime;
}

- (int)play {
    if ([self hasVideo]) {
        NSString * requestDurationString = @"document.documentElement.getElementsByTagName(\"video\")[0].play()";
        [self stringByEvaluatingJavaScriptFromString:requestDurationString];
    }
    return 0;
}

- (int)pause {
    if ([self hasVideo]) {
        NSString * requestDurationString = @"document.documentElement.getElementsByTagName(\"video\")[0].pause()";
        [self stringByEvaluatingJavaScriptFromString:requestDurationString];
    }
    return 0;
}

- (int)resume {
    if ([self hasVideo]) {
        NSString * requestDurationString = @"document.documentElement.getElementsByTagName(\"video\")[0].play()";
        [self stringByEvaluatingJavaScriptFromString:requestDurationString];
    }
    return 0;
}

- (int)stop {
    if ([self hasVideo]) {
        NSString * requestDurationString = @"document.documentElement.getElementsByTagName(\"video\")[0].pause()";
        [self stringByEvaluatingJavaScriptFromString:requestDurationString];
    }
    return 0;
}

@end
