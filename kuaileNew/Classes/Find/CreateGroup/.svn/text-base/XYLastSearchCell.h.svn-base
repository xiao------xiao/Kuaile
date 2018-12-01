//
//  XYLastSearchCell.h
//  yinliaopifa
//
//  Created by 肖兰月 on 2016/12/18.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYLastSearchCell : UITableViewCell

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *searches;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (strong, nonatomic) NSArray *selectedIndexes;

@property (nonatomic, copy) void (^searchListBtnClick)(NSString *text, NSInteger index);

@property (nonatomic, copy) void (^selecteBtnBlock)(NSArray *indexes);

///是否显示边框
@property (nonatomic, assign) BOOL showBorder;
/// 默认为YES
@property (nonatomic, assign) BOOL hideBorderWhenSelected;
/// 是否多选,默认多选
@property (nonatomic, assign) BOOL isMultipleSelected;

@property (nonatomic, strong) UIColor *scrollViewBgColor;

@property (nonatomic, assign) BOOL isSingleRow;

@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) BOOL notClick;
@property (nonatomic, assign) CGFloat btnH;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat addExtraBtnW;
@property (nonatomic, assign) CGFloat btnFont;
@property (nonatomic, strong) UIColor *btnTextColor;

@end
