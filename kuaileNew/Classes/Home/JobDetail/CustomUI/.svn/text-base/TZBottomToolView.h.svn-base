//
//  TZBottomToolView.h
//  kuaile
//
//  Created by liujingyi on 15/9/23.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TZBottomToolViewButtonTypeApply = 1,   // 申请
//    TZBottomToolViewButtonTypeCall,        // 电话
    TZBottomToolViewButtonTypeService,     // 在线客服
    TZBottomToolViewButtonTypeComment,
} TZBottomToolViewButtonType;

@class TZBottomToolView;
@protocol  TZBottomToolViewDelegate<NSObject>

- (void)bottomToolViewClickButtonType:(TZBottomToolViewButtonType)type;

@end

@interface TZBottomToolView : UIView
@property (strong, nonatomic) IBOutlet UILabel *views;
@property (nonatomic, assign) TZBottomToolViewButtonType type;
@property (nonatomic, assign) id<TZBottomToolViewDelegate> delegate;
@end
