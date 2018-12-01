//
//  TZDatePickerView.m
//  kuaile
//
//  Created by liujingyi on 15/9/22.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZDatePickerView.h"

@interface TZDatePickerView ()
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation TZDatePickerView

- (void)awakeFromNib {
    self.datePicker.maximumDate = [NSDate date];
    self.untilNowButton.hidden = YES;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZDatePickerView" owner:self options:nil] lastObject];
    }
    return self;
}

- (IBAction)untilNowButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(datePickerViewDidClickUntilNowButton)]) {
        [self.delegate datePickerViewDidClickUntilNowButton];
    }
}


- (IBAction)cancle:(id)sender {
    if ([self.delegate respondsToSelector:@selector(datePickerViewDidClickCancleButton)]) {
        [self.delegate datePickerViewDidClickCancleButton];
    }
}

- (IBAction)ok:(id)sender {
    if ([self.delegate respondsToSelector:@selector(datePickerViewDidClickOKButton:)]) {
        [self.delegate datePickerViewDidClickOKButton:self.datePicker];
    }
}


@end
