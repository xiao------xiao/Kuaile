//
//  TZHomeNaviBar.m
//  housekeep
//
//  Created by ttouch on 16/5/5.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "TZStoreNaviBar.h"

@interface TZStoreNaviBar ()
@end

@implementation TZStoreNaviBar

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZStoreNaviBar" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.naviTitleLable.textAlignment = NSTextAlignmentCenter;
    self.alphaFloat = 0.0;
}

- (void)setAlphaFloat:(CGFloat)alphaFloat {
    _alphaFloat = alphaFloat;
    self.colorBgView.alpha = alphaFloat;
//    self.naviTitleLable.alpha = alphaFloat;
    self.colorBgImageView.alpha = alphaFloat;
}

@end
