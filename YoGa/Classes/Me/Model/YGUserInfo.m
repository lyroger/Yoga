
//  YGUserInfo.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/19.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGUserInfo.h"
#import "SSKeychain.h"

@implementation YGUserInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"phone":@"phoneNo",
             @"userName":@"username",
             @"headImageUrl":@"headerPicture",
             @"gender":@"grade"
             };
}

+ (LKDBHelper *)getUsingLKDBHelper {
    return [super getDefaultLKDBHelper];
}

+ (instancetype)shareUserInfo
{
    static YGUserInfo *userInfo = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        userInfo = [[YGUserInfo alloc] init];
    });
    return userInfo;
}

- (void)setUserInfo:(YGUserInfo*)userInfo
{
    _userId = userInfo.userId;
    _userName = userInfo.userName;
    _phone = userInfo.phone;
    _token = userInfo.token;
    _headImageUrl = userInfo.headImageUrl;
    _gender = userInfo.gender;
}

- (BOOL)updateUserInfoToDB
{
    YGUserInfo *userInfo = [YGUserInfo shareUserInfo];
    BOOL worked = [[YGUserInfo getUsingLKDBHelper] updateToDB:userInfo where:[NSString stringWithFormat:@"phone=%@",[YGUserInfo shareUserInfo].phone]];
    if (worked) {
        NSLog(@"更新成功");
    } else {
        NSLog(@"更新失败");
    }
    return worked;
}

- (void)getUserInfoFromLocal
{
    NSString *userAcount = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUserAcount];
    if (userAcount.length) {
        YGUserInfo *userInfo = [YGUserInfo searchSingleWithWhere:[NSString stringWithFormat:@"phone='%@'",userAcount] orderBy:nil];
        [self setUserInfo:userInfo];
    }
}

+ (void)getCodeMessageWithPhone:(NSString*)phone
                         target:(id)target
                        success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet(phone, @"phoneNo");
    [self dataTaskMethod:HTTPMethodPOST
                    path:@"/app/auth/sendSmsCode"
                  params:ParamsDic
              networkHUD:NetworkHUDLockScreen
                  target:target success:success];
}

+ (void)loginRequestWithPhone:(NSString*)phone
                         code:(NSString*)code
                       target:(id)target
                      success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet(phone, @"phoneNo");
    DicValueSet(code, @"smsCode");
    [self dataTaskMethod:HTTPMethodPOST
                    path:@"/app/login"
                  params:ParamsDic
              networkHUD:NetworkHUDLockScreen
                  target:target success:success];
}

+ (void)logOutRequestTarget:(id)target
                    success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet([YGUserInfo shareUserInfo].phone, @"username");
    [self dataTaskMethod:HTTPMethodPOST
                    path:@"app/logout"
                  params:ParamsDic
              networkHUD:NetworkHUDBackground
                  target:target success:success];
}

+ (void)updateUserInfoUserName:(NSString*)name
                        gender:(NSInteger)gender
                     headImage:(UIImage*)headPhoto
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

    NSMutableArray *array = nil;
    if (headPhoto) {
        array = [NSMutableArray array];
        UIImage *image = headPhoto;
        NSData *data = UIImageJPEGRepresentation(image,0.5);
        NSDictionary *fileDic = [NSDictionary bm_dictionaryWithData:data
                                                               name:@"headerPicture"
                                                           fileName:[NSString stringWithFormat:@"file0.jpg"]
                                                           mimeType:@"image/jpg"];
        [array addObject:fileDic];
    }

    [self updataFile:@"/app/user/updateUserInfo" files:array params:ParamsDic networkHUD:NetworkHUDLockScreenAndError target:target success:success];
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
