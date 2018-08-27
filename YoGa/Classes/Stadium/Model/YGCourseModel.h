//
//  YGCourseModel.h
//  YoGa
//
//  Created by 罗琰 on 2018/8/12.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGCourseModel : BaseModel

@property (nonatomic,assign) NSInteger courseId; //课程ID
@property (nonatomic,assign) NSInteger userCourseId;//取消时使用。
@property (nonatomic,assign) NSInteger classId; //排课的主键ID
@property (nonatomic,assign) NSInteger merCourId; //排课的id，已约列表用到。
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,assign) NSInteger orderFlag;  //0 没有预约，1已约
@property (nonatomic,assign) NSInteger signFlag;   //0 未签到，1已签到
@property (nonatomic,assign) NSInteger tercherId;
@property (nonatomic,copy) NSString *tearcherName;
@property (nonatomic,strong) NSDate *startTime;
@property (nonatomic,strong) NSDate *endTime;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,copy) NSString *imageURL;

+ (void)getCoursesInfoById:(NSString*)stadiumId
                      date:(NSString*)date
                    target:(id)target
                   success:(NetResponseBlock)success;

+ (void)getOrderCoursesType:(NSInteger)type
                   pageSize:(NSInteger)pageSize
                  pageIndex:(NSInteger)pageIndex
                     target:(id)target
                    success:(NetResponseBlock)success;

+ (void)orderCoursesById:(NSString*)classId
                  userId:(NSString*)userId
                  target:(id)target
                 success:(NetResponseBlock)success;

+ (void)cancelCoursesById:(NSString*)classId
                   target:(id)target
                  success:(NetResponseBlock)success;

+ (void)signCoursesById:(NSString*)classId
                 target:(id)target
                success:(NetResponseBlock)success;
@end
