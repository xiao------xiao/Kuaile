//
//  ICEUserInfoViewController.h
//  kuaile
//
//  Created by ttouch on 15/10/21.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICEUserInfoViewController : TZBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHead;
@property (weak, nonatomic) IBOutlet UILabel *labNickName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSex;
@property (weak, nonatomic) IBOutlet UILabel *labPhone;
@property (weak, nonatomic) IBOutlet UILabel *labHomeCity;
@property (weak, nonatomic) IBOutlet UILabel *labBirthday;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnDynamic;
@property (weak, nonatomic) IBOutlet UIView *viewDynamic;

// 参数，由userName去请求详情数据
@property (nonatomic, copy) NSString *userName;

@end
