//
//  TZButtonSelectCell.m
//  yishipi
//
//  Created by ttouch on 16/10/20.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import "TZButtonSelectCell.h"

@implementation TZButtonSelectCell

- (void)configSubviews {
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self configTitleLable];
    
    _buttonsView = [[TZButtonsHeaderView alloc] init];
    _buttonsView.showLines = NO;
    _buttonsView.showBottomLine = NO;
    _buttonsView.shouldSelect = NO;
    _buttonsView.showBottomIndicator = NO;
    [self.contentView addSubview:_buttonsView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.titleLable.frame = CGRectMake(10, 0, 120, self.height);
    _buttonsView.frame = CGRectMake(CGRectGetMaxX(self.titleLable.frame), 0, self.width - self.titleLable.width, self.height);
}

@end
