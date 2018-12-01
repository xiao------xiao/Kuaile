//
//  XYShowCallView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/7.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYShowCallView.h"

@implementation XYShowCallView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XYShowCallView" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.conView.layer.cornerRadius = 6;
    self.conView.clipsToBounds = YES;
}

- (IBAction)coverBtnClick:(id)sender {
    if (self.coverClickBlock) {
        self.coverClickBlock();
    }
}


@end
