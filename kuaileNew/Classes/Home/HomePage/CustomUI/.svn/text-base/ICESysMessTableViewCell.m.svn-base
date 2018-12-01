//
//  ICESysMessTableViewCell.m
//  kuaile
//
//  Created by ttouch on 15/10/28.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICESysMessTableViewCell.h"
#import "ICEModelSysMess.h"
@implementation ICESysMessTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDataModel:(ICEModelSysMess *)model {
    self.labTitle.text = model.title;
    self.labDesc.text = model.content;
    self.labTime.text = [ICETools standardTime:model.created];
}

@end
