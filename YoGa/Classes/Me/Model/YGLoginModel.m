//
//  YGMessageModel.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/13.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGLoginModel.h"

@implementation YGLoginModel
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
@end
