//
//  ICEMySelfTableViewCell.m
//  hxjjyh
//
//  Created by ttouch on 15/8/25.
//  Copyright (c) 2015年 陈冰. All rights reserved.
//

#import "ICEMySelfTableViewCell.h"

@implementation ICEMySelfTableViewCell

- (void)updateConstraints {
    [super updateConstraints];
    if (__kScreenWidth == 320) {
        self.labName.font = [UIFont systemFontOfSize:16];
    } else if (__kScreenWidth == 375) {
        self.labName.font = [UIFont systemFontOfSize:17];
    } else {
        self.labName.font = [UIFont systemFontOfSize:18];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
