//
//  ICENearbyPeopleTableViewCell.m
//  kuaile
//
//  Created by ttouch on 15/10/17.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICENearbyPeopleTableViewCell.h"
#import "TZNearbyPersonModel.h"

@interface ICENearbyPeopleTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *lastLogin;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@end

@implementation ICENearbyPeopleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(TZNearbyPersonModel *)model {
    _model = model;
    self.nickName.text = model.nickname.length > 0 ? model.nickname : [NSString stringWithFormat:@"%@****%@", [model.username substringToIndex:3], [model.username substringFromIndex:7]];
    self.desc.text = model.desc;
    self.distance.text = [model.distance stringByAppendingString:@"m"];
    self.lastLogin.text = model.last_login;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:TZPlaceholderAvaterImage];
}

@end
