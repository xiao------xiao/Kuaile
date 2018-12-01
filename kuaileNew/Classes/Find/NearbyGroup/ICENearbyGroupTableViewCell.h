//
//  ICENearbyGroupTableViewCell.h
//  kuaile
//
//  Created by ttouch on 15/10/17.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ICEModelGroup;

@interface ICENearbyGroupTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *labTitile;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labDesc;

- (void)loadDataWith:(ICEModelGroup *)modelPeople;

@end
