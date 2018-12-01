//
//  XYPhotoViewController.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/9.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "TZBaseViewController.h"

@interface XYPhotoViewController : TZBaseViewController

@property (nonatomic, strong) UIImage *currentIcon;

@property (nonatomic, copy) void (^didSelecteAvatarBlock)(UIImage *image);

@property (nonatomic, assign) BOOL isOther;

@end
