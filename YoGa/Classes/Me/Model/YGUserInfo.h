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
@property (nonatomic, copy) NSString *phone;         //用户手机号
@property (nonatomic, copy) NSString *token;            //用户token
@property (nonatomic, copy) NSString *headImageUrl;     //用户头像地址
@property (nonatomic,assign) NSInteger gender;          //性别

+ (instancetype)shareUserInfo;
// 保存用户登录token
- (BOOL)saveUserToken:(NSString*)token;
// 获取用户登录token；
- (NSString*)getUserToken;
// 清空用户登录token信息
- (void)clearUserToken;

+ (void)updateUserInfoUserName:(NSString*)name
                        gender:(NSInteger)gender
                        target:(id)target
                       success:(NetResponseBlock)success;

+ (void)feedbackInfo:(NSString*)text
              target:(id)target
             success:(NetResponseBlock)success;
@end
