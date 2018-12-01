//
//  ORSigningView.m
//  kuaile
//
//  Created by 欧阳荣 on 2017/3/22.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "ORSigningView.h"

@interface ORSigningView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBottow;

@end

@implementation ORSigningView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bounds = [UIScreen mainScreen].bounds;
    
    if (mScreenWidth > 350) {
        _btnBottow.constant = 28;
    }
    
}

- (IBAction)action_signNormol:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(normalSignBtnDidPressed)]) {
        [self.delegate normalSignBtnDidPressed];
    }
    
}

- (IBAction)action_photoSelfSign:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoSelfBtnDidPressed)]) {
        [self.delegate photoSelfBtnDidPressed];
    }

}

- (IBAction)action_cancelBtn:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
//        [self removeFromSuperview];
    }];

    
}

@end
