//
//  TZResumeCell.h
//  kuaile
//
//  Created by liujingyi on 15/9/18.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

// 简历预览block
typedef void(^PreviewBlock)();

@class TZResumeModel;
@interface TZResumeCell : UITableViewCell
@property (nonatomic, strong) TZResumeModel *model;
@property (nonatomic, copy) PreviewBlock previewBlock;
@end
