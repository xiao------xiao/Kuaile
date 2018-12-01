//
//  ICEMoneyTableViewCell.m
//  kuaile
//
//  Created by ttouch on 15/10/22.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICEMoneyTableViewCell.h"
#import "ICEModelMoney.h"

@implementation ICEMoneyTableViewCell

- (void)loadDataWith:(ICEModelMoney *)model {
    self.labTime.text = [[ICETools standardTime:model.create_time] substringToIndex:10];
    self.labCheck.text = model.content;
    self.latPoint.text = model.commission;
    self.labDesc.text = model.company;
}

@end
