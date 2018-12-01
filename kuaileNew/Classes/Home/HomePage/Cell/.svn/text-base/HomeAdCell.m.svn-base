//
//  HomeAdCell.m
//  kuaileNew
//
//  Created by admin on 2018/11/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "HomeAdCell.h"
#import "SDCycleScrollView.h"

#import "ICEModelAds.h"
@interface HomeAdCell()<SDCycleScrollViewDelegate>
/** 顶部轮播图 */
@property (strong, nonatomic) UIScrollView *topScrollView;
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSArray *imagesURLStrings;  //轮播图图片

@end
@implementation HomeAdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configAdPageView];
    }
    return self;
}
-(void)layoutSubviews{
    
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}
#pragma mark - 轮播广告
- (void)configAdPageView {
    //网络加载 --- 创建带标题的图片轮播器
    
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.frame imageURLStringsGroup:nil]; // 模拟网络延时情景
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.delegate = self;
        _cycleScrollView.backgroundColor = [UIColor clearColor];
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        [self addSubview:_cycleScrollView];
    }
    self.contentView.backgroundColor = [UIColor redColor];
    RACSignal *sign = [ICEImporter ads];
    [sign subscribeNext:^(id x) {
        _imagesURLStrings = [ICEModelAds mj_objectArrayWithKeyValuesArray:x[@"data"]];
        NSMutableArray *imgAry = [NSMutableArray array];
        for (NSInteger i = 0; i < _imagesURLStrings.count; i++) {
            ICEModelAds *model = _imagesURLStrings[i];
            NSString *imgURL = [NSString stringWithFormat:@"%@%@", ApiSystemImage, model.path];
            if (i == 4) {
                [mUserDefaults setObject:model.href forKey:@"huodongguize"];
                [mUserDefaults synchronize];
            }
            [imgAry addObject:imgURL];
        }
        _cycleScrollView.imageURLStringsGroup = imgAry;
    }];
}


#pragma mark SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    ICEModelAds *model = _imagesURLStrings[index];
    if ([model.href containsString:ApiSns] || [model.href containsString:ApiSnsNew]) { // 广场
//        self.tabBarController.selectedIndex = 2;
    } else if ([model.href isEqualToString:ApiAward]) {
        if ([TZUserManager isLogin]) {
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            if (self.imageClickedBlock) {
                self.imageClickedBlock([model.href stringByAppendingString:userModel.uid], model.ads_title);
            }
            
//            [self pushWebVcWithUrl:[model.href stringByAppendingString:userModel.uid] title:model.ads_title];
        }
    } else {
        if (self.imageClickedBlock) {
            self.imageClickedBlock(model.href, model.ads_title);
        }
//        [self pushWebVcWithUrl:model.href title:model.ads_title];
    }
}



/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}
+(CGFloat)cellHeight{
    return mScreenWidth/2;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
