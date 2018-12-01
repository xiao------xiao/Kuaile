//
//  HJNavBarView.m
//  kuaile
//
//  Created by 胡光健 on 2017/3/7.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "HJNavBarView.h"

@implementation HJNavBarView


/** 创建的时候从xib中加载 */
- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HJNavBarView" owner:self options:nil] firstObject];
        self.navBarBack.alpha = 0;
    }
    return self;
}

- (IBAction)backNavi:(id)sender {

}

@end
