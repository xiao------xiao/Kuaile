//
//  ICEIssueViewController.m
//  kuaile
//
//  Created by ttouch on 15/10/27.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICEIssueViewController.h"
#import <Photos/Photos.h>
#import "TZImagePickerController.h"
#import "TZTestCell.h"

@interface ICEIssueViewController ()
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *assetArray;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *labPlaceholder;
@end

@implementation ICEIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布";
    [self dataInit];
    [self configCollectionView];
    [self.textView becomeFirstResponder];
}

- (void)dataInit {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    [self configTextView];
}

- (void)configTextView {
    [self.textView.rac_textSignal subscribeNext:^(NSString *x) {
        if (x.length == 0) {
            self.labPlaceholder.hidden = NO;
        } else {
            self.labPlaceholder.hidden = YES;
        }
    }];
    self.textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)configCollectionView {
    [self.collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.collectionView.alwaysBounceVertical = YES;
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (_dataArray.count + 1) >= 9 ? 9 : (_dataArray.count + 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.tag = indexPath.item;
    cell.deleteBtn.hidden = YES;
    cell.videoImageView.hidden = YES;
    if (self.dataArray.count) {
        if (indexPath.row == self.dataArray.count) {
            cell.imageView.image = [UIImage imageNamed:@"addpic"];
        } else {
            cell.imageView.image = self.dataArray[indexPath.row];
            cell.deleteBtn.hidden = NO;
        }
    } else {
        cell.imageView.image = [UIImage imageNamed:@"addpic"];
    }
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = __kScreenWidth / 3 - 20;
    return CGSizeMake(width, width);
}

// 定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

#pragma mark --UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if ((self.dataArray && indexPath.row == self.dataArray.count) || !self.dataArray) {
        [self presentImagePickerVc];
    } else { // 预览照片
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_assetArray selectedPhotos:_dataArray index:indexPath.row];
        imagePickerVc.isSelectOriginalPhoto = NO;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _assetArray = [NSMutableArray arrayWithArray:assets];
            _dataArray = [NSMutableArray arrayWithArray:photos];
            [self.collectionView reloadData];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

// 返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark 按钮点击事件
- (void)deleteBtnClik:(UIButton *)sender {
    [_dataArray removeObjectAtIndex:sender.tag];
    [_assetArray removeObjectAtIndex:sender.tag];
    
    if (_dataArray.count <= 7) {
        [_collectionView performBatchUpdates:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [_collectionView reloadData];
        }];
    } else {
        [_collectionView reloadData];
    }
}

- (void)done {
    // 如果没有填写发布内容，提示用户填写
    NSString *newStr = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (newStr.length < 1) {
        if (self.dataArray.count < 1) {
            [self.view endEditing:YES];
            [self showInfo:@"请填写发布内容"];
            return;
        }
    }
    // 有发布内容，请求网络
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary: @{ @"content" : self.textView.text, @"imgs": @"ImgReleaseDynamic",}];
    NSMutableArray *fileArr = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        UIImage *image = self.dataArray[i];
        NSDictionary *dict = @{
                               @"file" : image,
                               @"name" : [NSString stringWithFormat:@"imgGroup%ld.png",(long)i],
                               @"key" : [NSString stringWithFormat:@"imgs%ld",(long)i]
                               };
        [fileArr addObject:dict];
    }
    RACSignal *signal = [ICEImporter releaseDynamicWithParams:params files:fileArr];
    [self showHudInView:self.view hint:@"发布中..."];
    [signal subscribeCompleted:^{
        [self hideHud];
        [self showInfo:@"发布成功!"];
        [self performSelector:@selector(popViewCtrl) withObject:nil afterDelay:0.5f];
    }];
}

#pragma mark - 私有方法

/// 去选择照片
- (void)presentImagePickerVc {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.selectedAssets = _assetArray;
    imagePickerVc.navigationBar.tintColor = [UIColor whiteColor];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.navigationBar.barTintColor = __kNaviBarColor;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isSelectOriginalPhoto) {
        _assetArray = [NSMutableArray arrayWithArray:assets];
        _dataArray = [NSMutableArray arrayWithArray:photos];
        [self.collectionView reloadData];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)popViewCtrl {
    if (self.issueBlock) {
        self.issueBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
