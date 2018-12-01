//
//  PublicView.h
//  kuaileNew
//
//  Created by admin on 2018/11/29.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicView : NSObject
+(UIButton *)createButtonWithTitle:(NSString *)title bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor textFont:(UIFont *)font cornerRadios:(CGFloat)radios;
//只有图片的button
+(UIButton *)createImageButton:(NSString *)imageName;
// 创建类似登陆的按钮
+(UIButton *)createLoginNormalButtonWithTitle:(NSString *)title;
//创建图片的button
+(UIButton *)createPictureButtonWithNormalImage:(NSString *)imageName selectImage:(NSString *)selectImageName;

+(UITextField *)textfieldWithPlaceholder:(NSString *)holder font:(UIFont *)font textAlign:(NSTextAlignment)textAlign delegate:(id)delegate tag:(int)tag;
//创建普遍输入框
+(UITextField *)createTextfeildNormalWithPlaceHolder:(NSString *)holder delegate:(id)delegate tag:(int)tag;


//创建Label
+(UILabel *)createLabelWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font textAlignment:(NSTextAlignment)align;
//创建ImageView
+(UIImageView *)createImageViewWithImage:(NSString *)imageName;
@end
