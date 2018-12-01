/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */


#import "UIImageView+HeadImage.h"

@implementation UIImageView (HeadImage)

- (void)imageWithUsername:(NSString *)username placeholderImage:(UIImage*)placeholderImage
{
    if (placeholderImage == nil) {
        placeholderImage = [UIImage imageNamed:@"chatListCellHead"];
    }
    [self sd_setImageWithURL:nil placeholderImage:placeholderImage];
}

@end

@implementation UILabel (Prase)

- (void)setTextWithUsername:(NSString *)username {
    NSString *nickname = [TZEaseMobManager nickNameWithUsername:username];
    if ([nickname isEqualToString:username]) {
        if ([ICETools isMobileNumber:username]) {
            [self setText:[NSString stringWithFormat:@"%@****%@", [username substringToIndex:3], [username substringFromIndex:7]]];
        } else {
            [self setText:username];
        }
    } else {
        [self setTextWithUsername:nickname];
    }
}

@end
