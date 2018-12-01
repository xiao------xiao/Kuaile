//
//  ORCommentLikeCell.m
//  kuaile
//
//  Created by 欧阳荣 on 2017/4/18.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "ORCommentLikeCell.h"
#import "ORTimeTool.h"
#import "XYMessageModel.h"


@implementation ORCommentLikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(XYMessageModel *)model {
    
    
    _model = model;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.uavatar] placeholderImage:TZPlaceholderAvaterImage];
    self.nameLabel.text = model.unickname;
    self.timeLabel.text = [ORTimeTool timeShortStr:model.create_at.integerValue];
    self.detailLabel.text = model.title;
    
    switch (model.data_type.integerValue) {
        case 301:
            self.content.text = [NSString stringWithFormat:@"回复我的帖子：%@", model.content];
            break;
        case 302:
            self.content.text = model.content;
            break;
        case 303:
            self.content.text = [NSString stringWithFormat:@"回复我的评论：%@", model.content];
            break;
        default:
            break;
    }
    
}


@end
