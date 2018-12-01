//
//  ICEModifierView.m
//  kuaile
//
//  Created by ttouch on 15/10/15.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICEModifierView.h"
#import "ICEModelGroup.h"
#import "ICEModelRecommend.h"

@interface ICEModifierView ()

#pragma mark 推荐群

// 推荐群 1
@property (weak, nonatomic) IBOutlet UIImageView *avatar1;
@property (weak, nonatomic) IBOutlet UILabel *gruopName1;
@property (weak, nonatomic) IBOutlet UILabel *gruopDesc1;
// 推荐群 2
@property (weak, nonatomic) IBOutlet UIImageView *avatar2;
@property (weak, nonatomic) IBOutlet UILabel *gruopName2;
@property (weak, nonatomic) IBOutlet UILabel *gruopDesc2;
// 推荐群 3
@property (weak, nonatomic) IBOutlet UIImageView *avatar3;
@property (weak, nonatomic) IBOutlet UILabel *gruopName3;
@property (weak, nonatomic) IBOutlet UILabel *gruopDesc3;
// 推荐群 4
@property (weak, nonatomic) IBOutlet UIImageView *avatar4;
@property (weak, nonatomic) IBOutlet UILabel *gruopName4;
@property (weak, nonatomic) IBOutlet UILabel *gruopDesc4;

#pragma mark 附近群
@property (weak, nonatomic) IBOutlet UIImageView *nearGruop1;
@property (weak, nonatomic) IBOutlet UIImageView *nearGruop2;
@property (weak, nonatomic) IBOutlet UIImageView *nearGruop3;
@property (weak, nonatomic) IBOutlet UIImageView *nearGruop4;

@end

@implementation ICEModifierView

- (void)awakeFromNib {
    // 配置按钮的enable
    self.recomGruop1.enabled = NO;
    self.recomGruop2.enabled = NO;
    self.recomGruop3.enabled = NO;
    self.recomGruop4.enabled = NO;
    
    self.btnGroupOne.enabled = NO;
    self.btnGroupTwo.enabled = NO;
    self.btnGroupThree.enabled = NO;
    self.btnGroupFour.enabled = NO;
    
    self.btnImgOne.enabled = NO;
    self.btnImgTwo.enabled = NO;
    self.btnImgThree.enabled = NO;
    self.btnImgFour.enabled = NO;
    
    // 配置imageView的hidden
    self.imgViewOne.hidden = YES;
    self.imgViewTwo.hidden = YES;
    self.imgViewThree.hidden = YES;
    self.imgViewFour.hidden = YES;
    
    self.nearGruop1.hidden = YES;
    self.nearGruop2.hidden = YES;
    self.nearGruop3.hidden = YES;
    self.nearGruop4.hidden = YES;
    
    self.avatar1.hidden = YES;
    self.avatar2.hidden = YES;
    self.avatar3.hidden = YES;
    self.avatar4.hidden = YES;
}

// 推荐群的数据
- (void)setRecomGruopModels:(NSArray *)recomGruopModels {
    _recomGruopModels = recomGruopModels;
   
    ICEModelGroup *gruop;
    
    // 配置第一个推荐群
    if (recomGruopModels.count > 0) {
        gruop = recomGruopModels[0];
        self.gruopName1.text = gruop.owner;
        self.gruopDesc1.text = gruop.desc;
        [self.avatar1 sd_setImageWithURL:[NSURL URLWithString:gruop.avatar]];
        
        self.recomGruop1.enabled = YES;
        self.avatar1.hidden = NO;
    } else {
        self.viewRecomGroup.hidden = YES;
    }
    
    // 配置第二个推荐群
    if (recomGruopModels.count > 1) {
        gruop = recomGruopModels[1];
        self.gruopName2.text = gruop.owner;
        self.gruopDesc2.text = gruop.desc;
        [self.avatar2 sd_setImageWithURL:[NSURL URLWithString:gruop.avatar]];
        
        self.recomGruop2.enabled = YES;
        self.avatar2.hidden = NO;
    }
    // 配置第三个推荐群
    if (recomGruopModels.count > 2) {
        gruop = recomGruopModels[2];
        self.gruopName3.text = gruop.owner;
        self.gruopDesc3.text = gruop.desc;
        [self.avatar3 sd_setImageWithURL:[NSURL URLWithString:gruop.avatar]];
        
        self.recomGruop3.enabled = YES;
        self.avatar3.hidden = NO;
    }
    // 配置第四个推荐群
    if (recomGruopModels.count > 3) {
        gruop = recomGruopModels[3];
        self.gruopName4.text = gruop.owner;
        self.gruopDesc4.text = gruop.desc;
        [self.avatar4 sd_setImageWithURL:[NSURL URLWithString:gruop.avatar]];
        
        self.recomGruop4.enabled = YES;
        self.avatar4.hidden = NO;
    }
}

- (void)setNearGruopModels:(NSArray *)nearGruopModels {
    _nearGruopModels = nearGruopModels;
    
    ICEModelGroup *gruop;
    
    // 配置第一个附近群
    if (nearGruopModels.count > 0) {
        gruop = nearGruopModels[0];
        [self.btnGroupOne setTitle:gruop.owner forState:UIControlStateNormal];
        [self.nearGruop1 sd_setImageWithURL:[NSURL URLWithString:gruop.avatar]];
        
        self.btnGroupOne.enabled = YES;
        self.nearGruop1.hidden = NO;
    } else {
        self.viewNearGroup.hidden = YES;
    }
    
    // 配置第二个附近群
    if (nearGruopModels.count > 1) {
        gruop = nearGruopModels[1];
        [self.btnGroupTwo setTitle:gruop.owner forState:UIControlStateNormal];
        [self.nearGruop2 sd_setImageWithURL:[NSURL URLWithString:gruop.avatar]];
        
        self.btnGroupTwo.enabled = YES;
        self.nearGruop2.hidden = NO;
    }
    // 配置第三个附近群
    if (nearGruopModels.count > 2) {
        gruop = nearGruopModels[2];
        [self.btnGroupThree setTitle:gruop.owner forState:UIControlStateNormal];
        [self.nearGruop3 sd_setImageWithURL:[NSURL URLWithString:gruop.avatar]];
        
        self.btnGroupThree.enabled = YES;
        self.nearGruop3.hidden = NO;
    }
    // 配置第四个附近群
    if (nearGruopModels.count > 3) {
        gruop = nearGruopModels[3];
        [self.btnGroupFour setTitle:gruop.owner forState:UIControlStateNormal];
        [self.nearGruop4 sd_setImageWithURL:[NSURL URLWithString:gruop.avatar]];
        
        self.btnGroupFour.enabled = YES;
        self.nearGruop4.hidden = NO;
    }
}

/*
 "avatar": "http://423823.ichengyun.net/hpjobweb/uploads/group/18321445508037.png",
 "owner": "苦逼的人",
 "desc": "专业外包20年",
 */

@end
