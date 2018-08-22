//
//  YGAboutViewController.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/12.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGAboutViewController.h"

@interface YGAboutViewController ()

@end

@implementation YGAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = [UIImage imageNamed:@"yogachain_ic"];
    [self.view addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(65);
    }];

    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"瑜伽链";
    nameLabel.font = [UIFont systemFontOfSize:20];
    nameLabel.textColor = UIColorHex(0x121212);
    [nameLabel sizeToFit];
    [self.view addSubview:nameLabel];

    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(iconImageView.mas_bottom).offset(15);
    }];

    UILabel *versionsLabel = [UILabel new];
    versionsLabel.textColor = UIColorHex(0x505050);
    [self.view addSubview:versionsLabel];

    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    versionsLabel.text = [NSString stringWithFormat:@"v%@",currentVersion];
    [versionsLabel sizeToFit];

    [versionsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(15);
    }];


//    UILabel *copyrightENLabel = [UILabel new];
//    copyrightENLabel.textColor = UIColorHex(0x999999);
//    copyrightENLabel.textAlignment = NSTextAlignmentCenter;
//    copyrightENLabel.font = [UIFont systemFontOfSize:11];
//    copyrightENLabel.numberOfLines = 0;
//    [self.view addSubview:copyrightENLabel];
//    copyrightENLabel.text = @"Copyright © 2016 Jice.All Rights Reserved.";
//    [copyrightENLabel sizeToFit];
//
//    [copyrightENLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(self.view).offset(-26);
//    }];

    UILabel *copyrightLabel = [UILabel new];
    copyrightLabel.textColor = UIColorHex(0x999999);
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    copyrightLabel.font = [UIFont systemFontOfSize:11];
    copyrightLabel.numberOfLines = 0;
    [self.view addSubview:copyrightLabel];
    copyrightLabel.text = @"瑜伽链   版权所有";
    [copyrightLabel sizeToFit];

    [copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-25);
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
