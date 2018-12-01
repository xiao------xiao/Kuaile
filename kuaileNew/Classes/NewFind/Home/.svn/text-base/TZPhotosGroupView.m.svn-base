//
//  TZPhotosGroupView.m
//  kuaile
//
//  Created by ttouch on 2016/12/26.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import "TZPhotosGroupView.h"
#import "TZFindSnsModel.h"
#import "MJPhotoBrowser.h"
#import "MWPhotoBrowser.h"

@interface TZPhotosGroupView ()<MWPhotoBrowserDelegate> {
    BOOL _flag;
}
@property (nonatomic, strong) NSMutableArray *imageViewArr;
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation TZPhotosGroupView

-(void)setImage:(NSString *)image {
    _image = image;
    UIImageView *imageView = [self createImageViewWithIndex:0];
    _flag = YES;
    ICEModelPicture *imageModel = image;
    imageView.frame = CGRectMake(8, 0, self.width-18, self.width-18);
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.images] placeholderImage:TZPlaceholderImage];
    [self addSubview:imageView];
    imageView.hidden = NO;
    [self setNeedsLayout];
}

- (void)setModels:(NSMutableArray *)models {
    _models = models;
    
    for (NSInteger i = 0; i < models.count; i++) {
        UIImageView *imageView = [self createImageViewWithIndex:i];
        ICEModelPicture *model = models[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.images] placeholderImage:TZPlaceholderImage];
        imageView.hidden = NO;
    }
    
    for (NSInteger i = models.count; i < self.imageViewArr.count; i++) {
        UIImageView *imageView = [self createImageViewWithIndex:i];
        imageView.hidden = YES;
    }
    [self setNeedsLayout];
}

-(NSMutableArray *)photos {
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (NSMutableArray *)imageViewArr {
    if (!_imageViewArr) {
        _imageViewArr = [NSMutableArray array];
    }
    return _imageViewArr;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_flag) {
        UIImageView *imageView = [self createImageViewWithIndex:0];
        imageView.frame = CGRectMake(8, 0, self.width -18, self.width-18);
        return;
    }
    
    for (NSInteger i = 0; i < self.imageViewArr.count; i++) {
        if (i < self.models.count) {
            UIImageView *imageView = [self createImageViewWithIndex:i];
            ICEModelPicture *model = self.models[i];
            if (self.models.count == 1) {
                imageView.frame = CGRectMake(8, 0, model.width, model.height);
            } else {
                CGFloat btnX = 8 + (model.width + 8) * (i % 3);
                CGFloat btnY = (model.width + 8) * (i / 3);
                imageView.frame = CGRectMake(btnX, btnY, model.width, model.width);
            }
        }
    }
}

- (UIImageView *)createImageViewWithIndex:(NSInteger)index {
    UIImageView *imageView;
    if (index < self.imageViewArr.count) {
        imageView = self.imageViewArr[index];
    } else {
        imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = index;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [imageView addGestureRecognizer:tap];
        [self.imageViewArr addObject:imageView];
        [self addSubview:imageView];
    }
    return imageView;
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [self.photos removeAllObjects];
    MWPhotoBrowser * browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    browser.displayNavArrows = YES;//左右分页切换,默认否
    browser.displayActionButton = NO;// 分享按钮默认是yes
    browser.startOnGrid = NO;//是否第一张,默认否
    browser.zoomPhotosToFill = YES;//是否全屏
    browser.alwaysShowControls = NO;//控制条件控件是否显示,默认否
    browser.enableSwipeToDismiss = NO;//是否开始对缩略图网格代替第一张照片
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.models.count; i++) {
        ICEModelPicture *model = self.models[i];
        MWPhoto * photo = [MWPhoto photoWithURL:[NSURL URLWithString:model.images]];
        photo.caption = [NSString stringWithFormat:@"第%i页", i+1];
        [array addObject:photo];
    }
    [self.photos addObjectsFromArray:array];
    [browser setCurrentPhotoIndex:tap.view.tag];
    [[UIViewController currentViewController].navigationController pushViewController:browser animated:YES];

}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id )photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}


@end
