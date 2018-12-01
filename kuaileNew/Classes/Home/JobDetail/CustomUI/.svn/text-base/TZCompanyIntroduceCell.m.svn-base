//
//  TZCompanyIntroduceCell.m
//  kuaile
//
//  Created by liujingyi on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZCompanyIntroduceCell.h"

@implementation TZCompanyIntroduceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZCompanyIntroduceCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (instancetype)initWithCompanyIntroduce:(NSString *)introduce {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZCompanyIntroduceCell" owner:self options:nil] lastObject];
        CGFloat height = [introduce boundingRectWithSize:CGSizeMake(__kScreenWidth - 10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
        self.frame = CGRectMake(0, 320, __kScreenWidth, height + 66);
    }
    return self;
}

@end
