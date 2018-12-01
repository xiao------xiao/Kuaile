//
//  TZResumeRootCell.m
//  kuaile
//
//  Created by liujingyi on 15/9/24.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZResumeRootCell.h"

@implementation TZResumeRootCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 添加分隔线
        [self addSubview:[UIView divideViewWithHeight:self.height]];
        // 设置textLabel的属性
        self.textLabel.font = [UIFont systemFontOfSize:17];
        self.textLabel.textColor = [UIColor darkGrayColor];
        // 设置detailTextLabel的属性
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

+ (instancetype)resumeRootCell:(UITableView *)tableView {
    static NSString *ID = @"resume_cell";
    TZResumeRootCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TZResumeRootCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

@end
