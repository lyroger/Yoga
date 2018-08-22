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
    self.view.backgroundColor = UIColorHex(0xffffff);
//    self.tabBarController.tabBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.navigationController.viewControllers.firstObject != self) {
        [self configBackBarButton];
    }
    // Do any additional setup after loading the view.
}

- (void)configBackBarButton
{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setTitleColor:kMainColor forState:UIControlStateNormal];
    [bt setTitleColor:UIColorHex_Alpha(0x02b0f0,0.3) forState:UIControlStateHighlighted];
    [bt setImage:[UIImage imageNamed:@"nav_ic_back"] forState:UIControlStateNormal];
    //    [bt setImage:[UIImage imageNamed:@"icon_nav_back"] forState:UIControlStateHighlighted];
    bt.frame = CGRectMake(0, 0, 30, 30);
    bt.titleLabel.font = [UIFont systemFontOfSize:16];
    [bt setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 6)];
    [bt addTarget:self action:@selector(backToSuperView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bt];
}

- (void)backToSuperView
{
    if (![self navigationShouldPopOnBackButton]) {
        return;
    }
    if (self.navigationController.viewControllers.firstObject == self) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (self.presentedViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (BOOL)navigationShouldPopOnBackButton
{
    return YES;
}

// 设置导航栏右按钮
- (void)rightBarButtonWithName:(NSString *)name
                 normalImgName:(NSString *)normalImgName
              highlightImgName:(NSString *)highlightImgName
                        target:(id)target
                        action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (normalImgName && ![normalImgName isEqualToString:@""]) {
        UIImage *image = [UIImage imageNamed:normalImgName];
        [btn setImage:image forState:UIControlStateNormal];
        
        UIImage *imageSelected = [UIImage imageNamed:highlightImgName];
        if (imageSelected) {
            [btn setImage:imageSelected forState:UIControlStateHighlighted];
        }
        btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    } else {
        btn.frame=CGRectMake(0, 0, 60, 30);
    }
    
    if (name && ![name isEqualToString:@""])
    {
        [btn setTitle:name forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorHex_Alpha(0x333333,0.3) forState:UIControlStateHighlighted];
        [btn setTitleColor:UIColorHex_Alpha(0x333333,0.3) forState:UIControlStateDisabled];
        CGFloat nameWidth = [name widthWithFont:btn.titleLabel.font constrainedToHeight:CGFLOAT_MAX];
        btn.frame=CGRectMake(0, 0, nameWidth+13, 30);
    }
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 0);
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
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

#pragma mark- 网络操作的添加和释放

- (void)addNet:(NSURLSessionDataTask *)net
{
    if (!_networkOperations)
    {
        _networkOperations = [[NSMutableArray alloc] init];
    }
    
    [_networkOperations addObject:net];
}

- (void)releaseNet
{
    for (NSURLSessionDataTask *net in _networkOperations)
    {
        if ([net isKindOfClass:[NSURLSessionDataTask class]]) {
            [net cancel];
        }
    }
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
