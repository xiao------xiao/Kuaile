//
//  TZLable.m
//  yangmingFinance
//
//  Created by ttouch on 2016/11/8.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import "TZLable.h"

@implementation TZLable

- (instancetype)init {
    self = [super init];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor blackColor];
        self.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

@end
