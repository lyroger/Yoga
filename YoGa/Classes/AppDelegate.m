//
//  AppDelegate.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/1.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "AppDelegate.h"
#import "YGLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    [self authorizeOperation];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)authorizeOperation {
    NSString *token = [[YGUserInfo shareUserInfo] getUserToken];
    if (token) {
        [YGUserInfo shareUserInfo].token = token;
        self.tabBarVC = [[YGMainTabbarViewController alloc] init];
        self.window.rootViewController = self.tabBarVC;
    } else {
        YGLoginViewController *vc = [[YGLoginViewController alloc] init];
        vc.loginCompleteBlock = ^(BOOL successful) {
            if (successful) {
                self.tabBarVC = [[YGMainTabbarViewController alloc] init];
                self.window.rootViewController = self.tabBarVC;
            }
        };
        self.window.rootViewController = vc;
    }
}

- (void)setNavigationBar
{
    UIImage *bgImage = [UIImage imageNamed:@"nav_bg_image"];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 2,1) resizingMode:UIImageResizingModeStretch];
    [[UINavigationBar appearance] setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setBarTintColor:UIColorHex(0xffffff)];
    [[UINavigationBar appearance] setTintColor:UIColorHex(0xffffff)];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(0x333333), NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
