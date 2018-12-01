//
//  HomeAdCell.h
//  kuaileNew
//
//  Created by admin on 2018/11/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ImageClickedBlock)(NSString *url,NSString *title);

@interface HomeAdCell : UITableViewCell


@property(nonatomic,copy) ImageClickedBlock imageClickedBlock;
+(CGFloat)cellHeight;

@end
