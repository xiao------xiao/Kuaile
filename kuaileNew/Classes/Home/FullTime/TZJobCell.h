//
//  TZJobCell.h
//  HappyWork
//
//  Created by liujingyi on 15/9/11.
//  Copyright (c) 2015年 memberwine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZJobCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleLeftToSuperViewContraint;
@property (strong, nonatomic) IBOutlet UIView *divideView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *divideLeftToSuperViewContraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *divideWidthContraint;

@end
