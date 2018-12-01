//
//  TZPopInputView.h
//  kuaile
//
//  Created by liujingyi on 15/9/21.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TZPopSelectView;
@protocol  TZPopSelectViewDelegate<NSObject>
/** 点击了取消按钮 */
- (void)popSelectViewDidClickCancleButton;
/** 选中了 cellName 那个cell*/
- (void)popSelectViewDidSelectedCell:(NSString *)cellName index:(NSInteger)index;
@end

@interface TZPopSelectView : UIView
/** 选择框标题 */
@property (strong, nonatomic) IBOutlet UILabel *labTitle;
/** 选择框数据源,展示在tableView中 */
@property (nonatomic, strong) NSMutableArray *options;
@property (nonatomic, assign) id<TZPopSelectViewDelegate> delegate;

#pragma mark 额外设置

/** 需要把数据源中指定row对应的数据滚到中间/顶部/底部时设置 */
@property (nonatomic, assign) NSInteger row;
/** 滚到中间/顶部/底部具体哪个位置，默认为UITableViewScrollPositionMiddle */
@property (nonatomic, assign) UITableViewScrollPosition position;

@end
