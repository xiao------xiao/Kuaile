//
//  XYAvatarHeightConfigTool.m
//  kuaile
//
//  Created by 肖兰月 on 2017/5/4.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYAvatarHeightConfigTool.h"

@implementation XYAvatarHeightConfigTool

+ (CGFloat)configAvatarHeightWithAvatar:(NSInteger)avatarCount {
    CGFloat W = 36;
    CGFloat H = W;
    CGFloat margin = 10;
    CGFloat X = 0;
    CGFloat Y = 0;
    NSInteger row = 0;
    NSInteger loc = 0;
    CGFloat totalHeight;
    for (int i = 0; i < avatarCount; i++) {
        X = margin + (W + margin) * loc;
        if (X + W >= mScreenWidth) {
            row += 1;
            loc = 0;
            X = margin + (W + margin) * loc;
        }
        loc += 1;
        Y = margin + (H + margin) * row;
        
        if (i == avatarCount - 1) {
            totalHeight = Y + H + margin;
        }
    }
    return totalHeight;
}

@end
