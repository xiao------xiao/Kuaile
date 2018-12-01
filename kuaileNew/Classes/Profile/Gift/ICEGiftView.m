//
//  ICEGiftView.m
//  kuaile
//
//  Created by ttouch on 15/12/8.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICEGiftView.h"


@implementation ICEGiftView

- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ICEGiftView" owner:self options:nil] lastObject];
    }
    return self;
}

- (IBAction)cancelBtnClick:(id)sender {
    if (self.didClickCancelBtnBlock) {
        self.didClickCancelBtnBlock();
    }
}

@end
