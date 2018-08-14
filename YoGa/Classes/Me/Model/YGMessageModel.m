//
//  YGMessageModel.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/13.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGMessageModel.h"

@implementation YGMessageModel
+ (void)getCodeMessageWithPhone:(NSString*)phone
                        success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet(phone, @"phoneNo");
    [self dataTaskMethod:HTTPMethodPOST
                    path:@"/app/auth/sendSmsCode"
                  params:ParamsDic
                  target:nil success:success];
}
@end
