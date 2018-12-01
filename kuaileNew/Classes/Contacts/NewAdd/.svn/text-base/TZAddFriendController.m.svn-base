//
//  TZAddFriendController.m
//  kuaile
//
//  Created by ttouch on 2016/12/23.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import "TZAddFriendController.h"
#import "TZAddFrindTableView.h"
#import "TZAddFriendHeaderView.h"
#import "XYRecommendFriendModel.h"
#import "XYSearchFriendViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <Contacts/ContactsDefines.h>
#import <Contacts/CNContact.h>
#import "XYContactViewController.h"

@interface TZAddFriendController ()<TZAddFrindTableViewDelegate,UIScrollViewDelegate,ABPeoplePickerNavigationControllerDelegate> {
    BOOL _netFlag;

}
@property (nonatomic, strong) TZAddFrindTableView *tableView1;
@property (nonatomic, strong) TZAddFriendHeaderView *headerView1;
@property (nonatomic, strong) TZAddFriendHeaderView *headerView2;
@property (nonatomic, strong) TZAddFriendHeaderView *headerView3;
@property (nonatomic, strong) TZAddFrindTableView *tableView2;
@property (nonatomic, strong) TZAddFrindTableView *tableView3;

@property (nonatomic, strong) TZButtonsHeaderView *headerBtns;
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL isManuChangeType;

@property (nonatomic, strong) NSArray *frinedFromSamePlace;
@property (nonatomic, strong) NSArray *recommendFriends;
@property (nonatomic, copy) NSString *appendPhoneStr;
@property (nonatomic, strong) NSMutableArray *contacts;

@end

@implementation TZAddFriendController

- (NSMutableArray *)contacts {
    if (_contacts == nil) {
        _contacts = [NSMutableArray array];
    }
    return _contacts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"查找添加好友";
    [self configHeaderBtns];
    [self configBigScrollView];
    
}

- (void)getPeopleBookDatas {
   [self getAddressBook];
}

- (void)pushContactVc {
    XYContactViewController *contactVc = [[XYContactViewController alloc] init];
    contactVc.phoneStr = self.appendPhoneStr;
    contactVc.contacts = self.contacts;
    [self.navigationController pushViewController:contactVc animated:YES];
}

- (void)getAddressBook {
    if (iOS9after) {
        //判断是否授权成功
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        CNAuthorizationStatus authorStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (authorStatus == CNAuthorizationStatusNotDetermined) {
            //首次访问通讯录会调用
            __block BOOL isGranted = YES;
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (error) return;
                if (granted) {//允许
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self fetchContactWithContactStore:contactStore];//访问通讯录
                        [self pushContactVc];
                    });
                } else {//拒绝
                    NSLog(@"拒绝访问通讯录");//访问通讯录
                }  
            }];
        } else {
            if (authorStatus == CNAuthorizationStatusAuthorized) {
                [self fetchContactWithContactStore:contactStore];//访问通讯录
                [self pushContactVc];
            } else {
            }
            if (authorStatus == CNAuthorizationStatusDenied) {
                [self showAlertViewWithTitle:@"提示" message:@"请前往隐私进行设置"];
            }
        }
    } else {

    }
//        //判断是否授权成功
//        if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
//            
//        }
//        //创建通讯录
//        ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
//        //获取通讯录中的所有人
//        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(book);
//        //遍历
//        CFIndex count = CFArrayGetCount(allPeople);
//        for (int i = 0; i < count; i++) {
//            ABRecordRef people = CFArrayGetValueAtIndex(allPeople, i);
//            CFStringRef lastName = ABRecordCopyValue(people, kABPersonLastNameProperty);
//            CFStringRef firstName = ABRecordCopyValue(people, kABPersonFirstNameProperty);
//            CFStringRef middleName = ABRecordCopyValue(people, kABPersonMiddleNameProperty);
//            NSString *str = (__bridge NSString *)(lastName);
//            //获取的是所有的电话
//            NSMutableArray *array = [NSMutableArray array];
//            ABMultiValueRef phones = ABRecordCopyValue(people, kABPersonPhoneProperty);
//            CFIndex phoneCount = ABMultiValueGetCount(phones);
//            for (int i = 0; i < phoneCount; i++) {
//                CFStringRef name = ABMultiValueCopyLabelAtIndex(phones, i);
//                CFStringRef value = ABMultiValueCopyValueAtIndex(phones, i);
//                NSString *nameStr = (__bridge NSString *)(name);
//                NSString *valueStr = (__bridge NSString *)(value);
//                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                dict[@"name"] = nameStr;
//                dict[@"phone"] = valueStr;
//                [array addObject:dict];
//            }
//        }
//    }
}

- (void)fetchContactWithContactStore:(CNContactStore *)contactStore {
    NSError *error = nil;
    //创建数组,必须遵守CNKeyDescriptor协议,放入相应的字符串常量来获取对应的联系人信息
    NSArray <id<CNKeyDescriptor>> *keysToFetch = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey];
    //创建获取联系人的请求
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    //遍历查询
    NSMutableString *appPhoneStr = [NSMutableString string];
    MJWeakSelf
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        if (!error) {
            NSMutableString *appNameStr = [NSMutableString string];
            NSString *familyName = contact.familyName;
            NSString *givenName = contact.givenName;
            [appNameStr appendFormat:@"%@%@",familyName,givenName];
    
            NSString *phoneStr;
            for (CNLabeledValue *phoneValue in contact.phoneNumbers) {
                NSString * strPhoneNums = [phoneValue.value stringValue];
                if ([CommonTools isMobileNumber:strPhoneNums]) {
                    phoneStr = strPhoneNums;break;
                }
            }
            if (phoneStr && phoneStr.length) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"name"] = appNameStr;
                dict[@"phone"] = phoneStr;
                [weakSelf.contacts addObject:dict];
                [appPhoneStr appendFormat:[NSString stringWithFormat:@",%@",phoneStr]];
            }
        } else {
            NSLog(@"error:%@", error.localizedDescription);
        }
    }];
    if (appPhoneStr.length > 1) {
        [appPhoneStr deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    self.appendPhoneStr = appPhoneStr;
}

- (void)configHeaderBtns {
    _headerBtns = [[TZButtonsHeaderView alloc] init];
    _headerBtns.frame = CGRectMake(0, 0, mScreenWidth, 40);
    _headerBtns.notCalcuLateTitleWidth = YES;
    _headerBtns.showLines = NO;
    _headerBtns.titles = @[@"加好友",@"找老乡",@"找同事"];
    _headerBtns.selectBtnIndex = 0;
    MJWeakSelf
    [_headerBtns setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
        weakSelf.isManuChangeType = YES;
//        if (index == 1) {
//            [self.tableView2 loadFriendsDataFromSamePlace];
//        }
        [weakSelf.bigScrollView setContentOffset:CGPointMake(index * mScreenWidth, 0) animated:YES];
    }];
    [self.view addSubview:_headerBtns];
}

- (void)configBigScrollView {
    self.bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, mScreenWidth, mScreenHeight - 64 - 40)];
    self.bigScrollView.pagingEnabled = YES;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.delegate = self;
    self.bigScrollView.contentSize = CGSizeMake(mScreenWidth * 3, 0);
    [self.view addSubview:_bigScrollView];
    
    [self tableView1];
    [self tableView2];
//    [self.tableView1 loadRecommendFriendData];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = (offsetX + mScreenWidth / 2) / mScreenWidth;
    if (!self.isManuChangeType) {
        _headerBtns.selectBtnIndex = index;
    }
    if (index > 0) {
        [self tableView3];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isManuChangeType = NO;
}


#pragma mark - Get

- (TZAddFrindTableView *)tableView1 {
    if (!_tableView1) {
        _tableView1 = [self getTableViewWithIndex:0];
        _headerView1 = [[TZAddFriendHeaderView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 144)];
        MJWeakSelf
        [_headerView1 setDidClickSearchBtnBlock:^{
            [weakSelf pushSearchVcWithSelectedIndex:0];
        }];
        [_headerView1 setDidTapAddressBookViewBlock:^{
            [weakSelf getPeopleBookDatas];
        }];
        _tableView1.tableHeaderView = _headerView1;
    }
    return _tableView1;
}

- (TZAddFrindTableView *)tableView2 {
    if (!_tableView2) {
        _tableView2 = [self getTableViewWithIndex:1];
        _headerView2 = [[TZAddFriendHeaderView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 44)];
        CGRect rect2 = _headerView2.frame;
        rect2.size.height = 44;
        _headerView2.frame = rect2;
        _headerView2.bottomView.hidden = YES;
        MJWeakSelf
        [_headerView2 setDidClickSearchBtnBlock:^{
            [weakSelf pushSearchVcWithSelectedIndex:1];
        }];
        _tableView2.tableHeaderView = _headerView2;
    }
    return _tableView2;
}

- (TZAddFrindTableView *)tableView3 {
    if (!_tableView3) {
        _tableView3 = [self getTableViewWithIndex:2];
        _tableView3.tableHeaderView.height = 44;
        _headerView3 = [[TZAddFriendHeaderView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 44)];
        CGRect rect3 = _headerView3.frame;
        rect3.size.height = 44;
        _headerView3.frame = rect3;
        _headerView3.bottomView.hidden = YES;
        MJWeakSelf
        [_headerView3 setDidClickSearchBtnBlock:^{
            [weakSelf pushSearchVcWithSelectedIndex:2];
        }];
        _tableView3.tableHeaderView = _headerView3;
    }
    return _tableView3;
}

- (void)pushSearchVcWithSelectedIndex:(NSInteger)selectedIndex {
    XYSearchFriendViewController *searchVc = [[XYSearchFriendViewController alloc] init];
    searchVc.selectedIndex = selectedIndex;
    [self.navigationController pushViewController:searchVc animated:YES];
}

- (TZAddFrindTableView *)getTableViewWithIndex:(NSInteger)index {
    TZAddFrindTableView *tableView = [[TZAddFrindTableView alloc] initWithFrame:CGRectMake(index * mScreenWidth , 0, mScreenWidth, _bigScrollView.height) style:UITableViewStylePlain index:index];
    [tableView registerCellByNibName:@"TZAddFriendCell"];
    tableView.tableFooterView = [UIView new];
    tableView.index = index;
    tableView.delegate = tableView;
    tableView.dataSource = tableView;
    tableView.tzdelegate = self;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.backgroundColor = TZControllerBgColor;
    tableView.type = TZAddFriendTableViewTypeAddFriend;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.bigScrollView addSubview:tableView];
    return tableView;
}

- (void)addFrindTableView:(TZAddFrindTableView *)addFrindTableView didClickAttentionWithBuddyName:(NSString *)buddyName {
    NSLog(@"%@",buddyName);
    
    
    [self checkAttentionStatusWithBuddyName:buddyName];
}

- (void)checkAttentionStatusWithBuddyName:(NSString *)buddyName {
    if (buddyName && buddyName.length > 0) {
        
        if (_netFlag) {
            return;
        }
        _netFlag = YES;
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
        params[@"username"] = buddyName;
        [TZHttpTool postWithURL:ApiSnsConcernUser params:params success:^(NSDictionary *result) {
            _netFlag = NO;
            [self showSuccessHUDWithStr:result[@"msg"]];
            [mNotificationCenter postNotificationName:@"didAddFriendNoti" object:nil];
            // 加好友添加积分
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"uid": userModel.uid }];
            RACSignal *sign = [ICEImporter addFriendsIntegralWithParams:params];
        } failure:^(NSString *msg) {
            _netFlag = NO;
        }];
    }
}




@end
