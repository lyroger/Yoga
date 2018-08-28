//
//  YGCourseCell.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/12.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGCourseCell.h"

@interface YGCourseCell ()
{
    
}
@property (nonatomic,strong) UILabel *labelName;
@property (nonatomic,strong) UIButton    *btnOrder;
@property (nonatomic,strong) UIButton    *btnCancel;
@property (nonatomic,strong) UILabel *labelTime;
@property (nonatomic,strong) UILabel *labelTeacher;
@property (nonatomic,strong) UIImageView *imageSignTag;
@property (nonatomic,strong) UIImageView *imageHead;
@property (nonatomic,strong) YGCourseModel *courseModel;
@end

@implementation YGCourseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.btnOrder = [UIButton new];
        [self.btnOrder setTitle:@"预约" forState:UIControlStateNormal];
        self.btnOrder.layer.cornerRadius = 12.5;
        self.btnOrder.layer.masksToBounds = YES;
        self.btnOrder.backgroundColor = UIColorHex(0x121212);
        [self.btnOrder setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
        self.btnOrder.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnOrder addTarget:self action:@selector(clickOrder) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnOrder];
        
        self.btnCancel = [UIButton new];
        [self.btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        self.btnCancel.layer.cornerRadius = 12.5;
        self.btnCancel.layer.masksToBounds = YES;
        self.btnCancel.layer.borderWidth = 1;
        self.btnCancel.layer.borderColor = UIColorHex(0x121212).CGColor;
        [self.btnCancel setTitleColor:UIColorHex(0x121212) forState:UIControlStateNormal];
        self.btnCancel.backgroundColor = UIColorHex(0xffffff);
        self.btnCancel.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnCancel addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnCancel];
        
        self.imageHead = [UIImageView new];
        self.imageHead.layer.cornerRadius = 2;
        self.imageHead.layer.masksToBounds = YES;
        self.imageHead.contentMode = UIViewContentModeScaleAspectFill;
        self.imageHead.backgroundColor = UIColorHex(0xf4f4f4);
        [self.contentView addSubview:self.imageHead];
        
        self.labelName = [UILabel new];
        self.labelName.font = [UIFont systemFontOfSize:15];
        self.labelName.textColor = UIColorHex(0x333333);
        [self.contentView addSubview:self.labelName];

        self.imageSignTag = [UIImageView new];
        self.imageSignTag.layer.cornerRadius = 10;
        self.imageSignTag.image = [UIImage imageNamed:@"list_ic_qian"];
        [self.contentView addSubview:self.imageSignTag];
        
        self.labelTime = [UILabel new];
        self.labelTime.font = [UIFont systemFontOfSize:12];
        self.labelTime.textColor = UIColorHex(0x505050);
        [self.contentView addSubview:self.labelTime];
        
        self.labelTeacher = [UILabel new];
        self.labelTeacher.font = [UIFont systemFontOfSize:10];
        self.labelTeacher.textColor = UIColorHex(0x808080);
        [self.contentView addSubview:self.labelTeacher];
        
        [self.imageHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageHead.mas_right).mas_offset(8);
            make.top.mas_equalTo(15);
            make.right.mas_equalTo(self.imageSignTag.mas_left).mas_offset(-8);
        }];

        [self.imageSignTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.labelName.mas_centerY);
            make.left.mas_equalTo(self.labelName.mas_right).mas_offset(8);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self.labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageHead.mas_right).mas_offset(8);
            make.top.mas_equalTo(self.labelName.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(-15);
        }];
        
        [self.labelTeacher mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageHead.mas_right).mas_offset(8);
            make.top.mas_equalTo(self.labelTime.mas_bottom).mas_offset(5);
            make.right.mas_equalTo(-15);
        }];
        
        [self.btnOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(45, 25));
            make.right.mas_equalTo(-15);
        }];
        
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(45, 25));
            make.right.mas_equalTo(-15);
        }];
        
    }
    return self;
}


- (void)model:(YGCourseModel*)model isSign:(NSInteger)sign
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"HH:mm";
    NSString *start = [formatter stringFromDate:model.startTime];
    NSString *end = [formatter stringFromDate:model.endTime];

    NSString *time = [NSString stringWithFormat:@"%@~%@",start,end];
    if (sign > 0) {
        //我的预约列表中展示多现实 年月日
        NSDateFormatter *formatterYear = [NSDateFormatter new];
        formatterYear.dateFormat = @"yyyy-MM-dd";
        NSString *year = [formatterYear stringFromDate:model.startTime];
        time = [NSString stringWithFormat:@"%@ %@~%@",year,start,end];
    }

    self.courseModel = model;
    self.labelName.text = model.name;
    self.labelTime.text = time;
    self.labelTeacher.text = [NSString stringWithFormat:@"%@ %zd人",model.tearcherName,model.count];
    [self.imageHead sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage imageNamed:@"list_pic"]];

    self.imageSignTag.hidden = !model.signFlag;
    if (sign>0) {
        if (sign == 1) {
            //已约
            if (model.signFlag == 0) {
                self.btnOrder.hidden = NO;
                self.btnCancel.hidden = NO;
                [self.btnOrder setTitle:@"签到" forState:UIControlStateNormal];
                [self.btnOrder removeTarget:self action:@selector(clickOrder) forControlEvents:UIControlEventTouchUpInside];
                [self.btnOrder addTarget:self action:@selector(clickSign) forControlEvents:UIControlEventTouchUpInside];
                [self.btnOrder mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(self.contentView.mas_centerY);
                    make.size.mas_equalTo(CGSizeMake(45, 25));
                    make.right.mas_equalTo(self.btnCancel.mas_left).mas_offset(-8);
                }];

                [self.btnCancel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(self.contentView.mas_centerY);
                    make.size.mas_equalTo(CGSizeMake(45, 25));
                    make.right.mas_equalTo(-15);
                }];
            } else {
                self.btnOrder.hidden = YES;
                self.btnCancel.hidden = YES;
            }
        } else if (sign == 2) {
            //历史
            self.btnOrder.hidden = YES;
            self.btnCancel.hidden = YES;
        }
    } else {
        if (model.signFlag == 1) {
            self.btnOrder.hidden = YES;
            self.btnCancel.hidden = YES;
        } else {
            //只有在没有签到的情况下才能预约和取消预约
            if (model.orderFlag==1) {
                //已约 显示取消按钮
                self.btnOrder.hidden = YES;
                self.btnCancel.hidden = NO;
                //如果开始时间已经开始，则不能取消隐藏
                if ([model.startTime timeIntervalSince1970] < [[NSDate date] timeIntervalSince1970]) {
                    self.btnCancel.hidden = YES;
                }
            } else {
                //还未预约 显示预约按钮
                self.btnOrder.hidden = NO;
                self.btnCancel.hidden = YES;
            }
        }
    }
}

- (void)clickSign{
    if (self.signCourse) {
        self.signCourse(self.courseModel);
    }
}

- (void)clickOrder
{
    if (self.orderCourse) {
        self.orderCourse(self.courseModel);
    }
}

- (void)clickCancel
{
    if (self.cancelCourse) {
        self.cancelCourse(self.courseModel);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
