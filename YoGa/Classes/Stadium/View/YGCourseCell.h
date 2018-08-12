//
//  YGCourseCell.h
//  YoGa
//
//  Created by 罗琰 on 2018/8/12.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGCourseModel.h"

typedef void(^OrderCourseBlock)(YGCourseModel* model);
typedef void(^CancelCourseBlock)(YGCourseModel* model);

@interface YGCourseCell : UITableViewCell

@property (nonatomic,copy) OrderCourseBlock orderCourse;
@property (nonatomic,copy) CancelCourseBlock cancelCourse;
- (void)model:(YGCourseModel*)model;
@end
