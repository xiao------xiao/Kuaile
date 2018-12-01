//
//  TZJobBodyCell.m
//  kuaile
//
//  Created by liujingyi on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZJobBodyCell.h"
#import "TZJobModel.h"
#import "XYConfigTool.h"
#import "XYLastSearchCell.h"

@interface TZJobBodyCell ()
/** 薪水 */
@property (strong, nonatomic) IBOutlet UILabel *salary;
/** 薪水单位 */
@property (strong, nonatomic) IBOutlet UILabel *moneyPerMonth;
/** 招聘公司 */
@property (strong, nonatomic) IBOutlet UILabel *company;
/** 公司地点 */
@property (strong, nonatomic) IBOutlet UILabel *area;
/** 认证 */
@property (weak, nonatomic) IBOutlet UIImageView *certifyImageView;

/** 招聘人数 */
@property (strong, nonatomic) IBOutlet UILabel *count;
/** 学历要求 */
@property (strong, nonatomic) IBOutlet UILabel *grade;
/** 经验要求 */
@property (strong, nonatomic) IBOutlet UILabel *experience;
/** 福利*/
@property (strong, nonatomic) IBOutlet UILabel *welfare;
/** 职位描述 */
@property (strong, nonatomic) IBOutlet UILabel *jobIntroduce;
/** 职位类型 */
@property (strong, nonatomic) IBOutlet UILabel *jobType;
/** 工作时限 */
@property (strong, nonatomic) IBOutlet UILabel *wortTime;
@property (weak, nonatomic) IBOutlet UIView *walfareSupView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *welfareH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *welfareSupViewH;
@property (weak, nonatomic) IBOutlet UIView *welfareSupSupView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fanxianSupViewH;
@property (weak, nonatomic) IBOutlet UIView *jobDecSupView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobDecH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobDecSupViewH;
@property (weak, nonatomic) IBOutlet UIView *entryView; //  入职返现的View
@property (weak, nonatomic) IBOutlet UILabel *industryLabel;// 行业类别
@property (weak, nonatomic) IBOutlet UILabel *companyNumLabel;// 公司人数
@property (weak, nonatomic) IBOutlet UILabel *fanxianLabel;// 入职返现content
@property (weak, nonatomic) IBOutlet UILabel *fanxianPeopLabel;// 入职返现的注释

@property (nonatomic, assign) CGFloat fareViewH;

@end

@implementation TZJobBodyCell {
    CGFloat _height1;
    CGFloat _height2;
    NSInteger _welfareCount;
    CGFloat _welfareRealH;
    CGFloat _jobDecRealH;
    CGFloat _pImgViewWH;
    CGFloat _otherCellH;
}

- (void)awakeFromNib {
    // Initialization code
    _height1 = 50;
    _height2 = 50;
    self.walfareSupView.clipsToBounds = YES;
    self.welfareSupSupView.clipsToBounds = YES;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZJobBodyCell" owner:self options:nil] lastObject];
    }
    return self;
}

/** 职位描述的那块内容的高度是动态更新的，因此初始化的时候把职位描述的内容传过来 */
- (instancetype)initWithJobIntroduce:(NSString *)jobIntroduce welfare:(NSString *)welfare{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZJobBodyCell" owner:self options:nil] lastObject];
        
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TZJobBodyCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setModel:(TZJobModel *)model {
    _model = model;
    // 设置默认状态Lable高度
    [self setFrame];
    // 薪水显示处理
    NSString *salary = self.model.salary;
    if ([salary containsString:@"以下"] || [salary containsString:@"以上"]) {
        self.moneyPerMonth.text = [salary substringFromIndex:salary.length - 2];
        self.salary.text = [salary substringToIndex:salary.length - 2];
    } else if ([salary containsString:@"元"]) {
        self.salary.text = [salary substringToIndex:salary.length - 1];
    } else if ([salary isEqualToString:@"不限"] || [salary isEqualToString:@"面议"]) {
        self.moneyPerMonth.text = @"";
        self.salary.text = salary;
    }
    
    // 10.17 薪资显示工作时限
    if (self.model.work_time) {
        self.wortTime.text = self.model.work_time;
    }
    self.area.text = self.model.address;
    self.count.text = [NSString stringWithFormat:@"%@人",self.model.recruit_num];
    self.grade.text = self.model.degree;
    self.experience.text = self.model.work_exp;
    NSString *htmlString = self.model.welfare;
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.welfare.attributedText = attrStr;
    self.jobIntroduce.text = self.model.job_desc;
    self.jobType.text = self.model.jobs_property;
    self.industryLabel.text = self.model.company_industry;
    self.companyNumLabel.text = [NSString stringWithFormat:@"%@人",self.model.company_scope];
    // 公司名字Lable 属性字体
    UIFont *companyNameFont = [UIFont systemFontOfSize:13];
    NSMutableAttributedString *companyName = [[NSMutableAttributedString alloc] init];
    NSAttributedString *companyLable = [[NSAttributedString alloc] initWithString:self.model.company_name attributes:@{NSFontAttributeName:companyNameFont,NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.bounds = CGRectMake(2, -3, companyNameFont.lineHeight, companyNameFont.lineHeight);
    NSAttributedString *verifyImage = [NSAttributedString attributedStringWithAttachment:attch];
    [companyName appendAttributedString:companyLable];
    self.company.attributedText = companyName;
    
    self.fanxianLabel.text = [NSString stringWithFormat:@"%@",model.return_money];
    
    // 诚信认证
    
    self.certifyImageView.hidden = [model.verify isEqualToNumber:@1] ? NO : YES;
    /*
     CGFloat companyWidth = [self.model.company_name boundingRectWithSize:CGSizeMake(__kScreenWidth - 105, CGFLOAT_MAX) options:1 attributes:@{} context:nil].size.width + 1;
     self.companyWidthConstraint.constant = companyWidth;
     */
}

- (void)setFrame {
    _welfareCount = 9;
    NSMutableArray  *wefareArr = [NSMutableArray array];
    if ([self.model.welfare isKindOfClass:[NSString class]])  {
        if ([self.model.welfare containsString:@"-"]) {
             NSMutableArray * array = [self.model.welfare componentsSeparatedByString:@"-"];
            
//            for (int i = 0; i <array.count; i ++) {
//                _pImgViewWH = 30;
//                UILabel *lbl = [[UILabel alloc] init];
//                UIImageView *pImgView = [[UIImageView alloc] init];
//                pImgView.image = [UIImage imageNamed:@"dian"];
//                lbl.font = [UIFont systemFontOfSize:12];
//                lbl.textColor = TZColorRGB(120);
//                CGFloat totalW = (mScreenWidth - 20) / 4;
//                CGFloat lblW = totalW;
//                CGFloat lblH = _pImgViewWH;
//                CGFloat lblY = i / 4 *(lblH + 5);
//                CGFloat lblX = i % 4 *totalW + 10;
//                CGFloat pImgViewX = i % 4 *totalW;
//                pImgView.frame = CGRectMake(pImgViewX, lblY + 10, _pImgViewWH -20, _pImgViewWH -20);
//                lbl.frame = CGRectMake(lblX, lblY, lblW, lblH);
//                lbl.text = array[i];
//                [self.walfareSupView addSubview:lbl];
//                [self.walfareSupView addSubview:pImgView];
//            }
            
            XYConfigTool *tool = [[XYConfigTool alloc] init];
            tool.margin = 5;
            tool.extraAddWidth = 20;
            tool.btnH = 20;
            tool.btnFont = 12;
            tool.configArr = array;
            
            XYLastSearchCell *fareView = [[XYLastSearchCell alloc] init];
            fareView.showBorder = NO;
            fareView.margin = 5;
            fareView.addExtraBtnW = 20;
            fareView.btnFont = 12;
            fareView.btnH = 20;
            fareView.searches = tool.configArr;
            self.fareViewH = tool.configArrH;
            fareView.image = @"dian";
            fareView.btnTextColor = TZColorRGB(120);
            fareView.notClick = YES;
            fareView.scrollView.scrollEnabled = NO;
            fareView.frame = CGRectMake(0, 0, mScreenWidth, self.fareViewH);
            [self.walfareSupView addSubview:fareView];
        }else {
            _pImgViewWH = 30;
            UILabel *lbl = [[UILabel alloc] init];
            lbl.numberOfLines = 2;
            UIImageView *pImgView = [[UIImageView alloc] init];
            pImgView.image = [UIImage imageNamed:@"dian"];
            lbl.font = [UIFont systemFontOfSize:12];
            lbl.textColor = TZColorRGB(120);
            CGFloat totalW = (mScreenWidth - 20) / 4;
            CGFloat lblW = totalW;
            CGFloat lblH = _pImgViewWH;
            pImgView.frame = CGRectMake(0, 15, _pImgViewWH -20, _pImgViewWH -20);
            lbl.frame = CGRectMake(12, 6, lblW, lblH);
            lbl.text = self.model.welfare;
            [self.walfareSupView addSubview:lbl];
            [self.walfareSupView addSubview:pImgView];
        }
        
        
    }
    _jobDecRealH = [self.model.job_desc boundingRectWithSize:CGSizeMake(__kScreenWidth - 10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
    
    self.welfareH.constant = self.fareViewH;
    self.welfareSupViewH.constant = self.fareViewH;
    
//    if (_welfareCount < 5) {
//        _welfareRealH = 25;
//        self.welfareSupViewH.constant = _welfareRealH;
//        self.welfareH.constant = _welfareRealH;
//    } else if (_welfareCount < 9) {
//        _welfareRealH = 50;
//        self.welfareSupViewH.constant = _welfareRealH;
//        self.welfareH.constant = _welfareRealH;
//    } else {
//        _welfareRealH = 50 + 30;
//        self.welfareH.constant = _welfareRealH - 30;
//        self.welfareSupViewH.constant = _welfareRealH;
//    }
    
    if (_jobDecRealH <= 50) {
        self.jobDecH.constant = _jobDecRealH;
        self.jobDecSupViewH.constant = _jobDecRealH;
    } else {
        _jobDecRealH = 50 +30;
        self.jobDecH.constant = _jobDecRealH - 30;
        self.jobDecSupViewH.constant = _jobDecRealH;
    }
    if ([self.model.fan isEqual:@"1"]) {
        _otherCellH = 360;
    } else {
        self.fanxianSupViewH.constant = 0;
        _otherCellH = 300;
    }
    self.frame = CGRectMake(0, 61, __kScreenWidth, _otherCellH + _welfareRealH +_jobDecRealH);
    if (self.blockChangeViewH) {
        self.blockChangeViewH(self.frame);
    }
}

- (IBAction)clickMoreComWelfare:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.selected) {
//        _height1 = _welfareCount / 4 *(_pImgViewWH + 5) + _pImgViewWH;
        _height1 = self.fareViewH;
    } else {
        _height1 = 50;
    }
    
    [UIView animateWithDuration:.1 animations:^{
        self.welfareH.constant = _height1;
        self.welfareSupViewH.constant = _height1 + 30;
        [self.walfareSupView layoutIfNeeded];
        [self.welfareSupSupView layoutIfNeeded];
    }];
    if (_jobDecRealH > 50) {
        self.frame = CGRectMake(0, 61, __kScreenWidth, _otherCellH + 60 + _height1 + _height2);
    } else {
        self.frame = CGRectMake(0, 61, __kScreenWidth, _otherCellH + 30 + _height1 + _jobDecRealH);
    }
    if (self.blockChangeViewH) {
        self.blockChangeViewH(self.frame);
    }
}

- (IBAction)clickMoreWorkDec:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        _height2 = [self.model.job_desc boundingRectWithSize:CGSizeMake(__kScreenWidth - 10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;;
    } else {
        _height2 = 50;
    }
    
    [UIView animateWithDuration:.1 animations:^{
        self.jobDecH.constant = _height2;
        self.jobDecSupViewH.constant = _height2 + 30;
        [self.jobIntroduce layoutIfNeeded];
        [self.jobDecSupView layoutIfNeeded];
    }];
    if (_welfareCount > 8) {
        self.frame = CGRectMake(0, 61, __kScreenWidth, _otherCellH + 60 + _height1 +_height2);
    } else {
        self.frame = CGRectMake(0, 61, __kScreenWidth, _otherCellH + 30 + _welfareRealH +_height2);
    }
    if (self.blockChangeViewH) {
        self.blockChangeViewH(self.frame);
    }
}
#pragma mark -- 代理方法
- (IBAction)SyndicateButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(TZJobBodyCellButtonClicked:)]) {
        [self.delegate TZJobBodyCellButtonClicked:sender.tag];
    }
}

@end
