//
//  GroupPeopleCell.m
//  kuaile
//
//  Created by 胡光健 on 2017/4/14.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "GroupPeopleCell.h"
#import "HJZanListModel.h"

@interface GroupPeopleCell()
@property (weak, nonatomic) IBOutlet UIImageView *mianImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation GroupPeopleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(HJGroupPeopleModel *)model {
    _model = model;
    [self.mianImageView sd_setImageWithURL:TZImageUrlWithShortUrl(model.avatar) placeholderImage:TZPlaceholderImage];
    self.nameLabel.text = model.username;
}


@end
