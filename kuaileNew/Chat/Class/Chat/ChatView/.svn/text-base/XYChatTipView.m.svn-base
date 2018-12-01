//
//  XYChatTipView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/10.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYChatTipView.h"

@interface XYChatTipView ()

@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UILabel *convientLabel;


@end

@implementation XYChatTipView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XYChatTipView" owner:self options:nil] firstObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.attentionLabel.font = [UIFont boldSystemFontOfSize:14];
    self.screenBtn.layer.cornerRadius = 13;
    self.attentBtn.layer.cornerRadius = 13;
    [self.screenBtn.layer setBorderColor:TZColorRGB(200).CGColor];
    [self.screenBtn.layer setBorderWidth:0.7];
    [self.attentBtn.layer setBorderColor:TZColorRGB(200).CGColor];
    [self.attentBtn.layer setBorderWidth:0.7];
}



- (IBAction)screenBtnClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender setTitleColor:TZColorRGB(150) forState:0];
        [sender.layer setBorderWidth:0.7];
        [sender setTitle:@"已屏蔽" forState:UIControlStateNormal];
    } else {
        [sender setBackgroundColor:TZColor(45, 178, 249)];
        [sender setTitleColor:[UIColor whiteColor] forState:0];
        [sender.layer setBorderWidth:0];
        [sender setTitle:@"屏蔽" forState:UIControlStateNormal];
    }
    if (self.didClickScreenBtnBlock) {
        self.didClickScreenBtnBlock(sender.selected);
    }
}
- (IBAction)attentBtnClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender setTitleColor:TZColorRGB(150) forState:0];
        [sender.layer setBorderWidth:0.7];
        [sender setTitle:@"已关注" forState:UIControlStateNormal];
    } else {
        [sender setBackgroundColor:TZColor(45, 178, 249)];
        [sender setTitleColor:[UIColor whiteColor] forState:0];
        [sender.layer setBorderWidth:0];
        [sender setTitle:@"+关注" forState:UIControlStateNormal];
    }
    if (self.didClickAttentionBtnBlock) {
        self.didClickAttentionBtnBlock(sender.selected);
    }
}


@end
