//
//  TZJobApplyView.m
//  kuaile
//
//  Created by liujingyi on 15/9/18.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZJobApplyView.h"

@interface TZJobApplyView ()
@property (strong, nonatomic) IBOutlet UIButton *applyBtn;

@end

@implementation TZJobApplyView

- (void)awakeFromNib {
    self.applyBtn.layer.cornerRadius = 5;
    self.applyBtn.clipsToBounds = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZJobApplyView" owner:self options:nil] lastObject];
    }
    return self;
}

- (IBAction)buttonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(jobApplyDidClickButton)]) {
        [self.delegate jobApplyDidClickButton];
    }
    
}


@end
