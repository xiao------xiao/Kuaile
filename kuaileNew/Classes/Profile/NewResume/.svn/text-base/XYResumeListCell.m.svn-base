//
//  XYResumeListCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/21.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYResumeListCell.h"
#import "TZResumeModel.h"

@interface XYResumeListCell ()
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet UIButton *previewBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end


@implementation XYResumeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (mScreenWidth < 375) {
        self.jobLabel.font = [UIFont systemFontOfSize:15];
        self.previewBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.settingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
}

-(void)setModel:(TZResumeModel *)model {
    _model = model;
    NSString *jobStr;
    if (model.hope_career.length > 0 && model.hope_salary.length > 0) {
       jobStr = [NSString stringWithFormat:@"%@|%@|%@",model.hope_career,model.hope_salary,model.hope_town];
    }else if(model.hope_salary.length > 0) {
       jobStr = [NSString stringWithFormat:@"%@ | %@", model.hope_salary, model.hope_town];
    }else if(model.hope_career.length > 0) {
        jobStr = [NSString stringWithFormat:@"%@ | %@", model.hope_career, model.hope_town];
    }else {
        jobStr = model.hope_town;
    }

    
    
    self.jobLabel.text = jobStr;
    
    self.updateLabel.text = model.updated;
    NSInteger deCount = model.isDefault.integerValue;
    if (deCount == 1) {
        self.defaultLabel.text = @"默认简历";
    } else {
        self.defaultLabel.text = @"";
    }
}

- (IBAction)previewBtnClick:(id)sender {
    if (self.didClickPreviewBlock) {
        self.didClickPreviewBlock();
    }
}

- (IBAction)settingBtnClick:(UIButton *)sender {
    if (self.didClickSettingBlock) {
        self.didClickSettingBlock(sender);
    }
}

- (IBAction)editBtnClick:(id)sender {
    if (self.didClickEditBlock) {
        self.didClickEditBlock();
    }
}

- (IBAction)deleteBtnClick:(id)sender {
    if (self.didClickDeleteBlock) {
        self.didClickDeleteBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
