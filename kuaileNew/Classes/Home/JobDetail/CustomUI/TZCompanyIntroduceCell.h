//
//  TZCompanyIntroduceCell.h
//  kuaile
//
//  Created by liujingyi on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZCompanyIntroduceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *otherJobTipLbl;

/** 公司简介 */
@property (strong, nonatomic) IBOutlet UILabel *introduce;

- (instancetype)initWithCompanyIntroduce:(NSString *)introduce;

@end
