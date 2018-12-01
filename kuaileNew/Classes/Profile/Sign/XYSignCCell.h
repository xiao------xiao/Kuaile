//
//  XYSignCCell.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/18.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ORSignModel;
@interface XYSignCCell : UICollectionViewCell

@property (nonatomic, strong) ORSignModel *model;

@end

@interface ORSignModel : NSObject

@property (nonatomic, copy) NSString *is_sign;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *href;
@property (nonatomic, copy) NSString *date;

+ (NSInteger)currentDateNumber;

@end
