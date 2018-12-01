//
//  TZContactTool.m
//  QuestionBank
//
//  Created by 谭真 on 15/12/30.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import "TZContactTool.h"
#import "SGInfoAlert.h"

@implementation TZContactTool

+ (void)callPhone {
    [self callPhoneWithPhoneNumber:@"021-60495969"];
}

+ (void)callMobilePhone {
    [self callPhoneWithPhoneNumber:@"15800901272"];
}

+ (void)callPhoneWithPhoneNumber:(NSString *)phoneNumber {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:url]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
}

+ (void)copyServiceWechatNumber {
    [self copyString:@"18817834179"];
    [CommonTools showInfo:[NSString stringWithFormat:@"微信号:18817834179已复制到剪切板"]];
}

+ (void)copyPublicWechatNumber {
    [self copyString:@"huijiaxueche"];
    [CommonTools showInfo:[NSString stringWithFormat:@"微信号:huijiaxueche已复制到剪切板"]];
}

+ (void)copyString:(NSString *)string {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = string;
}

@end
