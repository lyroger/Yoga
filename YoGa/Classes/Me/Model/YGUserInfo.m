//
//  YGUserInfo.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/19.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGUserInfo.h"
#import "SSKeychain.h"

@implementation YGUserInfo
+ (instancetype)shareUserInfo
{
    static YGUserInfo *userInfo = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        userInfo = [[YGUserInfo alloc] init];
    });
    return userInfo;
}

// 保存用户登录token
- (BOOL)saveUserToken:(NSString*)token
{
    BOOL worked = [SSKeychain setPassword:token forService:@"com.qinyoga.yoga" account:@"com.qinyoga.yoga.token"];
    NSLog(@"addUserToken = %d",worked);
    return worked;
}
// 获取用户登录token；
- (NSString*)getUserToken
{
    return [SSKeychain passwordForService:@"com.qinyoga.yoga" account:@"com.qinyoga.yoga.token"];
}

// 清空用户登录token信息
- (void)clearUserToken
{
    [SSKeychain deletePasswordForService:@"com.qinyoga.yoga" account:@"com.qinyoga.yoga.token"];
}

@end
