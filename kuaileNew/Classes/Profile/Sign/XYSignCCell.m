//
//  XYSignCCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/18.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYSignCCell.h"

@interface XYSignCCell () {
    CGSize _size;
}

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UIImageView *checkView;

@property (nonatomic, strong) UIImageView *greyView;

@property (nonatomic, strong) UIImageView *icon;

@end

@implementation XYSignCCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
        _size = frame.size;
        [self configSubViews];
    }
    return self;
}

//yqd   qd_btn_sel  qd_btn_def
- (void)configSubViews {
    _numLabel = [[UILabel alloc] init];
    _numLabel.frame = CGRectMake(0, 0, 20, 10);
    _numLabel.textColor = TZGreyText150Color;
    _numLabel.textAlignment = NSTextAlignmentLeft;
    _numLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_numLabel];
    
    _checkView = [[UIImageView alloc] init];
    _checkView.frame = CGRectMake(self.width - 16, 0, 16, 16);
    _checkView.image = [UIImage imageNamed:@"yqd"];
    [self.contentView addSubview:_checkView];
    
    _icon = [[UIImageView alloc] init];
    _icon.frame = CGRectMake(20, 20, _size.width - 25, _size.height - 25);
    [self.contentView addSubview:_icon];
    self.backgroundColor = [UIColor whiteColor];

}


- (void)setModel:(ORSignModel *)model {
    _model = model;
    _numLabel.text = model.date;
    _checkView.hidden = model.is_sign.integerValue == 0;
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:TZPlaceholderImage];
    
    if (model.date.integerValue <= [ORSignModel currentDateNumber] && model.is_sign.integerValue == 0) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }else if (model.date.integerValue <= [ORSignModel currentDateNumber] && model.is_sign.integerValue == 1) {
        self.backgroundColor = [UIColor whiteColor];
    }else {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.4];
    }
    
    if (model.date.integerValue == [ORSignModel currentDateNumber]) {
        self.layer.borderColor = [UIColor orangeColor].CGColor;
        self.layer.borderWidth = 1;
    }else {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
    
}


@end

@implementation ORSignModel

+ (NSInteger)currentDateNumber {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"dd";
    NSString *aa = [formater stringFromDate:now];
    
    return aa.integerValue;
}



@end
