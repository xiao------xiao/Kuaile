//
//  TZFindSnsCell.h
//  kuaile
//
//  Created by ttouch on 2016/12/21.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TZFindSnsCellButtonTypeMoreBtn = 1, // 更多
    TZFindSnsCellButtonTypeEvaluateBtn,  // 评论
} TZFindSnsCellButtonType;
@class TZFindSnsCell;


@class TZFindSnsModel;
@protocol  TZFindSnsCellDelegate<NSObject>

- (void)FindSnsCelldelegate:(TZFindSnsCell *)cell sidID:(NSString *)sid removeArray:(TZFindSnsModel *)model;
- (void)FindSnsCelldelegate:(TZFindSnsCell *)cell removeArray:(TZFindSnsModel *)model;
@end


@class TZFindSnsModel,TZPhotosGroupView;
@interface TZFindSnsCell : UITableViewCell

@property (nonatomic, strong) TZFindSnsModel *model;
@property (nonatomic, assign) id<TZFindSnsCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIButton *sexLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeSiteLbl;
@property (weak, nonatomic) IBOutlet UIButton *careBtn;
@property (weak, nonatomic) IBOutlet HWStatusTextView *contentStrView;
@property (weak, nonatomic) IBOutlet TZPhotosGroupView *imgSupView;
@property (weak, nonatomic) IBOutlet UIButton *evaluateBtn;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIImageView *zanImageView;
@property (weak, nonatomic) IBOutlet UIView *zanImgSupView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentStrContrainstH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgSupViewContrainstH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hitViewH;
@property (weak, nonatomic) IBOutlet UIImageView *moreZan;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *careBtnRightMarginConstrain;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attentionBtnConstraintW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attentionBtnConstraintH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameConstraintW;





@property (nonatomic, copy) void(^blockClickZanReload)(NSString * msg);
@property (nonatomic, copy) void (^checkMoreZanBlock)();
@property (nonatomic, copy) void (^moreBtnClick)();
@property(nonatomic,copy) void (^careBtnClicked)();

@end
