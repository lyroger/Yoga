//
//  YGMeViewConter.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/1.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGMeViewConter.h"
#import "YGImageTextButton.h"

@interface YGMeViewConter ()

@property (nonatomic,strong) UIImageView *imageHead;
@property (nonatomic,strong) YGImageTextButton *btnFeedback;
@property (nonatomic,strong) YGImageTextButton *btnAbout;
@property (nonatomic,strong) YGImageTextButton *btnCourse;
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
    [self.view addSubview:self.imageHead];
    
    self.btnCourse = [YGImageTextButton new];
    [self.btnCourse setImage:[UIImage imageNamed:@"personal_ic_01"] forState:UIControlStateNormal];
    [self.btnCourse setTitle:@"我的课程" forState:UIControlStateNormal];
    [self.btnCourse setTitleColor:UIColorHex(0x505050) forState:UIControlStateNormal];
    [self.btnCourse setBackgroundColor:UIColorHex(0xf4f4f4)];
    [self.btnCourse reset];
    [self.view addSubview:self.btnCourse];
    
    self.btnFeedback = [YGImageTextButton new];
    [self.btnFeedback setImage:[UIImage imageNamed:@"personal_ic_02"] forState:UIControlStateNormal];
    [self.btnFeedback setTitle:@"反馈" forState:UIControlStateNormal];
    [self.btnFeedback setTitleColor:UIColorHex(0x505050) forState:UIControlStateNormal];
    [self.btnFeedback setBackgroundColor:UIColorHex(0xf4f4f4)];
    [self.view addSubview:self.btnFeedback];
    
    self.btnAbout = [YGImageTextButton new];
    [self.btnAbout setImage:[UIImage imageNamed:@"personal_ic_03"] forState:UIControlStateNormal];
    [self.btnAbout setTitle:@"关于" forState:UIControlStateNormal];
    [self.btnAbout setTitleColor:UIColorHex(0x505050) forState:UIControlStateNormal];
    [self.btnAbout setBackgroundColor:UIColorHex(0xf4f4f4)];
    [self.view addSubview:self.btnAbout];
    
    [self.imageHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15+64);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.btnCourse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(114);
        make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(-20);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
