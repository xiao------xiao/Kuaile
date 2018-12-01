//
//  HomeSectionHeaderView.m
//  kuaileNew
//
//  Created by admin on 2018/11/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "HomeSectionHeaderView.h"




@implementation HomeSectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self clickedButton:0];
    }
    return self;
}

-(void)setIndex:(NSInteger)index{
    _index = index;
   [self clickedButton:_index];
}
-(void)setupView{
    
    float btn_width = mScreenWidth/4;
    float btn_height = 26;
    
    [self addbottomGrayLine];
    NSArray *titleArr =@[@"全部职位",@"职位类型",@"离我最近",@"筛选"];
    
    for(int i = 0;i<titleArr.count;i++){
        UIButton *btn = [self createButtonWithFrame:CGRectMake(btn_width*i, (48-btn_height)/2, btn_width, btn_height) title:titleArr[i] fontSize:14 color:color_lightgray selectedColor:color_darkgray];
        btn.tag = 100+i;
        MJWeakSelf
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            UIButton *btn = (UIButton *)x;
            int buttonIndex = btn.tag - 100;
            NSLog(@"buttonindex clickecd --- %i",buttonIndex);
            [weakSelf clickedButton:buttonIndex];
            if ([weakSelf.delegate respondsToSelector:@selector(segmentIndex:)]) {
                [weakSelf.delegate segmentIndex:buttonIndex];
            }
            
        }];
        [self addSubview:btn];
        
        UIView *blueline = [[UIView alloc] init];
        blueline.layer.cornerRadius = 2;
        blueline.layer.masksToBounds = YES;
     
        blueline.tag = 200+i;
        blueline.backgroundColor = color_dark_blue;
        [self addSubview:blueline];
        
        
        [blueline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.centerX.mas_equalTo(btn.mas_centerX);
            make.height.mas_equalTo(4);
            make.width.mas_equalTo(32);
        }];
    }
    
    
}
-(void)addbottomGrayLine{
    UIView *grayline = [[UIView alloc] init];
    
    grayline.tag = 300;
    grayline.backgroundColor = color_whitegray;
    [self addSubview:grayline];
    
    [grayline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-4);
        make.height.mas_equalTo(SingleLineHeight);
    }];
}

-(void) clickedButton:(int)buttonIndex{
    [self hideBottomBlueLineView];
     UIView *lineview =  [self viewWithTag:200+buttonIndex];
     UIButton *btn = [self viewWithTag:100+buttonIndex];
    
    lineview.hidden = NO;
    btn.selected = YES;

}
-(void) hideBottomBlueLineView{
    for(int i = 0;i<4;i++){
       UIView *lineview =  [self viewWithTag:200+i];
        lineview.hidden = YES;
        
        UIButton *btn = [self viewWithTag:100+i];
        btn.selected = NO;
    }
}

-(UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title fontSize:(float)size color:(UIColor *)color selectedColor:(UIColor *)selectedColor {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:title forState:UIControlStateNormal];
    if (size>0) {
        btn.titleLabel.font = [UIFont systemFontOfSize:size];
    }
    if(color){
         [btn setTitleColor:color forState:UIControlStateNormal];
    }else{
        NSAssert(color !=nil, @"color 不能为空");
    }
    
    if(selectedColor){
        [btn setTitleColor:selectedColor forState:UIControlStateSelected];
    }else{
        [btn setTitleColor:color forState:UIControlStateSelected];

    }
    btn.frame = frame;
    return btn;
    
}
+(CGFloat)cellHeight{
    return 48+4;
}
@end
