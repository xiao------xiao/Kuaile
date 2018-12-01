//
//  XYPhotoView.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/27.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYShowPhotoView : UIView


@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UIButton *guohuiBtn;

@property (nonatomic, copy) void (^didClickPhotoBtn)(NSInteger tag);

@end
