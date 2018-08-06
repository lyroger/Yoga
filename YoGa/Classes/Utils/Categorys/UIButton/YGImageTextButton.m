//
//  YGImageTextButton.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/6.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGImageTextButton.h"

@implementation YGImageTextButton

- (void)reset{
    CGFloat imageW = self.imageView.frame.size.width;
    CGFloat imageH = self.imageView.frame.size.height;
    
    CGFloat titleW = self.titleLabel.frame.size.width;
    CGFloat titleH = self.titleLabel.frame.size.height;
    
    //图片上文字下
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageW, -imageH - 10, 0.f)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-titleH, 0.f, 0.f,-titleW)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
