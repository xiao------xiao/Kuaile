//
//  ZYYCreateTopicCell.m
//  DemoProduct
//
//  Created by liujingyi on 16/1/4.
//  Copyright © 2016年 周毅莹. All rights reserved.
//

#import "ZYYCreateTopicCell.h"

@implementation ZYYCreateTopicCell

- (void)awakeFromNib {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
    
    _imageUrl.contentMode = UIViewContentModeScaleAspectFill;
    _imageUrl.clipsToBounds = YES;
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    if (self.longPressHandle) {
        self.longPressHandle(self);
    }
}

/*
 [cell setLongPressHandle:^(UIView *cellBack) {
     if (cellBack.tag == self.dataArray.count) return ;
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请确认是否需要删除选中的照片" message:@"" preferredStyle: UIAlertControllerStyleActionSheet];
         UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
     }];
     [alertController addAction:cancelAction];
     UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
     [self.dataArray removeObjectAtIndex:cellBack.tag];
     [self.assetArray removeObjectAtIndex:cellBack.tag];
     [self.collectionView reloadData];
 }];
 [alertController addAction:delAction];
 [self presentViewController:alertController animated:YES completion:nil];
 }];*/


@end
