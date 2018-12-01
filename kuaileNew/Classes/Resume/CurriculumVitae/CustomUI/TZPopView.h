//
//  TZPopView.h
//  kuaile
//
//  Created by liujingyi on 15/9/18.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TZPopViewButtonTypeLeft = 1,
    TZPopViewButtonTypeRight,
} TZPopViewButtonType;

@class TZPopView;
@protocol TZPopViewDelegate <NSObject>

- (void)popViewDidClickButton:(TZPopViewButtonType)buttonType;

@end
@interface TZPopView : UIView
@property (nonatomic, assign) id<TZPopViewDelegate> delegate;
@end
