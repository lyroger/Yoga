//
//  YGLoginViewController.h
//  YoGa
//
//  Created by 罗琰 on 2018/8/2.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGBaseViewController.h"
typedef void(^DidLoginComplete)(BOOL successful);
@interface YGLoginViewController : YGBaseViewController
@property (nonatomic, copy) DidLoginComplete loginCompleteBlock;
@end
