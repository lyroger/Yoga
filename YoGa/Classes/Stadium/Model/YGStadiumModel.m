//
//  YGStadiumModel.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/6.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGStadiumModel.h"

@implementation YGStadiumModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"name":@"merchantName",
             @"imageURL":@"merchantPictureURL",
             @"stadiumId":@"id"
             };
}

+ (void)getStadiumListsByName:(NSString*)searchName
                     pageSize:(NSInteger)pageSize
                    pageIndex:(NSInteger)pageIndex
                       target:(id)target
                      success:(NetResponseBlock)success
{
    CreateParamsDic;
    if (searchName.length) {
        DicValueSet(searchName, @"merchantName");
    }
    DicValueSet(@(pageSize), @"limit");
    DicValueSet(@(pageIndex), @"offset");
    [self dataTaskMethod:HTTPMethodPOST
                    path:@"/app/merchant/selectByPage"
                  params:ParamsDic
              networkHUD:NetworkHUDError
                  target:target success:success];
}

+ (void)getStadiumInfoById:(NSInteger)stadiumId
                    target:(id)target
                   success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet(@(stadiumId), @"id");
    [self dataTaskMethod:HTTPMethodPOST
                    path:@"/app/merchant/selectById"
                  params:ParamsDic
              networkHUD:NetworkHUDLockScreen
                  target:target success:success];
}
@end
