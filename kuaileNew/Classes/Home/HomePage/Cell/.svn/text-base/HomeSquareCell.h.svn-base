//
//  HomeSquareCell.h
//  kuaileNew
//
//  Created by admin on 2018/11/23.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^SquareViewPressedBlock) (int tagIndex);


@interface HomeSquareCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_1;

@property (weak, nonatomic) IBOutlet UIImageView *img_2;
@property (weak, nonatomic) IBOutlet UIImageView *img_3;
@property (weak, nonatomic) IBOutlet UIImageView *img_4;

@property (weak, nonatomic) IBOutlet UILabel *lbl_1;
@property (weak, nonatomic) IBOutlet UILabel *lbl_2;
@property (weak, nonatomic) IBOutlet UILabel *lbl_3;
@property (weak, nonatomic) IBOutlet UILabel *lbl_4;

@property (weak, nonatomic) IBOutlet UIImageView *img_5;
@property (weak, nonatomic) IBOutlet UIImageView *img_6;
@property (nonatomic,copy) SquareViewPressedBlock blockSquareViewPressed;



+(instancetype)xibCell;
+(CGFloat)cellHeight;
- (IBAction)buttonPressed:(id)sender;


@end
