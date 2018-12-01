//
//  XYGroupTagViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/9.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYGroupTagViewController.h"
#import "XYLastSearchCell.h"
#import "XYConfigTool.h"

@interface XYGroupTagViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XYLastSearchCell *searchListView;
@property (nonatomic, strong) XYConfigTool *tool;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, strong) NSArray *textArr;
@end

@implementation XYGroupTagViewController

static NSInteger _index;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群标签";
    self.rightNavTitle = @"确定";
    _tool = [[XYConfigTool alloc] init];
    _tool.configArr = @[@"求职",@"偶遇",@"电影",@"企业",@"工作",@"约聊",@"LOL",@"DOTA2",@"唱歌",@"桌球",@"健身"];
    [self configScrollView];
}

- (void)configScrollView {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = YES;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_scrollView];
    
    _searchListView = [[XYLastSearchCell alloc] init];
    _searchListView.scrollViewBgColor = TZControllerBgColor;
    _searchListView.showBorder = NO;
    _searchListView.isMultipleSelected = NO;
    _searchListView.searches = _tool.configArr;
    
    CGFloat searchListH = _tool.configArrH;
    if (_tool.configArrH > mScreenHeight - 64 - 45 - 34) {
        searchListH = mScreenHeight - 64 - 45 - 34;
    }
    _searchListView.frame = CGRectMake(0, 0, mScreenWidth, searchListH);
    MJWeakSelf
    [_searchListView setSearchListBtnClick:^(NSString * text, NSInteger index) {
        weakSelf.tag = text;
        weakSelf.index = index;
       
    }];
    _searchListView.selectedIndex = self.index;
    [_scrollView addSubview:_searchListView];
    
}

- (void)didClickRightNavAction {
    if (self.didClickRightBtnBlock) {
        self.didClickRightBtnBlock(self.tag, self.index);
    }
    [self.navigationController popViewControllerAnimated:YES];
}



@end
