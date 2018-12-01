//
//  XYNewFriendHeaderView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/8.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYNewFriendHeaderView.h"
#import "TZButtonsHeaderView.h"

@interface XYNewFriendHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIImageView *avaterView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIButton *ageBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentionNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *fanNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *fanLabel;
@property (weak, nonatomic) IBOutlet UILabel *postNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *threeView;

//@property (nonatomic, strong) TZButtonsHeaderView *headerBtns;

@property (nonatomic, strong) TZBaseButton *selBtn;
@end

@implementation XYNewFriendHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XYNewFriendHeaderView" owner:self options:nil] lastObject];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.avaterView.layer.cornerRadius = 40;
    self.avaterView.clipsToBounds = YES;
    self.threeView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    
    _selHeaderView = [[TZButtonsHeaderView alloc] init];
    _selHeaderView.frame = self.bottomView.bounds;
    _selHeaderView.notCalcuLateTitleWidth = YES;
    _selHeaderView.showBottomIndicator = YES;
    _selHeaderView.showLines = NO;
    _selHeaderView.titles = @[@"TA的资料",@"TA的帖子"];
    _selHeaderView.changeFontWhenSelected = YES;
    _selHeaderView.fontSizes = @[@17,@17];
    _selHeaderView.boldFont = 17;
    _selHeaderView.selectBtnIndex = 0;
    _selHeaderView.btnWidth = mScreenWidth / 2;
    MJWeakSelf
    [_selHeaderView setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
        if (weakSelf.didClickButtonsViewBlock) {
            weakSelf.didClickButtonsViewBlock(index);
        }
    }];
    [self.bottomView addSubview:_selHeaderView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _selHeaderView.frame = self.bottomView.bounds;
}

@end
