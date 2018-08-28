//
//  YGDBManager.m
//  YoGa
//
//  Created by Mac on 2018/8/28.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGDBManager.h"

@interface YGDBManager()
{
    FMDatabase *database;
}

@end

@implementation YGDBManager
- (NSString *)documentsPathWithSqliteName:(NSString *)sqliteName
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:sqliteName];
}
#pragma mark - 打开数据库操作------ databaseWithPath   open
- (BOOL)openUserInfoTable
{

    NSString *filePath = [self documentsPathWithSqliteName:@"UserInfoDB.sqlite"];

    database = [FMDatabase databaseWithPath:filePath];

    if (![database open])
    {
        NSLog(@"数据库打开失败");
        return FALSE;
    };

    NSString *createStr = @"CREATE TABLE IF NOT EXISTS userinfo ('phone' INTEGER PRIMARY KEY NOT NULL UNIQUE, 'userId' VARCHAR, 'nickName' VARCHAR, 'token' VARCHAR, 'headImageUrl' VARCHAR, 'gender' VARCHAR)";
    BOOL worked = [database executeUpdate:createStr];

    if (!worked)
    {
        NSLog(@"userinfo 表 创建失败");
        return FALSE;
    }
    else
        return TRUE;
}

- (BOOL)updateUserInfo:(YGUserInfo*)userInfo
{
    if (![self openUserInfoTable]) return false;

    BOOL worked;

    FMResultSet *rs = [database executeQuery:[NSString stringWithFormat:@"select * from userinfo where phone='%@'",userInfo.phone]];

    if (![rs next])
    {
        NSArray *paramArray = @[userInfo.phone?userInfo.phone:@"",
                                userInfo.userId?userInfo.userId:@"",
                                userInfo.nickName?userInfo.nickName:@"",
                                userInfo.token?userInfo.token:@"",
                                userInfo.headImageUrl?userInfo.headImageUrl:@"",
                                @(userInfo.gender)];
        NSString *sqlString = @"INSERT INTO userinfo ('phone', 'userId','nickName','token','headImageUrl','gender') values (?,?,?,?,?,?)";
        worked = [database executeUpdate:sqlString withArgumentsInArray:paramArray];
        if (worked) {
            NSLog(@"没有找到对应用户，新增用户成功");
        }
    } else {
        NSArray *paramArray = @[userInfo.phone?userInfo.phone:@"",
                                userInfo.userId?userInfo.userId:@"",
                                userInfo.nickName?userInfo.nickName:@"",
                                userInfo.token?userInfo.token:@"",
                                userInfo.headImageUrl?userInfo.headImageUrl:@"",
                                @(userInfo.gender),
                                userInfo.phone?userInfo.phone:@"",];
        NSString *sqlString = @" UPDATE userinfo SET phone=?,userId=?,nickName=?,token=?,headImageUrl=?,gender=? WHERE phone = ?";
        worked = [database executeUpdate:sqlString withArgumentsInArray:paramArray];
        if (worked) {
            NSLog(@"更新用户信息成功。");
        }
    }

    [database close];

    return worked;
}

- (YGUserInfo *)fetchUserInfoByPhone:(NSString*)phone
{
    if (![self openUserInfoTable]) return nil;

    FMResultSet *rs = [database executeQuery:[NSString stringWithFormat:@"select * from userinfo where phone='%@'",phone]];
    if ([rs next]) {
        [YGUserInfo shareUserInfo].phone = phone;
        [YGUserInfo shareUserInfo].userId = [rs stringForColumn:@"userId"];
        [YGUserInfo shareUserInfo].nickName = [rs stringForColumn:@"nickName"];
        [YGUserInfo shareUserInfo].token = [rs stringForColumn:@"token"];
        [YGUserInfo shareUserInfo].headImageUrl = [rs stringForColumn:@"headImageUrl"];
        [YGUserInfo shareUserInfo].gender = [rs intForColumn:@"gender"];
        [database close];
        return [YGUserInfo shareUserInfo];
    } else {
        [database close];
        return nil;
    }
}

@end
