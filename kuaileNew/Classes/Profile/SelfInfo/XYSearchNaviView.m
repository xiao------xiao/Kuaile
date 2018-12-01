//
//  XYSearchNaviView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/5/9.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYSearchNaviView.h"

@implementation XYSearchNaviView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XYSearchNaviView" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage * clearImg = [CommonTools imageCreateWithColor:[UIColor whiteColor]];
    [self.searchBar setBackgroundImage:clearImg];
    self.searchBar.layer.cornerRadius = 5;
    self.searchBar.clipsToBounds = YES;
//    [self.searchBar setSearchFieldBackgroundImage:clearImg forState:UIControlStateNormal];
//    [self.searchBar setBackgroundColor:[UIColor clearColor]];
}


@end
