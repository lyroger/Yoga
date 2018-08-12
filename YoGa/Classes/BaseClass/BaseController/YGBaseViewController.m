//
//  YGBaseViewController.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/1.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGBaseViewController.h"

@interface YGBaseViewController ()<UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer  *_tap; // 添加手势用于点击空白处收回键盘
}
@end

@implementation YGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)textFieldReturn
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        _tap.cancelsTouchesInView = NO; // 当前视图识别手势后把事件传递出后
        _tap.delegate = self;
        [self.view addGestureRecognizer:_tap];
    }
}

- (void)tapped:(id)sender
{
    [self.view endEditing:YES];
    [self.navigationItem.titleView endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
