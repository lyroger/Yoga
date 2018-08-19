//
//  YGMessageModel.h
//  YoGa
//
//  Created by 罗琰 on 2018/8/13.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

@interface YGLoginModel : BaseModel
+ (void)getCodeMessageWithPhone:(NSString*)phone
                         target:(id)target
                        success:(NetResponseBlock)success;

+ (void)loginRequestWithPhone:(NSString*)phone
                         code:(NSString*)code
                         target:(id)target
                      success:(NetResponseBlock)success;

@end
