//
//  TZJobContactCell.m
//  kuaile
//
//  Created by liujingyi on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZJobContactCell.h"
#import "TZJobModel.h"
#import "TZCompanyTitleModel.h"

@interface TZJobContactCell ()
@property (strong, nonatomic) IBOutlet UIButton *call;
@property (strong, nonatomic) IBOutlet UIButton *mail;

@end

@implementation TZJobContactCell

- (void)awakeFromNib {
    self.width = __kScreenWidth;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZJobContactCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (IBAction)ButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(contactCellDidClickButton:)]) {
        [self.delegate contactCellDidClickButton:sender.tag];
    }
}

- (void)setModel:(TZJobModel *)model {
    _model = model;
    self.contact_name.text = model.contact;
    self.contact_tel.text = model.phone;
}

@end
