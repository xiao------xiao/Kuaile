//
//  LCCollectionViewCell.m
//  OMCN
//
//  Created by crazypoo on 15-1-30.
//  Copyright (c) 2015年 doudou. All rights reserved.
//

#import "LCCollectionViewCell.h"

#define DEFAULT_FONT(s)     [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:s]
@implementation LCCollectionViewCell
@synthesize cellTitle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-74)/2, (self.frame.size.height-30)/2, 74, 30)];
        bgView.image = [UIImage imageNamed:@"square_city"];
        [self.contentView addSubview:bgView];
        cellTitle               = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-74)/2, (self.frame.size.height-30)/2, 74, 30)];
        cellTitle.backgroundColor = [UIColor clearColor];
//        UIImage *image = [UIImage imageNamed:@"square_city"];
//        cellTitle.layer.contents = (id) image.CGImage;
        // 如果需要背景透明加上下面这句
//        cell.contentView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        
        cellTitle.textAlignment = NSTextAlignmentCenter;
        cellTitle.lineBreakMode = NSLineBreakByWordWrapping;
        cellTitle.numberOfLines = 0;
        cellTitle.font          = fontBig;
        cellTitle.textColor     = color_lightgray;
        [self.contentView addSubview:cellTitle];

        
//        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}
@end
