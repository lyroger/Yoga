//
//  YGMessageModel.h
//  YoGa
//
//  Created by 罗琰 on 2018/8/13.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "BaseModel.h"

@interface YGMessageModel : BaseModel
+ (void)getCodeMessageWithPhone:(NSString*)phone
                        success:(NetResponseBlock)success;
@end
