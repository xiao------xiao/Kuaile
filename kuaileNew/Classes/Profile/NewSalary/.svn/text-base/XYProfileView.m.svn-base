//
//  XYProfileView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/27.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYProfileView.h"
#import "XYSalaryUserModel.h"

@interface XYProfileView ()
@property (weak, nonatomic) IBOutlet UIImageView *avaterView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation XYProfileView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XYProfileView" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (mScreenWidth < 375) {
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        self.cardLabel.font = [UIFont systemFontOfSize:14];
    }
}

- (void)setModel:(XYSalaryUserModel *)model {
    _model = model;
    self.cardLabel.text = [NSString stringWithFormat:@"身份证：%@",model.id_number];
    self.nameLabel.text = model.name;
    [self.avaterView sd_setImageWithURL:TZImageUrlWithShortUrl(model.avatar) placeholderImage:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.height = 90;
}


@end
