//
//  TZResumeNameCell.m
//  kuaile
//
//  Created by liujingyi on 15/9/21.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZResumeNameCell.h"

@interface TZResumeNameCell ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textField;
@end

@implementation TZResumeNameCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZResumeNameCell" owner:self options:nil] lastObject];
        self.textField.delegate = self;
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

@end
