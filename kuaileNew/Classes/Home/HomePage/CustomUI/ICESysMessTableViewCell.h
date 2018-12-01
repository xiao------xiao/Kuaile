//
//  ICESysMessTableViewCell.h
//  kuaile
//
//  Created by ttouch on 15/10/28.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ICEModelSysMess;
@interface ICESysMessTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labDesc;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
- (void)loadDataModel:(ICEModelSysMess *)model;
@end
