//
//  TZBottomToolView.m
//  kuaile
//
//  Created by liujingyi on 15/9/23.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZBottomToolView.h"

@interface TZBottomToolView ()
@property (strong, nonatomic) IBOutlet UILabel *count;
@property (strong, nonatomic) IBOutlet UIButton *apply;
@property (strong, nonatomic) IBOutlet UIButton *call;
@property (strong, nonatomic) IBOutlet UIButton *service;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyBtnConstraintW;


@end

@implementation TZBottomToolView

- (void)awakeFromNib {
    self.apply.layer.cornerRadius = 15;
    self.apply.clipsToBounds = YES;
    self.call.layer.cornerRadius = 15;
    self.call.clipsToBounds = YES;
    self.service.layer.cornerRadius = 15;
    self.service.clipsToBounds = YES;
    self.comment.layer.cornerRadius = 15;
    self.comment.clipsToBounds = YES;
    
    if (mScreenWidth < 375) {
        self.applyBtnConstraintW.constant = 55;
    }
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZBottomToolView" owner:self options:nil] lastObject];
    }
    return self;
}

- (IBAction)buttonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bottomToolViewClickButtonType:)]) {
        [self.delegate bottomToolViewClickButtonType:sender.tag];
    }
}

@end
