//
//  TZVisitorCell.h
//  kuaile
//
//  Created by liujingyi on 15/9/23.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TZVisitorModel;
@interface TZVisitorCell : UITableViewCell
/** 该公司信息的入评星级，1-5级 */
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, strong) TZVisitorModel *model;
@end
