//
//  YGCourseModel.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/12.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGCourseModel.h"

@implementation YGCourseModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"name":@"courseName",
             @"imageURL":@"merchantPictureURL",
             @"classId":@"id"
             };
}

+ (void)getCoursesInfoById:(NSString*)stadiumId
                      date:(NSString*)date
                    target:(id)target
                   success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet(stadiumId, @"merchantId");
    DicValueSet(date, @"queryDate");
    [self dataTaskMethod:HTTPMethodPOST
                    path:@"/app/merCourse/selectByDate"
                  params:ParamsDic
              networkHUD:NetworkHUDLockScreen
                  target:target success:success];
}

+ (void)getOrderCoursesType:(NSInteger)type
                   pageSize:(NSInteger)pageSize
                  pageIndex:(NSInteger)pageIndex
                     target:(id)target
                    success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet(@(pageSize), @"limit");
    DicValueSet(@(pageIndex), @"offset");
    NSString *path = type == 0?@"/app/userCourse/myCourse":@"/app/userCourse/hisCourse";
    [self dataTaskMethod:HTTPMethodPOST
                    path:path
                  params:ParamsDic
              networkHUD:NetworkHUDBackground
                  target:target success:success];
}

+ (void)orderCoursesById:(NSString*)classId
                  userId:(NSString*)userId
                  target:(id)target
                 success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet(userId, @"username");
    DicValueSet(classId, @"merCourId");
    [self dataTaskMethod:HTTPMethodPOST
                    path:@"/app/userCourse/addOne"
                  params:ParamsDic
              networkHUD:NetworkHUDLockScreen
                  target:target success:success];
}

+ (void)cancelCoursesById:(NSString*)classId
                   target:(id)target
                  success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet(classId, @"merCourId");
    [self dataTaskMethod:HTTPMethodPOST
                    path:@"/app/userCourse/deleteById"
                  params:ParamsDic
              networkHUD:NetworkHUDLockScreen
                  target:target success:success];
}

+ (void)signCoursesById:(NSString*)classId
                 target:(id)target
                success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet(classId, @"merCourId");
    DicValueSet(@(1), @"status");
    [self dataTaskMethod:HTTPMethodPOST
                    path:@"/app/userCourse/updateStatus"
                  params:ParamsDic
              networkHUD:NetworkHUDLockScreen
                  target:target success:success];
}
@end
