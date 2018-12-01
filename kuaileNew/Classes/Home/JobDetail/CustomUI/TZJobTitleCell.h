//
//  TZJobTitleCell.h
//  kuaile
//
//  Created by liujingyi on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShowInfoMessageBolck)(NSString *);

@class TZJobModel;
@interface TZJobTitleCell : UITableViewCell
@property (nonatomic, strong) TZJobModel *model;

@property (nonatomic, copy) ShowInfoMessageBolck showInfoMessageBolck;

/** 是否被收藏 */
@property (nonatomic, assign) BOOL haveCollection;


@end
