//
//  YGLoginViewController.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/2.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGLoginViewController.h"

@interface YGLoginViewController ()

@end

@implementation YGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    // Do any additional setup after loading the view.
}

- (void)loadSubView{
    UIImageView *logoImage = [UIImageView new];
    logoImage.layer.cornerRadius = 40;
    logoImage.layer.masksToBounds = YES;
    logoImage.image = [UIImage imageNamed:@"yogachain_ic"];
    [self.view addSubview:logoImage];
    
    UIView *userNameContent = [UIView new];
    [self.view addSubview:userNameContent];
    
    UIView *codeContent = [UIView new];
    [self.view addSubview:codeContent];
    
    UIImageView *userIcon = [UIImageView new];
    userIcon.image = [UIImage imageNamed:@"login_ic_01"];
    [userNameContent addSubview:userIcon];
    
    UITextField *userText = [UITextField new];
    userText.placeholder = @"请输入手机号";
    userText.font = [UIFont systemFontOfSize:15];
    [userNameContent addSubview:userText];
    
    UIButton *msgCodeButton = [UIButton new];
    [msgCodeButton setTitleColor:UIColorRGB(11, 12, 13) forState:UIControlStateNormal];
    [msgCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    msgCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [userNameContent addSubview:msgCodeButton];
    
    UIImageView *codeIcon = [UIImageView new];
    codeIcon.image = [UIImage imageNamed:@"login_ic_02"];
    [codeContent addSubview:codeIcon];
    
    UITextField *codeText = [UITextField new];
    codeText.placeholder = @"请输入短信验证码";
    codeText.font = [UIFont systemFontOfSize:15];
    [codeContent addSubview:codeText];
    
    UIButton *btnLogin = [UIButton new];
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [btnLogin setBackgroundColor:UIColorRGB(11, 12, 13)];
    btnLogin.layer.masksToBounds = YES;
    btnLogin.layer.cornerRadius = 23;
    [btnLogin setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    [self.view addSubview:btnLogin];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = UIColorHex(0xf4f4f4);
    [userNameContent addSubview:line1];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = UIColorHex(0xf4f4f4);
    [codeContent addSubview:line2];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(userText);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(codeText);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.top.mas_equalTo(60);
    }];
    
    [userNameContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(@(-15));
        make.height.mas_equalTo(50);
        make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(-60);
    }];
    
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(userNameContent);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [userText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userIcon.mas_right).mas_offset(10);
        make.right.mas_equalTo(msgCodeButton.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(userNameContent);
        make.height.mas_equalTo(48);
    }];
    
    [msgCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(userNameContent);
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.right.mas_equalTo(0);
    }];
    
    [codeContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(@(-15));
        make.height.mas_equalTo(50);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    
    [codeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(codeContent);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(codeIcon.mas_right).mas_offset(10);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(codeContent);
        make.height.mas_equalTo(48);
    }];
    
    [btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(@(-15));
        make.height.mas_equalTo(46);
        make.top.mas_equalTo(codeContent.mas_bottom).mas_offset(50);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
