//
//  YGImageTextHView.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/12.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGImageTextHView.h"

@implementation YGImageTextHView

- (id)init {
    if (self = [super init]) {
        self.imageView = [UIImageView new];
        [self addSubview:self.imageView];
        
        self.labelText = [UILabel new];
        [self addSubview:self.labelText];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        [self.labelText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageView.mas_right).mas_offset(5);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(0);
        }];
    }
    return self;
}

@end
