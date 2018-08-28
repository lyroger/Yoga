//
//  YGDBManager.h
//  YoGa
//
//  Created by Mac on 2018/8/28.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "YGUserInfo.h"

@interface YGDBManager : NSObject
- (BOOL)updateUserInfo:(YGUserInfo*)userInfo;
- (YGUserInfo *)fetchUserInfoByPhone:(NSString*)phone;
@end
