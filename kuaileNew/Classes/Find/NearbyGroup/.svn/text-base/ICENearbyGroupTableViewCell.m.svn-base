//
//  ICENearbyGroupTableViewCell.m
//  kuaile
//
//  Created by ttouch on 15/10/17.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICENearbyGroupTableViewCell.h"
#import "ICEModelGroup.h"

@implementation ICENearbyGroupTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDataWith:(ICEModelGroup *)modelPeople {
    NSString *latitude = [mUserDefaults objectForKey:@"latitude"];
    NSString *longitude = [mUserDefaults objectForKey:@"longitude"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                    @"lat" : @"",
                                                                                    @"lng" : @""
                                                                                    }];
    if (latitude != nil && longitude != nil ) {
        params = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                   @"lat" : latitude,
                                                                   @"lng" : longitude
                                                                   }];
    }
    
    NSString *miles = [ICETools locationWithLatitude:latitude withLongitude:longitude WithLatitude:modelPeople.lat withLongitude:modelPeople.lng];
    self.labTitile.text = modelPeople.owner;
    self.labDesc.text = modelPeople.desc;
    self.labTime.text = [NSString stringWithFormat:@"%@m", miles];
    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:modelPeople.avatar] placeholderImage:[UIImage imageNamed:@"qun"]];
}

@end
