//
//  YGUserInfo.h
//  YoGa
//
//  Created by 罗琰 on 2018/8/19.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "BaseModel.h"

@interface YGUserInfo : BaseModel
@property (nonatomic, copy) NSString *userId;           //用户ID
@property (nonatomic, copy) NSString *userName;         //用户姓名
@property (nonatomic, copy) NSString *token;            //用户token

+ (instancetype)shareUserInfo;
// 保存用户登录token
- (BOOL)saveUserToken:(NSString*)token;
// 获取用户登录token；
- (NSString*)getUserToken;
// 清空用户登录token信息
- (void)clearUserToken;
@end
