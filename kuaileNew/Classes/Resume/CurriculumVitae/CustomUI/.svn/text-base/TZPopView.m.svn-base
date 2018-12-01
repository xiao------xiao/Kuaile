//
//  TZPopView.m
//  kuaile
//
//  Created by liujingyi on 15/9/18.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZPopView.h"

@implementation TZPopView

- (IBAction)buttonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(popViewDidClickButton:)]) {
        [self.delegate popViewDidClickButton:sender.tag];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZPopView" owner:self options:nil] lastObject];
    }
    return self;
}

@end
