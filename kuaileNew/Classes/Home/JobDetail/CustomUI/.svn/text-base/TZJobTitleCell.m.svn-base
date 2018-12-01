//
//  TZJobTitleCell.m
//  kuaile
//
//  Created by liujingyi on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZJobTitleCell.h"
#import "TZJobModel.h"

@interface TZJobTitleCell ()

@property (strong, nonatomic) IBOutlet UILabel *jobTitle;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIButton *collection;

@end

@implementation TZJobTitleCell


- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZJobTitleCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZJobTitleCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    self.width = __kScreenWidth;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)collection:(UIButton *)sender {
    if (![TZUserManager isLogin]) return;
    NSString * sessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionid"];
    NSDictionary *params = @{@"recruit_id":self.model.recruit_id,@"sessionid":sessionid};
    
    if (self.collection.selected == YES) { // 取消收藏
        [TZHttpTool postWithURL:ApiSnsDelFav params:params success:^(id json) {
            DLog(@"取消收藏成功 %@",json);
            self.collection.selected = NO;
            self.showInfoMessageBolck(@"取消收藏成功");
            // 这里要刷新 收藏列表 的数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"haveCancleCollection" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"collectDidChange" object:self];

        } failure:^(NSString *error) {
            DLog(@"取消收藏失败 %@",error);
            self.showInfoMessageBolck(@"取消收藏失败，请稍后重试");
        }];
    } else { // 收藏
        [TZHttpTool postWithURL:ApiSnsFavorite params:params success:^(id json) {
            DLog(@"收藏成功 %@",json);
            self.collection.selected = YES;
            self.showInfoMessageBolck(@"收藏成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"collectDidChange" object:self];

        } failure:^(NSString *error) {
            DLog(@"收藏失败 %@",error);
            self.showInfoMessageBolck(@"收藏失败，请稍后重试");
        }];
    }
}

- (void)setModel:(TZJobModel *)model {
    _model = model;
    self.jobTitle.text = model.recruit_name;
    self.time.text = model.start_time;
}


// 设置收藏状态
- (void)setHaveCollection:(BOOL)haveCollection {
    _haveCollection = haveCollection;
    if (haveCollection == YES) {
        self.collection.selected = YES;
    }
}

@end
