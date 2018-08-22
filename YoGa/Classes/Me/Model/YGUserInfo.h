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
+ (LKDBHelper *)getUsingLKDBHelper;
- (void)setUserInfo:(YGUserInfo*)userInfo;
- (void)getUserInfoFromLocal;
- (BOOL)updateUserInfoToDB;
+ (void)getCodeMessageWithPhone:(NSString*)phone
                         target:(id)target
                        success:(NetResponseBlock)success;

+ (void)loginRequestWithPhone:(NSString*)phone
                         code:(NSString*)code
                       target:(id)target
                      success:(NetResponseBlock)success;

+ (void)logOutRequestTarget:(id)target
                    success:(NetResponseBlock)success;

+ (void)updateUserInfoUserName:(NSString*)name
                        gender:(NSInteger)gender
                     headImage:(UIImage*)headPhoto
                        target:(id)target
                       success:(NetResponseBlock)success;

+ (void)feedbackInfo:(NSString*)text
              target:(id)target
             success:(NetResponseBlock)success;
@end
