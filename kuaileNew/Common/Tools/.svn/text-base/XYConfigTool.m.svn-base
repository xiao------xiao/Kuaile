//
//  XYConfigTool.m
//  yinliaopifa
//
//  Created by 肖兰月 on 2017/1/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "XYConfigTool.h"

@implementation XYConfigTool

- (void)setConfigArr:(NSArray *)configArr {
    _configArr = configArr;
    self.configArrH = [self configCellHeightArray:configArr];
}

- (CGFloat)configCellHeightArray:(NSArray *)array {
    if (!array.count) {
        return 0;
    } else {
        if (!self.btnFont || self.btnFont == 0) {
            self.btnFont = 14;
        }
        if (!self.btnH || self.btnH == 0) {
            self.btnH = 34;
        }
        if (!self.margin || self.margin == 0) {
            self.margin = 15;
        }
        if (!self.extraAddWidth || self.extraAddWidth == 0) {
            self.extraAddWidth = 40;
        }
        CGFloat btnY = 0.0;
        CGFloat btnH = self.btnH;
        CGFloat margin = self.margin;
        CGFloat loc = 0;
        CGFloat row = 0;
        CGFloat totalW = margin;
        for (int i = 0; i < array.count; i ++) {
            CGFloat btnW = [CommonTools sizeOfText:array[i] fontSize:self.btnFont].width + self.extraAddWidth;
            if (btnW + 2 * margin > mScreenWidth) {
                btnW = mScreenWidth - 2 * margin;
            }
            CGFloat btnX = totalW;
            if ((btnX + btnW) > mScreenWidth - margin) {
                row += 1;
                loc = 0;
                btnX = margin;
                totalW = btnW + margin +margin;
            } else {
                loc += 1;
                totalW += btnW + margin;
            }
            btnY = margin + (margin +btnH) *row;
        }
        return btnY + btnH + margin;
    }
}



@end
