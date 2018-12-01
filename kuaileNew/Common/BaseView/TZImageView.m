//
//  TZImageView.m
//  yangmingFinance
//
//  Created by ttouch on 2016/11/8.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import "TZImageView.h"

@implementation TZImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

@end
