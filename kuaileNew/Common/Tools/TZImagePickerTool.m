//
//  UITools.m
//  微信
//
//  Created by huangdl on 15/9/24.
//  Copyright (c) 2015年 黄驿. All rights reserved.
//

#import "TZImagePickerTool.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface TZImagePickerTool ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UIViewController *_vc;
    BOOL _isEdit;
}
@property (nonatomic,copy) void(^editedCB)(UIImage *origionImg,UIImage *editedImage);
@property (nonatomic,copy) void(^cb)(UIImage *img);
@end


@implementation TZImagePickerTool

+ (instancetype)tools {
    static TZImagePickerTool *_t = nil;
    if (!_t) {
        _t = [[TZImagePickerTool alloc]init];
    }
    return _t;
}

- (void)selectImageFrom:(id)obj complete:(void(^)(UIImage *img))cb {
    _vc = obj;
    _cb = cb;
    _isEdit = NO;
    [self showActionSheet];
}

- (void)selectImageForEditFrom:(id)obj complete:(void(^)(UIImage *origionImg,UIImage *editedImage))cb {
    _vc = obj;
    _editedCB = cb;
    _isEdit = YES;
    [self showActionSheet];
}

- (void)showActionSheet {
    // 提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc] init];
        [PickerImage.navigationBar setBackgroundImage:[UIImage imageNamed:@"tapbackground"] forBarMetrics:UIBarMetricsDefault];
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [_vc presentViewController:PickerImage animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
            PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
            PickerImage.allowsEditing = YES;
            PickerImage.delegate = self;
            [_vc presentViewController:PickerImage animated:YES completion:nil];
        } else {
            [self showAlertViewWithTitle:@"该设备不支持拍照"];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [_vc presentViewController:alert animated:YES completion:nil];
}

+ (void)selectImageFrom:(id)obj complete:(void(^)(UIImage *img))cb {
    [[TZImagePickerTool tools] selectImageFrom:obj complete:cb];
}

+ (void)selectImageForEditFrom:(id)obj complete:(void(^)(UIImage *origionImg,UIImage *editedImage))cb {
    [[TZImagePickerTool tools] selectImageForEditFrom:obj complete:cb];
}

#pragma mark --图片选择器的代理

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@",info);
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    image = [self fixOrientation:image];
    UIImage *editImage = info[UIImagePickerControllerEditedImage];
    editImage = [self fixOrientation:editImage];
    
    UIImage *cutDownEditImage = [self imageScale:editImage size:CGSizeMake(800, 800 * editImage.size.height / editImage.size.width)];
    UIImage *cutDownImage = [self imageScale:image size:CGSizeMake(800, 800 * image.size.height / image.size.width)];
    if (_isEdit) {
        _editedCB(cutDownImage,cutDownEditImage);
    } else {
        _cb(cutDownImage);
    }
}

#pragma mark - 私有方法

/**
 *  压缩图片尺寸,方便上传服务器
 */
- (UIImage *)imageScale:(UIImage *)img size:(CGSize)size{
    if (size.width <= img.size.width) {
        return img;
    }
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
