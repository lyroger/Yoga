//
//  YGMeViewConter.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/1.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGMeViewConter.h"
#import "UIButton+ImageText_V.h"
#import "YGSelfInfoViewController.h"
#import "YGAboutViewController.h"
#import "YGFeedBackViewController.h"
#import "YGMyCourseViewController.h"

@interface YGMeViewConter ()

@property (nonatomic,strong) UIImageView *imageHead;
@property (nonatomic,strong) UILabel    *labelName;
@property (nonatomic,strong) UILabel    *labelPhone;
@property (nonatomic,strong) UIButton   *btnFeedback;
@property (nonatomic,strong) UIButton   *btnAbout;
@property (nonatomic,strong) UIButton   *btnCourse;
@end

@implementation YGMeViewConter

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人中心";
    [self loadSubView];
}

- (void)loadSubView
{
    self.imageHead = [UIImageView new];
    self.imageHead.layer.cornerRadius = 40;
    self.imageHead.backgroundColor = UIColorHex(0xf4f4f4);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailInfo)];
    [self.imageHead addGestureRecognizer:tap];
    self.imageHead.userInteractionEnabled = YES;
    [self.view addSubview:self.imageHead];
    
    self.labelName = [UILabel new];
    self.labelName.text = @"瑜伽链";
    self.labelName.textAlignment = NSTextAlignmentCenter;
    self.labelName.textColor = UIColorHex(0x121212);
    self.labelName.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.labelName];
    
    self.labelPhone = [UILabel new];
    self.labelPhone.text = @"186....9999";
    self.labelPhone.textAlignment = NSTextAlignmentCenter;
    self.labelPhone.textColor = UIColorHex(0x808080);
    self.labelPhone.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:self.labelPhone];
    
    self.btnCourse = [UIButton new];
    [self.btnCourse setImage:[UIImage imageNamed:@"personal_ic_01"] forState:UIControlStateNormal];
    [self.btnCourse setTitle:@"我的课程" forState:UIControlStateNormal];
    [self.btnCourse setTitleColor:UIColorHex(0x505050) forState:UIControlStateNormal];
    [self.btnCourse setBackgroundColor:UIColorHex(0xf4f4f4)];
    self.btnCourse.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.btnCourse setImagePosition:YGImagePositionTop spacing:5];
    [self.btnCourse addTarget:self action:@selector(myCourse) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnCourse];
    
    self.btnFeedback = [UIButton new];
    [self.btnFeedback setImage:[UIImage imageNamed:@"personal_ic_02"] forState:UIControlStateNormal];
    [self.btnFeedback setTitle:@"反馈" forState:UIControlStateNormal];
    [self.btnFeedback setTitleColor:UIColorHex(0x505050) forState:UIControlStateNormal];
    [self.btnFeedback setBackgroundColor:UIColorHex(0xf4f4f4)];
    self.btnFeedback.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.btnFeedback setImagePosition:YGImagePositionTop spacing:5];
    [self.btnFeedback addTarget:self action:@selector(feedBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnFeedback];
    
    self.btnAbout = [UIButton new];
    [self.btnAbout setImage:[UIImage imageNamed:@"personal_ic_03"] forState:UIControlStateNormal];
    [self.btnAbout setTitle:@"关于" forState:UIControlStateNormal];
    [self.btnAbout setTitleColor:UIColorHex(0x505050) forState:UIControlStateNormal];
    [self.btnAbout setBackgroundColor:UIColorHex(0xf4f4f4)];
    self.btnAbout.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.btnAbout setImagePosition:YGImagePositionTop spacing:5];
    [self.btnAbout addTarget:self action:@selector(about) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnAbout];
    
    [self.imageHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15+64);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageHead.mas_bottom).mas_offset(26);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.labelPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelName.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.btnCourse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(114);
        make.top.mas_equalTo(self.labelPhone.mas_bottom).mas_offset(50);
        make.width.mas_equalTo(self.btnFeedback.mas_width);
    }];
    
    [self.btnFeedback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.btnCourse.mas_right).mas_offset(10);
        make.height.mas_equalTo(self.btnCourse.mas_height);
        make.centerY.mas_equalTo(self.btnCourse.mas_centerY);
        make.width.mas_equalTo(self.btnAbout.mas_width);
    }];
    
    [self.btnAbout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.btnFeedback.mas_right).mas_offset(10);
        make.height.mas_equalTo(self.btnCourse.mas_height);
        make.centerY.mas_equalTo(self.btnCourse.mas_centerY);
        make.width.mas_equalTo(self.btnFeedback.mas_width);
        make.right.mas_equalTo(-15);
    }];
}

- (void)detailInfo
{
    YGSelfInfoViewController *selfVC = [[YGSelfInfoViewController alloc] init];
    selfVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selfVC animated:YES];
}

- (void)myCourse
{
    YGMyCourseViewController *VC = [[YGMyCourseViewController alloc] init];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)feedBack
{
    YGFeedBackViewController *VC = [[YGFeedBackViewController alloc] init];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)about
{
    YGAboutViewController *VC = [[YGAboutViewController alloc] init];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
