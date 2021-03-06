//
//  YGMainTabbarViewController.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/1.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGMainTabbarViewController.h"
#import "YGStadiumViewController.h"
#import "YGMeViewConter.h"

@interface YGMainTabbarViewController ()<UITabBarControllerDelegate>
{
    
}
@end

@implementation YGMainTabbarViewController

- (void)viewDidLoad{
    [self loadTabBarView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenExpire) name:kUserTokenExpireNotification object:nil];
}

- (void)tokenExpire
{
    [YGUserInfo shareUserInfo].token = nil;
    [[YGUserInfo shareUserInfo] updateUserInfoToDB];
    [kAppDelegate authorizeOperation];
}

- (void)loadTabBarView
{
    YGStadiumViewController *homeController = [[YGStadiumViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeController];
    
    YGMeViewConter *meController = [[YGMeViewConter alloc] init];
    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:meController];
    
    [self createWithArrayViewControllers:@[homeNav, meNav]
                        arrayImageNormal:@[@"tab_01_normal", @"tab_02_normal"]
                        arrayImageSelect:@[@"tab_01_select", @"tab_02_select"]
                              arrayTitle:@[@"场馆" ,@"我"]];
}

- (void)createWithArrayViewControllers:(NSArray *)viewControllers
                      arrayImageNormal:(NSArray *)arrayImageNor
                      arrayImageSelect:(NSArray *)arrayImageSel
                            arrayTitle:(NSArray *)arrayTitle
{
    self.viewControllers = viewControllers;
//    [self.tabBar setSelectedImageTintColor:UIColorHex(0x121212)];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = UIColorHex(0x121212);
    self.tabBar.barTintColor = UIColorHex(0x121212);

    //修改tabbar顶部上的一条黑线
    CGRect rect = CGRectMake(0, 0, kScreenWidth, 49);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
    self.delegate = self;

    //用自己的颜色
    self.tabBar.layer.borderWidth = 0.5;
    self.tabBar.layer.borderColor = UIColorHex(0xCCCCCC).CGColor;

    for (int i = 0; i < self.viewControllers.count; i++)
    {
        UIViewController *vc = self.viewControllers[i];
        NSString *title = arrayTitle[i];
        UIImage *imageNor = [UIImage imageNamed:arrayImageNor[i]];
        UIImage *imageSel = [UIImage imageNamed:arrayImageSel[i]];
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:imageNor selectedImage:imageSel];
        //调整tabbar的title与图片之间的间距
        //        [vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2.0)];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
