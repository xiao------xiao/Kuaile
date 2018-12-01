//
//  TZBannerCell.m
//  刷刷
//
//  Created by ttouch on 16/7/10.
//  Copyright © 2016年 圣巴(上海)文化传播有限公司. All rights reserved.
//

#import "TZBannerCell.h"

@implementation TZBannerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"TZBannerCell";
    TZBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TZBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat height = __kScreenWidth * 9 / 16;
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, __kScreenWidth, height) imageURLStringsGroup:nil];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.backgroundColor = [UIColor clearColor];
        _cycleScrollView.placeholderImage = TZPlaceholderImage16B9;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.clipsToBounds = YES;
        [self.contentView addSubview:_cycleScrollView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setBannerModels:(NSArray *)bannerModels {
    _bannerModels = bannerModels;
    
    NSMutableArray *imageArr = [NSMutableArray array];
    NSMutableArray *titleArr = [NSMutableArray array];
    for (TZBannerModel *model in bannerModels) {
        [imageArr addObject:TZImageUrlStringWithShortUrl(model.img_path)];
        if (model.ads_title.length) {
            [titleArr addObject:model.ads_title];
        }
    }
    _cycleScrollView.imageURLStringsGroup = imageArr;
    if (titleArr.count == imageArr.count) {
        _cycleScrollView.titlesGroup = titleArr;
    }
    _cycleScrollView.autoScroll = NO;
    if (imageArr.count > 1) {
        _cycleScrollView.autoScroll = YES;
    }
    
    __weak typeof(self) weakSelf = self;
    [_cycleScrollView setClickItemOperationBlock:^(NSInteger index) {
        TZBannerModel *model = weakSelf.bannerModels[index];
        /*
        TZTabBarController *tabBar = (TZTabBarController *)[UIViewController currentViewController].tabBarController;
        [tabBar handleBannersWithModel:model];*/
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _cycleScrollView.frame = CGRectMake(0, _topInset, self.width, self.height - _topInset - _bottomInset);
}

@end


@implementation TZBannerModel

- (void)setImg:(NSString *)img {
    _img = img;
    _img_path = img;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    _href = url;
}

@end
