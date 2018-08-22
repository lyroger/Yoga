//
//  YGEditUserInfoVC.h
//  YoGa
//
//  Created by Mac on 2018/8/22.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGBaseViewController.h"
typedef NS_ENUM(NSInteger , UCEditInfoType) {
    EditInfoType_UserName = 0,    //名称
};

@interface YGEditUserInfoVC : YGBaseViewController
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, assign) UCEditInfoType editType;
@end
