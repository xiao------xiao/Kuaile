//
//  XYFoundationCell.h
//  kuaile
//
//  Created by 肖兰月 on 2017/3/1.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYFoundationCellType) {
    XYFoundationCellTypeAvater,
    XYFoundationCellTypeSwitch,
    
};

@interface XYFoundationCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat labelX;
@property (nonatomic, assign) CGFloat labelFont;
@property (nonatomic, strong) UIColor *labelTextColor;

@property (nonatomic, strong) UIImageView *moreView;
@property (nonatomic, assign) BOOL haveMoreView;

@property (nonatomic, strong) UIImageView *avater;
@property (nonatomic, copy) NSString *avatarPath;
@property (nonatomic, assign) BOOL isRoundCornor;
@property (nonatomic, assign) CGFloat avaterY;

@property (nonatomic, strong) UISwitch *swit;
@property (nonatomic, copy) void (^switValueChangeBlock)(BOOL isOn);

@property (nonatomic, copy) NSString *labelText;

@property (nonatomic, assign) XYFoundationCellType type;

@end
