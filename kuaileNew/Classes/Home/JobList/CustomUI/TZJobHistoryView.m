//
//  TZJobHistoryView.m
//  kuaile
//
//  Created by liujingyi on 15/9/23.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZJobHistoryView.h"

@interface TZJobHistoryView ()

@end

@implementation TZJobHistoryView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZJobHistoryView" owner:self options:nil] lastObject];
    }
    return self;
}

@end
