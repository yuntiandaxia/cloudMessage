//
//  AppDelegate.m
//  cloudMessage
//
//  Created by iMac mini on 2016/11/6.
//  Copyright © 2016年 iMac mini. All rights reserved.
//

#import "AppDelegate.h"
#import "global.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)setNav{
    UINavigationBar *bar = [UINavigationBar appearance];
    
    //设置显示的颜色
    //bar.barTintColor = [UIColor colorWithRed:116/255.0 green:215/255.0 blue:54/255.0 alpha:1.0];//62\173\176
    //bar.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    if (CURRENT_SYS_VERSION >= 7.0) {
        [bar setBarTintColor:[UIColor colorWithRed:0.071 green:0.060 blue:0.086 alpha:1.000]];
        [bar setTintColor:[UIColor whiteColor]];
    }else{
        [bar setTintColor:[UIColor colorWithRed:0.071 green:0.060 blue:0.086 alpha:1.000]];
    }
    
    //设置字体颜色
    //bar.tintColor = [UIColor whiteColor];
    //[bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [bar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:17.0],NSFontAttributeName, nil]];
    
    //或者用这个都行
    //[bar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]}];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setNav];
    return YES;
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
