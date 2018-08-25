//
//  YGEditUserInfoVC.m
//  YoGa
//
//  Created by Mac on 2018/8/22.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGEditUserInfoVC.h"

@interface YGEditUserInfoVC ()

@property (nonatomic, strong) UITextField *editView;

@end

@implementation YGEditUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorHex(0xf1f1f1);
    [self loadSubView];
    // Do any additional setup after loading the view.
}

#pragma mark - View LifeCycle
- (void)loadSubView
{
    if (self.editType == EditInfoType_UserName) {
        UITextField *textField = [UITextField new];
        textField.placeholder = @"请输入您的名称";
        textField.text = [YGUserInfo shareUserInfo].nickName;
        textField.font = [UIFont systemFontOfSize:16];
        textField.frame = CGRectMake(0, 20, kScreenWidth, 50);
        textField.backgroundColor = UIColorHex(0xffffff);
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
        self.editView = textField;
        [self.view addSubview:self.editView];
    }

    [self rightBarButtonWithName:@"保存" normalImgName:nil highlightImgName:nil target:self action:@selector(saveAction:)];
    [self racNavBtEnable];
    self.title = self.titleName;
}

- (void)racNavBtEnable
{
    //满足条件的情况才使得按钮可用
    UIBarButtonItem *navRightItem = self.navigationItem.rightBarButtonItem;
    RAC(navRightItem, enabled) = [RACSignal combineLatest:@[self.editView.rac_textSignal]
                                                   reduce:^(NSString *text){
                                                       return @(text.length);
                                                   }];
}

- (void)saveAction:(UIButton*)button
{
    NSLog(@"save button click");
    [self.view endEditing:YES];
    [YGUserInfo updateUserInfoUserName:self.editView.text gender:-1 headImage:nil target:self success:^(StatusModel *data) {
        if (data.code == 0) {
            [YGUserInfo shareUserInfo].nickName = self.editView.text;
            [[YGUserInfo shareUserInfo] updateUserInfoToDB];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
