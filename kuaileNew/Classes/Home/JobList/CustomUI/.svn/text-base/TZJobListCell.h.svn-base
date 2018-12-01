//
//  TZJobListCell.h
//  kuaile
//
//  Created by liujingyi on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TZJobListCellTypeNormal,     // 正常的职位列表Cell
    TZJobListCellTypeCollection, // 收藏职位列表Cell
    TZJobListCellTypeHighSalary, // 今日高新职位列表Cell
    TZJobListCellTypeHistory,    // 投递历史职位列表Cell
    TZJobListCellTypeRecommed,   // 推荐职位列表Cell
    TZJobListCellTypeOthers,     // 该公司其他职位列表Cell
} TZJobListCellType;

@class TZJobModel,TZJobListCell;
@protocol  TZJobListCellDelegate<NSObject>
- (void)jobListCellDidClickCheckBtn:(UIButton *)checkBtn recruit_id:(NSString *)recruit_id;
@end

@interface TZJobListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleToUpImage; // 返现图片 左边约束
@property (strong, nonatomic) IBOutlet UIImageView *topImageView; // 置顶图片

@property (nonatomic, strong) TZJobModel *model;
/** 该招聘信息的入评星级，1-5级 */
@property (nonatomic, assign) NSInteger starNum;
@property (nonatomic, assign) id<TZJobListCellDelegate> delegate;
@property (nonatomic, assign) TZJobListCellType type;

@end
