//
//  TZBottomToolBar.m
//  kuaile
//
//  Created by liujingyi on 15/9/18.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZBottomToolBar.h"

@interface TZBottomToolBar ()

@end
@implementation TZBottomToolBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZBottomToolBar" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    self.width = __kScreenWidth;
}



/** 由于隔了一层，所以这里用通知 */
- (IBAction)buttonClick:(UIButton *)sender {
    
//    if ([self.delegate respondsToSelector:@selector(toolBarDidClickButton:)]) {
//        [self.delegate toolBarDidClickButton:sender.tag];
//    }
    NSDictionary *info = @{@"type":@(sender.tag),@"view":self};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TZBottomToolBarButtonClick" object:self userInfo:info];
}



@end
