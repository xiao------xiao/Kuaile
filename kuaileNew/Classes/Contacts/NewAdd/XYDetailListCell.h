//
//  XYDetailListCell.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/8.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYDetailListCell : UITableViewCell

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSAttributedString *attrText;
@property (nonatomic, copy) NSAttributedString *attrSubtext;
@property (nonatomic, copy) NSString *subText;

@property (nonatomic, strong) UIImageView *more;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat labelFont;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, assign) CGFloat subLabelFont;
@property (nonatomic, strong) UIColor *labelTextColor;
@property (nonatomic, strong) UIColor *subLabelTextColor;

@property (nonatomic, strong) UIColor *subLabelBgColor;
@property (nonatomic, assign) BOOL showBgColor;
@property (nonatomic, assign) BOOL calculateTextWidth;
/// 是否隐藏更对按钮  默认不隐藏
@property (nonatomic, assign) BOOL hideMoreView;


@property (nonatomic, assign) BOOL showAvatar_label;
@property (nonatomic, strong) UIImageView *avatar;

@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) BOOL showBottomLine;

@property (nonatomic, assign) CGFloat subLabelX;
@property (nonatomic, assign) CGFloat labelX;

/// 点击每个cell后选中的row
@property (nonatomic, assign) NSInteger selRow;
/// 是否点击过cell
@property (nonatomic, assign) BOOL didClickRow;


@property (nonatomic, strong) UIButton *accessoryBtn;
@property (nonatomic, assign) BOOL haveAccessoryBtn;
@property (nonatomic, copy) NSString *accessoryBtnText;
@property (nonatomic, strong) UIColor *accessoryBtnTextColor;
@property (nonatomic, assign) CGFloat accessoryBtnFont;


@property (strong, nonatomic) void (^didClickAccessoryBtnBlock)();

@end
