//
//  YGBaseViewController.h
//  YoGa
//
//  Created by 罗琰 on 2018/8/1.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGBaseViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *networkOperations;
// 点击空白处键盘收回
- (void)textFieldReturn;

/// 返回上层视图方法
- (void)backToSuperView;

//设置导航栏右按钮
- (void)rightBarButtonWithName:(NSString *)name
                 normalImgName:(NSString *)normalImgName
              highlightImgName:(NSString *)highlightImgName
                        target:(id)target
                        action:(SEL)action;
@end
