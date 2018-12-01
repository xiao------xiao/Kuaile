//
//  GroupDetail.m
//  kuaile
//
//  Created by 胡光健 on 2017/3/24.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "GroupDetail.h"
#import "HJGroupDetailModel.h"

@implementation GroupDetail

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


-(void)setModel:(NSMutableArray<NSString *> *)model {
    _model = model;
    CGFloat width = (mScreenWidth - 48 - 30) / 7;
    for (int i = 0; i < model.count; i++) {
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake((i % 7) * (width + 10) + 15, (i / 7) * (width + 10), width, width)];
        image.layer.cornerRadius = width / 2;
        image.layer.masksToBounds = YES;
        [image sd_setImageWithURL:TZImageUrlWithShortUrl(model[i]) placeholderImage:TZPlaceholderImage];
        [self.mainimageView addSubview:image];
    }
    self.imageLayout.constant = self.model.count / 7 *(width +10);
    [_model addObject:[NSString stringWithFormat:@"%f",self.imageLayout.constant + 40]];
}

@end




