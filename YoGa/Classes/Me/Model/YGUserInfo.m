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

+ (void)updateUserInfoUserName:(NSString*)name
                        gender:(NSInteger)gender
                        target:(id)target
                       success:(NetResponseBlock)success
{
    CreateParamsDic;
    if (name) {
        DicValueSet(name, @"nickname");
    }
    if (gender>=0) {
        DicValueSet(@(gender), @"grade");
    }
    [self dataTaskMethod:HTTPMethodPOST
                    path:@"/app/user/updateUserInfo"
                  params:ParamsDic
              networkHUD:NetworkHUDLockScreen
                  target:target success:success];
}

+ (void)feedbackInfo:(NSString*)text
              target:(id)target
             success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet(text, @"feedback");
    [self dataTaskMethod:HTTPMethodPOST
                    path:@"/app/suggestion/addOne"
                  params:ParamsDic
              networkHUD:NetworkHUDLockScreen
                  target:target success:success];
}

@end
