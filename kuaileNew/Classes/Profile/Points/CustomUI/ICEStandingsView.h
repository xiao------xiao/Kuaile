//
//  ICEStandingsView.h
//  kuaile
//
//  Created by ttouch on 15/10/16.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICEStandingsView : UIView

@property (weak, nonatomic) IBOutlet UILabel *latStandPoint;
@property (weak, nonatomic) IBOutlet UIButton *btnStandDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnStandConvert;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
