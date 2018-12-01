//
//  TZResumeCell.m
//  kuaile
//
//  Created by liujingyi on 15/9/18.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZResumeCell.h"
#import "TZBottomToolBar.h"
#import "TZResumeModel.h"

@interface TZResumeCell ()
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *resumeStatus;
@end
@implementation TZResumeCell

- (void)awakeFromNib {
    TZBottomToolBar *toolBar = [[TZBottomToolBar alloc] init];
    toolBar.x = 0;
    toolBar.y = self.height - 44;
    toolBar.height = 44;
    [self addSubview:toolBar];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZResumeCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setModel:(TZResumeModel *)model {
    _model = model;
    self.title.text = [NSString stringWithFormat:@"%@/%@/%@",model.hope_career,model.hope_salary,model.hope_town];
    self.date.text = model.updated;
    if (model.isDefault.integerValue == 1) {
        self.resumeStatus.text = @"默认简历";
    } else {
        self.resumeStatus.text = @"";
    }
    
}

#pragma mark 功能方法

// 简历预览
- (IBAction)previewResume {
    if (self.previewBlock) {
        self.previewBlock();
    }
}


@end
