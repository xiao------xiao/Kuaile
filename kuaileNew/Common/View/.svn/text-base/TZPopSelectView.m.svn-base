//
//  TZPopInputView.m
//  kuaile
//
//  Created by liujingyi on 15/9/21.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZPopSelectView.h"

@interface TZPopSelectView ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TZPopSelectView

- (void)awakeFromNib {
    self.tableView.showsVerticalScrollIndicator = YES;
    // 有options值的时候，才设置数据源，才去加载数据
    self.options = [NSMutableArray arrayWithArray:nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setOptions:(NSMutableArray *)options {
     _options = options;
    [self.tableView reloadData];
    
    // 检查用户设置，是否需要把某个数据滚到某个位置
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.row > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.row inSection:0];
            self.position = self.position == UITableViewScrollPositionNone ? UITableViewScrollPositionMiddle:self.position;
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:self.position animated:YES];
            // 之后清空数据
            self.row = 0;
        }
    });
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZPopSelectView" owner:self options:nil] lastObject];
    }
    return self;
}

#pragma mark tableView数据源和代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"pop_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.options[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",self.options[indexPath.row]);
    if ([self.delegate respondsToSelector:@selector(popSelectViewDidSelectedCell:index:)]) {
        [self.delegate popSelectViewDidSelectedCell:self.options[indexPath.row] index:indexPath.row];
    }
    NSInteger idsd = indexPath.row;
    NSDictionary *info = @{@"selRow":@(indexPath.row + 1)};
    [mNotificationCenter postNotificationName:@"didClickPopSelectViewNoti" object:nil userInfo:info];
    // 复原位置
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

#pragma mark 按钮点击方法

- (IBAction)cancle:(id)sender {
    if ([self.delegate respondsToSelector:@selector(popSelectViewDidClickCancleButton)]) {
        [self.delegate popSelectViewDidClickCancleButton];
    }
}

@end
