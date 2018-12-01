//
//  TZCityPickerView.m
//  DemoProduct
//
//  Created by ttouch on 15/12/10.
//  Copyright © 2015年 iCE. All rights reserved.
//

#import "TZCityPickerView.h"

@interface TZCityPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *cityModels1;
@property (nonatomic, strong) NSArray *cityModels2;
@property (nonatomic, strong) NSArray *cityModels3;

@property (nonatomic, strong) TZCityModel *cityModel1;
@property (nonatomic, strong) TZCityModel *cityModel2;
@property (nonatomic, strong) TZCityModel *cityModel3;
@end

@implementation TZCityPickerView

+ (instancetype)shareView {
    static TZCityPickerView *view;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[self alloc] init];
    });
    return view;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cityModels1 = [ZYLocationTools getSubCitysWithPid:@"0"];
        self.cityModels2 = [ZYLocationTools getSubCitysWithPid:@"3"];
        self.cityModels3 = [ZYLocationTools getSubCitysWithPid:@"38"];
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, __kScreenWidth-20, 216)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [self addSubview:_pickerView];
        
        self.cityModel1 = self.cityModels1[2];
        self.cityModel2 = self.cityModels2[0];
        self.cityModel3 = self.cityModels3[0];
        
        // 先选中上海
        [_pickerView selectRow:2 inComponent:0 animated:YES];
    }
    return self;
}

- (void)show {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择区域" message:@"\n\n\n\n\n\n\n\n\n\n"preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    
    TZCityPickerView *_viewPicker = [TZCityPickerView shareView];
    _viewPicker.frame = CGRectMake(0, 25, __kScreenWidth - 20, 216);
    [alertController.view addSubview:_viewPicker];

    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSString *addressStr = [NSString stringWithFormat:@"%@-%@-%@", self.cityModel1.name, self.cityModel2.name, self.cityModel3.name];
        if (self.didSelectAddressBlock) {
            self.didSelectAddressBlock(self.cityModel1,self.cityModel2,self.cityModel3,addressStr);
        }
    }];
    [alertController addAction:resetAction];
    [[UIViewController currentViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)showWithDidSelectAddressBlock:(void (^)(TZCityModel *cityModel1,TZCityModel *cityModel2,TZCityModel *cityModel3,NSString *addressStr))didSelectAddressBlock {
    self.didSelectAddressBlock = didSelectAddressBlock;
    [self show];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0: { return self.cityModels1.count; } break;
        case 1: { return self.cityModels2.count; } break;
        case 2: { return self.cityModels3.count; } break;
        default: break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0: {
            if (self.cityModels1.count > row) {
                TZCityModel *model = [self.cityModels1 objectAtIndex:row];
                return model.name;
            }
        } break;
        case 1: {
            if (self.cityModels2.count > row) {
                TZCityModel *model = [self.cityModels2 objectAtIndex:row];
                return model.name;
            }
        } break;
        case 2: {
            if (self.cityModels3.count > row) {
                TZCityModel *model = [self.cityModels3 objectAtIndex:row];
                return model.name;
            }
        } break;
        default: break;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0: {
            [self selectCityModel1:self.cityModels1[row]];
        } break;
        case 1: {
            [self selectCityModel2:self.cityModels2[row]];
        } break;
        case 2: {
            [self selectCityModel3:self.cityModels3[row]];
        } break;
        default: break;
    }
}

- (void)selectCityModel1:(TZCityModel *)cityModel1 {
    self.cityModel1 = cityModel1;
    
    self.cityModels2 = [ZYLocationTools getSubCitysWithModel:cityModel1];
    [_pickerView reloadComponent:1];
    [_pickerView selectRow:0 inComponent:1 animated:YES];
    
    [self selectCityModel2:self.cityModels2[0]];
}

- (void)selectCityModel2:(TZCityModel *)cityModel2 {
    self.cityModel2 = cityModel2;
    
    self.cityModels3 = [ZYLocationTools getSubCitysWithModel:cityModel2];
    [_pickerView reloadComponent:2];
    [_pickerView selectRow:0 inComponent:2 animated:YES];
    
    [self selectCityModel3:self.cityModels3[0]];
}

- (void)selectCityModel3:(TZCityModel *)cityModel3 {
    self.cityModel3 = cityModel3;
}

@end
