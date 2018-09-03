//
//  YGAddressDetailByMapVC.h
//  YoGa
//
//  Created by Mac on 2018/9/3.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGBaseViewController.h"

@interface YGAddressDetailByMapVC : YGBaseViewController

@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *titleName;
@end
