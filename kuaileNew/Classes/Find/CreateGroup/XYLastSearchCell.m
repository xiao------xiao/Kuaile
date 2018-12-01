//
//  XYLastSearchCell.m
//  yinliaopifa
//
//  Created by 肖兰月 on 2016/12/18.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XYLastSearchCell.h"

@interface XYLastSearchCell ()
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *clickArray;
@property (nonatomic, strong) UIButton *selbtn;

@end

@implementation XYLastSearchCell

- (NSMutableArray *)btns {
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}
-(NSMutableArray *)clickArray {
    if (!_clickArray) {
        _clickArray = [NSMutableArray array];
    }
    
    return _clickArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.bounds;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = YES;
        [self.contentView addSubview:_scrollView];
        
        //设置默认状态
        [self setupDefaultStatus];
    }
    return self;
}

- (void)setupDefaultStatus {
    self.showBorder = YES;
    self.isSingleRow = NO;
    self.btnH = 34;
    self.margin = 15;
    self.addExtraBtnW = 40;
    self.btnFont = 14;
    self.hideBorderWhenSelected = YES;
    self.isMultipleSelected = YES;
    _scrollView.backgroundColor = [UIColor whiteColor];
}

- (void)setScrollViewBgColor:(UIColor *)scrollViewBgColor {
    _scrollViewBgColor = scrollViewBgColor;
    _scrollView.backgroundColor = scrollViewBgColor;
}

- (void)configButtonWithTag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    [button setTitleColor:TZColorRGB(74) forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.layer.cornerRadius = 17;
    button.clipsToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:self.btnFont];
    if (self.showBorder) {
        [button.layer setBorderColor:TZColorRGB(222).CGColor];
        [button.layer setBorderWidth:1];
    }
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btns addObject:button];
//    [self.contentView addSubview:button];
    [_scrollView addSubview:button];
}

- (void)setSearches:(NSArray *)searches {
    _searches = searches;
    for (int i = 0; i < searches.count; i++) {
        if (i >= self.btns.count) {
            [self configButtonWithTag:i];
        }
        UIButton *btn = self.btns[i];
        [btn setTitle:searches[i] forState:UIControlStateNormal];
    }
}

- (void)setNotClick:(BOOL)notClick {
    _notClick = notClick;
    if (notClick) {
        for (UIButton *btn in self.btns) {
            btn.userInteractionEnabled = NO;
        }
    }
}

- (void)setImage:(NSString *)image {
    _image = image;
    for (UIButton *btn in self.btns) {
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3);
    }
}

- (void)setBtnTextColor:(UIColor *)btnTextColor {
    _btnTextColor = btnTextColor;
    for (UIButton *btn in self.btns) {
        [btn setTitleColor:btnTextColor forState:UIControlStateNormal];
    }
}

- (void)setSelectedIndexes:(NSArray *)selectedIndexes {
    _selectedIndexes = selectedIndexes;
    if (selectedIndexes.count < 1) return;
    self.isMultipleSelected = YES;
    for (NSNumber *selecedIndex in selectedIndexes) {
        UIButton *selectedBtn = self.btns[selecedIndex.integerValue];
        [self buttonClick:selectedBtn];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    UIButton *selectedBtn = self.btns[selectedIndex];
    [self buttonClick:selectedBtn];
}

- (void)buttonClick:(UIButton *)btn {
    if (self.isMultipleSelected) { // 多选
        btn.selected = !btn.isSelected;
        if (btn.isSelected) {
            [btn setBackgroundColor:TZColor(0, 174, 255)];
            [btn setTitleColor:[UIColor whiteColor] forState:0];
            [btn.layer setBorderWidth:0];
            [self.clickArray addObject:@(btn.tag)];
        } else {
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitleColor:TZColorRGB(74) forState:0];
            if (self.showBorder) {
                if (self.hideBorderWhenSelected) {
                    [btn.layer setBorderWidth:1];
                }
            }
            [self.clickArray removeObject:@(btn.tag)];
        }
        if (self.selecteBtnBlock) {
            self.selecteBtnBlock(self.clickArray);
        }
        
    } else { // 单选
        if (btn.tag != self.selbtn.tag) {
            [self.selbtn setTitleColor:TZColorRGB(74) forState:0];
            [self.selbtn setBackgroundColor:[UIColor whiteColor]];
            self.selbtn.selected = NO;
            if (self.showBorder) {
                if (self.hideBorderWhenSelected) {
                    [self.selbtn.layer setBorderWidth:1];
                }
            }
        }
        [btn setBackgroundColor:TZColor(0, 174, 255)];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.selected = YES;
        
        if (self.searchListBtnClick) {
            self.searchListBtnClick(self.searches[btn.tag], btn.tag);
        }
    }
    self.selbtn = btn;  
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat btnY = 0;
    CGFloat btnH = self.btnH;
    CGFloat margin = self.margin;
    CGFloat loc = 0;
    CGFloat row = 0;
    CGFloat totalW = margin;
    CGFloat lastBtnY = 0;
    for (int i = 0; i < self.btns.count; i ++) {
        UIButton *btn = self.btns[i];
        CGFloat btnW = [CommonTools sizeOfText:self.searches[i] fontSize:self.btnFont].width + self.addExtraBtnW;
        if (self.isSingleRow) {
            btnW = (self.width - (self.btns.count + 1) * margin) / self.btns.count;
            CGFloat btnx = margin + (btnW + margin) * (i%self.btns.count);
            btnY = (self.height - btnH)/2.0;
            btn.frame = CGRectMake(btnx, btnY, btnW, btnH);
        } else {
            if (btnW + 2 * margin > mScreenWidth) {
                btnW = mScreenWidth - 2 * margin;
            }
            CGFloat btnX = totalW;
            if ((btnX + btnW) > mScreenWidth - margin) {
                row += 1;
                loc = 0;
                btnX = margin;
                totalW = btnW + margin +margin;
            } else {
                loc += 1;
                totalW += btnW + margin;
            }
            btnY = margin + (margin +btnH) *row;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        }
        
    }
    CGFloat contentH = btnY + btnH + margin;
    if (_searches.count == 0) {
        self.height = 0;
    } else {
        if (contentH > mScreenHeight - 64 - 45 - 34) {
            contentH = mScreenHeight - 64 - 45 - 34;
        }
        self.height = contentH;
    }
    _scrollView.frame = CGRectMake(0, 0, self.width, self.height);
    [_scrollView setContentSize:CGSizeMake(self.width, btnY + btnH + margin + 20)];
}



@end
