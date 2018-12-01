//
//  XYCertifyView.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/27.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYCertifyView : UIView

@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitBtn;
@property (weak, nonatomic) IBOutlet UIImageView *firstImgView;
@property (weak, nonatomic) IBOutlet UIImageView *lastImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lastImgConstraintW;



@property (nonatomic, copy) void (^didClickBtnBlock)();

@end
