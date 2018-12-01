//
//  XYPhotoView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/27.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYShowPhotoView.h"

@interface XYShowPhotoView ()

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation XYShowPhotoView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XYShowPhotoView" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftBtn.layer.cornerRadius = 3;
    self.rightBtn.layer.cornerRadius = 3;
}


- (IBAction)photoBtnClick:(UIButton *)sender {
    if (self.didClickPhotoBtn) {
        self.didClickPhotoBtn(sender.tag);
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.height = (mScreenWidth - 15)/(2*1.46) + 5 + 90;
}

@end
