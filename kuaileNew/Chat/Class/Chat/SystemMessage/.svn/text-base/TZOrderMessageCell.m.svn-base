//
//  LTOrderMessageTableViewCell.m
//  AgricultureWindow
//
//  Created by Jonny on 16/4/11.
//  Copyright © 2016年 农业之窗. All rights reserved.
//

#import "TZOrderMessageCell.h"
#import "XYMessageModel.h"
#import "ORTimeTool.h"

@interface TZOrderMessageCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeading;
@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subTitleH;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@end

@implementation TZOrderMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 3;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = TZColorRGB(244).CGColor;

    self.content.backgroundColor = TZControllerBgColor;
    self.selectionStyle = 0;
}

- (void)loadModelData:(XYMessageModel *)model {
    self.timeLabel.text = [ORTimeTool timeShortStr:model.create_at.integerValue];
    
    if (model.images.length > 0) {
        
    }else {
        _imageLeading.constant = -_headImg.width;
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    self.descLabel.text = model.content;
    self.subTitleH.constant = model.cellHeight - 85;
}

@end
