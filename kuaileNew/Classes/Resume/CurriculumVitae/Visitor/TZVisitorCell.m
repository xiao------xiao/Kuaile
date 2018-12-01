//
//  TZVisitorCell.m
//  kuaile
//
//  Created by liujingyi on 15/9/23.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZVisitorCell.h"
#import "TZVisitorModel.h"

@interface TZVisitorCell ()

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *name;

@property (strong, nonatomic) IBOutlet UIImageView *star1;
@property (strong, nonatomic) IBOutlet UIImageView *star2;
@property (strong, nonatomic) IBOutlet UIImageView *star3;
@property (strong, nonatomic) IBOutlet UIImageView *star4;
@property (strong, nonatomic) IBOutlet UIImageView *star5;

@property (strong, nonatomic) IBOutlet UILabel *introduce;


@end

@implementation TZVisitorCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(TZVisitorModel *)model {
    _model = model;
    if ([UIImage imageNamed:model.logo] != nil) {
        self.image.image = [UIImage imageNamed:model.logo];
    }
    self.name.text = model.name;
    self.introduce.text = model.company_industry;
    self.star = model.star.integerValue;
}

/** 设置星级 */
- (void)setStar:(NSInteger)star {
    _star = star;
    UIImage *star_sel = [UIImage imageNamed:@"recruit_star_sel"];
    UIImage *star_def = [UIImage imageNamed:@"recruit_star_def"];
    self.star1.image = star >= 1 ? star_sel : star_def;
    self.star2.image = star >= 2 ? star_sel : star_def;
    self.star3.image = star >= 3 ? star_sel : star_def;
    self.star4.image = star >= 4 ? star_sel : star_def;
    self.star5.image = star >= 5 ? star_sel : star_def;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZVisitorCell" owner:self options:nil] lastObject];
    }
    return self;
}

@end
