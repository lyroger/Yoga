//
//  YGSelectedDateView.h
//  YoGa
//
//  Created by 罗琰 on 2018/8/12.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectDateBlcok)(NSInteger index);

@interface YGSelectedDateCell : UIView

@property (nonatomic, strong) UILabel *labelDate;
@property (nonatomic, strong) UILabel *labelWeek;
- (void)selected:(BOOL)selected;
@end

@interface YGSelectedDateView : UIView

@property (nonatomic,strong) NSArray *data;
@property (nonatomic,copy)   SelectDateBlcok selectedDateBlock;
@end
