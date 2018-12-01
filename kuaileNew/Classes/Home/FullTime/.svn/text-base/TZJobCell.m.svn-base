//
//  TZJobCell.m
//  HappyWork
//
//  Created by liujingyi on 15/9/11.
//  Copyright (c) 2015年 memberwine. All rights reserved.
//

#import "TZJobCell.h"

@implementation TZJobCell

- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZJobCell" owner:self options:nil]lastObject];
    }
    return self;
}


- (void)awakeFromNib {
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = __kColorWithRGBA1(230, 230, 230);
    self.selectedBackgroundView = selectedBgView;
}

@end
