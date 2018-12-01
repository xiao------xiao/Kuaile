//
//  GroupDetail.h
//  kuaile
//
//  Created by 胡光健 on 2017/3/24.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class memberModel;
@interface GroupDetail : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mainimageView;
//@property (strong, nonatomic) memberModel *model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLayout;

@property(nonatomic,strong) UIView * imageVi;
@property (nonatomic,strong) NSMutableArray <NSString *>* model;
@end
