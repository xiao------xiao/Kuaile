//
//  ORSigningView.h
//  kuaile
//
//  Created by 欧阳荣 on 2017/3/22.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ORSigningViewDelegate <NSObject>

- (void)normalSignBtnDidPressed;
- (void)photoSelfBtnDidPressed;

@end

@interface ORSigningView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *shadowLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (nonatomic, assign) id<ORSigningViewDelegate> delegate;

@end
