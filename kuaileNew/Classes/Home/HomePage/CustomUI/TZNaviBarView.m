//
//  TZNaviBarView.m
//  HappyWork
//
//  Created by liujingyi on 15/9/10.
//  Copyright (c) 2015年 memberwine. All rights reserved.
//

#import "TZNaviBarView.h"

@interface TZNaviBarView ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *naviBarWidth;
- (IBAction)searchButtonClick:(UIButton *)sender;
@end

@implementation TZNaviBarView

/** 创建的时候从xib中加载 */
- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZNaviBarView" owner:self options:nil] firstObject];
        self.bgColorView.alpha = 0;
    }
    return self;
}


/** 搜索框tap事件，跳转到搜索控制器 */

- (IBAction)searchButtonClick:(UIButton *)sender {
    NSLog(@"searchButtonClick");
}
@end
