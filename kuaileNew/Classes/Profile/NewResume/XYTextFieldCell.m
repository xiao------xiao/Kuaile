//
//  XYTextFieldCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/6/14.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYTextFieldCell.h"

@implementation XYTextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textFieldLeftMarginConstraint.constant = mScreenWidth * 0.36;
    self.codeBtn.layer.cornerRadius = 3;
    self.codeBtn.userInteractionEnabled = NO;
}


- (IBAction)codeBtnClick:(id)sender {
    if (self.didSendCodeBlock) {
       BOOL isCode =  self.didSendCodeBlock();
        if (!isCode) {
            return;
        }
    }
    __block NSInteger timeout= 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_TARGET_QUEUE_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeout <= 0) {
            // 倒计时结束，关闭
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.codeBtn.userInteractionEnabled = YES;
                [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"tapbackground"] forState:0];
                [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        } else {
            NSString *strTime = [NSString stringWithFormat:@"%ld秒", (long)timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.codeBtn.userInteractionEnabled = NO;
                [self.codeBtn setTitle:strTime forState:UIControlStateNormal];
                [self.codeBtn setBackgroundImage:nil forState:UIControlStateNormal];
                self.codeBtn.backgroundColor = TZColorRGB(245);
                [self.codeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}


@end
