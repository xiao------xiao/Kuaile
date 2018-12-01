//
//  TZAddFriendHeaderView.m
//  kuaile
//
//  Created by ttouch on 2016/12/23.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import "TZAddFriendHeaderView.h"

@implementation TZAddFriendHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZAddFriendHeaderView" owner:self options:nil] lastObject];
        _searchBar.backgroundColor = TZColorRGB(128);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bottomView addTopLine];
}

- (IBAction)searchBtnClick:(UIButton *)sender {
    if (self.didClickSearchBtnBlock) {
        self.didClickSearchBtnBlock();
    }
}


- (IBAction)addPeopleBtnClick:(id)sender {
    if (self.didTapAddressBookViewBlock) {
        self.didTapAddressBookViewBlock();
    }
}







@end
