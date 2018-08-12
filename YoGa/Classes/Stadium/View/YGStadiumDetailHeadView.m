//
//  YGStadiumDetailHeadView.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/12.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGStadiumDetailHeadView.h"
#import "YGImageTextHView.h"

@interface YGStadiumDetailHeadView()

@property (nonatomic,strong) UIView *leftContentView;
@property (nonatomic,strong) YGImageTextHView *phoneInfoView;
@property (nonatomic,strong) YGImageTextHView *addressInfoView;
@property (nonatomic,strong) YGImageTextHView *timeInfoView;
@end

@implementation YGStadiumDetailHeadView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.headImageView = [UIImageView new];
        self.headImageView.backgroundColor = UIColorHex(0xf4f4f4);
        self.headImageView.layer.cornerRadius = 6;
        [self addSubview:self.headImageView];
        
        self.leftContentView = [UIView new];
        [self addSubview:self.leftContentView];
        
        self.labelName = [UILabel new];
        self.labelName.font = [UIFont systemFontOfSize:15];
        [self.leftContentView addSubview:self.labelName];
        
        self.phoneInfoView = [YGImageTextHView new];
        self.phoneInfoView.imageView.image = [UIImage imageNamed:@"list_ic_tel"];
        self.phoneInfoView.labelText.font = [UIFont systemFontOfSize:12];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhone)];
        [self.phoneInfoView addGestureRecognizer:tap];
        [self.leftContentView addSubview:self.phoneInfoView];
        
        self.addressInfoView = [YGImageTextHView new];
        self.addressInfoView.imageView.image = [UIImage imageNamed:@"list_ic_location"];
        self.addressInfoView.labelText.font = [UIFont systemFontOfSize:12];
        [self.leftContentView addSubview:self.addressInfoView];
        
        UILabel *splitLine = [UILabel new];
        splitLine.backgroundColor = UIColorHex(0xeeeeee);
        [self.leftContentView addSubview:splitLine];
        
        self.timeInfoView = [YGImageTextHView new];
        self.timeInfoView.imageView.image = [UIImage imageNamed:@"list_ic_time"];
        self.timeInfoView.labelText.font = [UIFont systemFontOfSize:11];
        [self.leftContentView addSubview:self.timeInfoView];
        
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(90, 90));
        }];
        
        [self.leftContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).mas_offset(10);
            make.top.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-15);
        }];
        
        [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(5);
        }];
        
        [self.phoneInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.addressInfoView.mas_width);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(25);
            make.top.mas_equalTo(self.labelName.mas_bottom).mas_offset(8);
            make.right.mas_equalTo(self.addressInfoView.mas_left);
        }];
        
        [self.addressInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(self.phoneInfoView.mas_height);
            make.top.mas_equalTo(self.phoneInfoView.mas_top);
            make.left.mas_equalTo(self.phoneInfoView.mas_right);
        }];
        
        [splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.phoneInfoView.mas_bottom).mas_offset(2);
        }];
        
        [self.timeInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(self.phoneInfoView.mas_height);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)tapPhone{
    if (self.callPhone) {
        self.callPhone();
    }
}

- (void)setPhone:(NSString *)phone
{
    self.phoneInfoView.labelText.text = phone;
}

- (void)setAddress:(NSString *)address
{
    self.addressInfoView.labelText.text = address;
}

- (void)setWorkTime:(NSString *)workTime
{
    self.timeInfoView.labelText.text = workTime;
}
@end
