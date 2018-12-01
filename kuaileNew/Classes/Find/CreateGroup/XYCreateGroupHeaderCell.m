//
//  XYCreateGroupHeaderCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/8.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCreateGroupHeaderCell.h"

@interface XYCreateGroupHeaderCell ()

@property (nonatomic, strong) UIImage *icon;

@end

@implementation XYCreateGroupHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAvaterView)];
    [self.avaterView addGestureRecognizer:tap];
}

- (void)clickAvaterView {
//    if (self.icon) {
//        XYPhotoViewController *photoVc = [[XYPhotoViewController alloc] init];
//        photoVc.currentIcon = self.icon;
//        [[UIViewController currentViewController].navigationController pushViewController:photoVc animated:YES];
//    } else {
//        [TZImagePickerTool selectImageForEditFrom:self complete:^(UIImage *origionImg, UIImage *editedImage) {
//            self.avaterView.image = editedImage;
//            self.icon = editedImage;
//        }];
//    }
    
    if (self.didClickAvaterViewBlock) {
        self.didClickAvaterViewBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
