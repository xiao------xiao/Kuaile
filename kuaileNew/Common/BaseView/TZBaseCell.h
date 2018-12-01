//
//  TZBaseCell.h
//  yishipi
//
//  Created by ttouch on 16/9/26.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TZBaseCellTypeNormal, /// 正常样式,左图 上主标题 下副标题
    TZBaseCellTypeLable,  /// 右边文字模式 左主标题 右副标题
    TZBaseCellTypeDoubleLable, /// 三个文字模式 左、中、右分别三个lable
    TZBaseCellTypeAvatar, /// 头像模式，左主标题 右头像
    TZBaseCellTypeSwitch, /// 开关模式，左主标题 右开关
} TZBaseCellType;

@interface TZBaseCell : UITableViewCell

@property (nonatomic, assign) TZBaseCellType cellType;

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *titleLable;
@property (strong, nonatomic) UILabel *subTitleLable;

@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UILabel *centerLable;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, assign) NSInteger avatarImageW;
@property (nonatomic, assign) NSInteger subTitleLableW;
@property (nonatomic, assign) BOOL avatarImageCircular;

@property (nonatomic, assign) BOOL hideSubTitleLable;
@property (nonatomic, assign) BOOL hideImgView;

@property (nonatomic, assign) NSInteger imgViewWidth;
@property (nonatomic, assign) NSInteger titleH;
@property (nonatomic, assign) NSInteger titleTop;
@property (nonatomic, assign) NSInteger subTitleH;

- (void)configImgView;
- (void)configTitleLable;
- (void)configSubtitleLable;

@end
