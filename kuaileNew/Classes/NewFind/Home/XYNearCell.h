//
//  XYNearCell.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/13.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  XYNearCellDelegate<NSObject>
- (void)XYNearCelldelegate:(NSInteger)tag;
@end



@class XYAvaterView,HJSnsGetNearPeople;

@interface XYNearCell : UITableViewCell
@property (nonatomic, assign) id<XYNearCellDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *containerViews;
@property (nonatomic, strong) XYAvaterView *avaterView;
@property (nonatomic, strong) HJSnsGetNearPeople * model;
@property (nonatomic, assign) CGFloat containerWidth;
@property (nonatomic, assign) CGFloat imgViewY;
@property (nonatomic, assign) CGFloat fontSize;

@property (nonatomic, assign) CGFloat imgCornerRadius;
@property (nonatomic, assign) BOOL hideSexBtn;
@property (nonatomic, copy) void (^XYNearCellViewBlock)(NSInteger tage);

- (void)configButtonWithImages:(NSArray *)images titles:(NSArray *)titles ages:(NSArray *)ages gender:(NSArray *)gender;

@end
