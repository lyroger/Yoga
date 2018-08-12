//
//  YGSelectedDateView.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/12.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGSelectedDateView.h"
#import "YGSelectDateModel.h"

@implementation YGSelectedDateCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorHex(0xf5f5f5);
        
        self.labelDate = [UILabel new];
        self.labelDate.font = [UIFont systemFontOfSize:12];
        self.labelDate.textColor = UIColorHex(0x333333);
        self.labelDate.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.labelDate];
        
        self.labelWeek = [UILabel new];
        self.labelWeek.font = [UIFont systemFontOfSize:10];
        self.labelWeek.textColor = UIColorHex(0x333333);
        self.labelWeek.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.labelWeek];
        
        [self.labelDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-10);
        }];
        
        [self.labelWeek mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.centerY.mas_equalTo(self.mas_centerY).mas_offset(10);
        }];
    }
    return self;
}

- (void)selected:(BOOL)selected
{
    if (selected) {
        self.backgroundColor = UIColorHex(0x121212);
        self.labelDate.textColor = UIColorHex(0xffffff);
        self.labelWeek.textColor = UIColorHex(0xffffff);
    } else {
        self.backgroundColor = UIColorHex(0xf5f5f5);
        self.labelDate.textColor = UIColorHex(0x333333);
        self.labelWeek.textColor = UIColorHex(0x333333);
    }
}

@end

@interface YGSelectedDateView()

@property (nonatomic,strong) NSMutableArray *selectCells;
@end

@implementation YGSelectedDateView

- (NSMutableArray*)selectCells
{
    if (!_selectCells) {
        _selectCells = [[NSMutableArray alloc] init];
    }
    return _selectCells;
}

- (void)setData:(NSArray*)data{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    CGFloat width = self.frame.size.width/data.count;
    for (int i = 0; i<data.count; i++) {
        YGSelectDateModel *model = (YGSelectDateModel*)data[i];
        YGSelectedDateCell *cell = [[YGSelectedDateCell alloc] initWithFrame:CGRectMake(i*width, 0, width, 50)];
        cell.labelDate.text = model.date;
        cell.labelWeek.text = model.week;
        cell.tag = 10+i;
        [cell selected:model.selected];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSelectCell:)];
        [cell addGestureRecognizer:tap];
        [self addSubview:cell];
        [self.selectCells addObject:cell];
    }
}

- (void)clickSelectCell:(UITapGestureRecognizer*)tap
{
    NSInteger tagIndex = tap.view.tag-10;
    for (int i = 0; i<self.selectCells.count; i++) {
        YGSelectedDateCell *cell = self.selectCells[i];
        if (i == tagIndex) {
            [cell selected:YES];
        } else {
            [cell selected:NO];
        }
    }
    if (self.selectedDateBlock) {
        self.selectedDateBlock(tagIndex);
    }
}

@end
