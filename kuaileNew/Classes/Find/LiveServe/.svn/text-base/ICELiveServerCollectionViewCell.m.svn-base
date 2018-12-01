//
//  ICELiveServerCollectionViewCell.m
//  kuaile
//
//  Created by ttouch on 15/10/27.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICELiveServerCollectionViewCell.h"
#import "ICEModelLiveServer.h"
@implementation ICELiveServerCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ICELiveServerCollectionViewCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1) {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)loadDataModel:(ICEModelLiveServer *)model {
    self.labTitle.text = model.title;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:TZPlaceholderAvaterImage];
}

@end
