//
//  StatusModel.h
//  HKMember
//
//  Created by 文俊 on 14-3-20.
//  Copyright (c) 2014年 文俊. All rights reserved.
//
#import "BaseModel.h"

@interface StatusModel : BaseModel

@property (nonatomic, assign) NSInteger code;           //状态码,0代表成功，其他代表失败
@property (nonatomic, copy) NSString* msg;              //打印信息
@property (nonatomic, strong) id data;                  //数据，对应的Model  eg. xxModel or xxModel数组
@property (nonatomic, strong) id originalData;          //数据，未经过映射的原始数据


- (id)initWithCode:(NSInteger)code msg:(NSString *)msg;

- (id)initWithError:(NSError*)error;

// 判断是否是服务器错误，用于判断设置loadingDataFail
- (BOOL)isServersError;

// 手机网络有问题。
- (BOOL)isBadNetWork;

@end
