//
//  HomeSectionHeaderView.h
//  kuaileNew
//
//  Created by admin on 2018/11/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeSectionHeaderViewDelegate<NSObject>
-(void)segmentIndex:(int)segIndex;
@end


@interface HomeSectionHeaderView : UIView

@property(nonatomic ,weak)id<HomeSectionHeaderViewDelegate> delegate;
@property(nonatomic, assign) NSInteger  index;
+(CGFloat)cellHeight;
@end
