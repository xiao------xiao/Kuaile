//
//  TZPreviewResumeController.m
//  kuaile
//
//  Created by 谭真 on 15/10/24.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "TZPreviewResumeController.h"

@interface TZPreviewResumeController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation TZPreviewResumeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预览简历";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:ApiViewResume,self.resume_id]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

@end
