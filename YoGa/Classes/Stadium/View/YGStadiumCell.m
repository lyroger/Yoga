//
//  YGStadiumCell.m
//  YoGa
//
//  Created by Mac on 2018/8/3.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGStadiumCell.h"

@interface YGStadiumCell ()
{

}
@property (nonatomic,strong) UILabel *labelName;
@property (nonatomic,strong) UILabel *labelAddress;
@property (nonatomic,strong) UILabel *labelDistance;
@property (nonatomic,strong) UIImageView *imageHead;
@end

@implementation YGStadiumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageHead = [UIImageView new];
        self.imageHead.contentMode = UIViewContentModeScaleAspectFill;
        self.imageHead.backgroundColor = UIColorHex(0xf4f4f4);
        [self.contentView addSubview:self.imageHead];

        self.labelName = [UILabel new];
        self.labelName.font = [UIFont systemFontOfSize:15];
        self.labelName.textColor = UIColorHex(0x333333);
        [self.contentView addSubview:self.labelName];

        self.labelAddress = [UILabel new];
        self.labelAddress.font = [UIFont systemFontOfSize:12];
        self.labelDistance.textColor = UIColorHex(0x505050);
        [self.contentView addSubview:self.labelAddress];

        self.labelDistance = [UILabel new];
        self.labelDistance.font = [UIFont systemFontOfSize:10];
        self.labelDistance.textColor = UIColorHex(0x808080);
        [self.contentView addSubview:self.labelDistance];

        [self.imageHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];

        [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageHead.mas_right).mas_offset(8);
            make.top.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];

        [self.labelAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageHead.mas_right).mas_offset(8);
            make.top.mas_equalTo(self.labelName.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(-15);
        }];

        [self.labelDistance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageHead.mas_right).mas_offset(8);
            make.top.mas_equalTo(self.labelAddress.mas_bottom).mas_offset(5);
            make.right.mas_equalTo(-15);
        }];
    }
    return self;
}

- (void)model:(YGStadiumModel*)model
{
    self.labelName.text = model.name;
    self.labelAddress.text = model.address;
    self.labelDistance.text = model.distance;
    [self.imageHead sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage imageNamed:@"list_pic"]];
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
