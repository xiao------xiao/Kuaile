//
//  TZSearchCell.m
//  kuaile
//
//  Created by liujingyi on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZSearchCell.h"

@implementation TZSearchCell

- (void)awakeFromNib {
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZSearchCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (IBAction)add:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addSearchTitle" object:self userInfo:@{@"title":self.title.text}];
}

@end
