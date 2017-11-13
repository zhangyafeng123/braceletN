//
//  AppDelegate.m
//  braceletC
//
//  Created by 张亚峰 on 2017/4/5.
//  Copyright © 2017年 张亚峰. All rights reserved.
//

#import "AppDelegate.h"
#import "NSObject+NSLocalNotification.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    if ([[UIDevice currentDevice].systemVersion floatValue] >=10.0) {
        UNAuthorizationOptions type10 = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:type10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许之后
                NSLog(@"注册iOS10本地通知成功");
            } else {
                //点击不允许之后
            }
        }];
    }
    
    return YES;
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    //判断应用程序当前的运行状态，如果是激活状态，则进行提醒，否则不提醒
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"test" message:notification.alertBody delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:notification.alertAction, nil];
        [alert show];
    } else {
        //用户在后台点击进入
        
        
    }
}
//iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台是的远程推送
    } else {
        //应用处于前台是的本地推送接受
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.request.content.title message:notification.request.content.body delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    //
    //completionHandler(UNNotificationPresentationOptionAlert |UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台是的远程推送
    } else {
        
        //应用处于后台是的本地推送接受
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopzhendong" object:nil];
    }
    //
    completionHandler(UNNotificationPresentationOptionAlert |UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
}




-(NSString *)showText:(NSString *)key
{
    NSString *path = [[NSBundle mainBundle] pathForResource:_lan ofType:@"lproj"];
    
    return [[NSBundle bundleWithPath:path] localizedStringForKey:key value:nil table:@"CustomLocalizable"];
}
//短信来了或者电话来了之后
- (void)applicationWillResignActive:(UIApplication *)application {
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}


@end
