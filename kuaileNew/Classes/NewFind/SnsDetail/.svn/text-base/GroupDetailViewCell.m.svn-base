//
//  GroupDetailViewCell.m
//  kuaile
//
//  Created by 胡光健 on 2017/3/8.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "GroupDetailViewCell.h"
@implementation GroupDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)locationButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(GroupDetailViewCellDelegate:)]) {
        [self.delegate GroupDetailViewCellDelegate:sender.tag];
    }
}

@end
