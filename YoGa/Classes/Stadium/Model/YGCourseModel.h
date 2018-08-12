//
//  YGCourseModel.h
//  YoGa
//
//  Created by 罗琰 on 2018/8/12.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGCourseModel : NSObject

@property (nonatomic,assign) NSInteger courseID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *teacher;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,copy) NSString *imageURL;
@end
