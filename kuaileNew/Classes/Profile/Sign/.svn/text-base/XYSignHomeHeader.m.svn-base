//
//  XYSignHomeHeader.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/16.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYSignHomeHeader.h"

@interface XYSignHomeHeader ()
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation XYSignHomeHeader

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XYSignHomeHeader" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.signBtn.layer.cornerRadius = self.signBtn.height / 2.0;
    self.signBtn.clipsToBounds = YES;
    [self.signBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.signBtn.layer setBorderWidth:1.2];
}

- (IBAction)signBtnClick:(id)sender {
    if (self.didClickSignBtnBlock) {
        self.didClickSignBtnBlock();
    }
}
- (IBAction)taskBtnClick:(id)sender {
    if (self.didClickTaskBtnBlock) {
        self.didClickTaskBtnBlock();
    }
}

- (IBAction)detailBtnClick:(id)sender {
    if (self.didClickDetailBtnBlock) {
        self.didClickDetailBtnBlock();
    }
}

- (void)setPoint:(NSString *)point {
    self.pointLabel.text = point;
}

- (void)setTips:(NSString *)tips {
    self.tipLabel.text = tips;
}



@end
