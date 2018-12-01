//
//  TZJobBodyCell.h
//  kuaile
//
//  Created by liujingyi on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TZJobBodyButtonLocation = 100, // 定位
    TZJobBodyButtonSyndicate,     // 公司信息
}TZJobBodyCellType;

@class TZJobModel;
@protocol TZJobBodyCellDelegate <NSObject>
- (void)TZJobBodyCellButtonClicked:(TZJobBodyCellType)type;
@end

@interface TZJobBodyCell : UITableViewCell

@property (nonatomic, assign) TZJobBodyCellType type;

@property (nonatomic, strong) TZJobModel *model;
@property (nonatomic, copy) void(^blockChangeViewH)(CGRect);
@property (weak, nonatomic) IBOutlet UIButton *locationButtonClicked;// 公司地址按钮
@property (weak, nonatomic) IBOutlet UIButton *syndicateButton; // 公司详情的View 按钮
@property (nonatomic, assign) id<TZJobBodyCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *welfareMoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *descMoreBtn;




- (IBAction)clickMoreComWelfare:(UIButton *)sender;
- (IBAction)clickMoreWorkDec:(UIButton *)sender;

- (instancetype)initWithJobIntroduce:(NSString *)jobIntroduce welfare:(NSString *)welfare;

@end
