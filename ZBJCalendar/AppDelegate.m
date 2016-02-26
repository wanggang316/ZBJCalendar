//
//  AppDelegate.m
//  ZBJCalendar
//
//  Created by 王刚 on 15/12/8.
//  Copyright © 2015年 ZBJ. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSInteger hour = [calendar component:NSCalendarUnitHour fromDate:[NSDate date]];
//    NSLog(@"---hour : %@", @(hour));
//    
//    NSDate *valentines = [calendar dateWithEra:1 year:2015 month:2 day:14 hour:9 minute:0 second:0 nanosecond:0];
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    components.day = 31;
//    
//    NSDate *date = [calendar nextDateAfterDate:valentines matchingComponents:components options:NSCalendarMatchStrictly];
//    // Mar 31, 2015, 12:00 AM
//
//    date = [calendar nextDateAfterDate:valentines matchingComponents:components options:NSCalendarMatchNextTime];
//
//    
//    
//    NSDateComponents *leapYearComponents = [[NSDateComponents alloc] init];
////    leapYearComponents.month = 2;
////    leapYearComponents.day = 29;
//    leapYearComponents.hour = 1;
//    
//    NSDate *d = [calendar dateWithEra:1 year:2016 month:2 day:1 hour:0 minute:0 second:0 nanosecond:0];
////    NSDate *nd = [calendar dateWithEra:1 year:2016 month:3 day:1 hour:0 minute:0 second:0 nanosecond:0];
//
//    
//    __block int dateCount = 0;
//    [calendar enumerateDatesStartingAfterDate:d
//                           matchingComponents:leapYearComponents
//                                      options:NSCalendarMatchStrictly | NSCalendarMatchNextTime
//                                   usingBlock:^(NSDate *date, BOOL exactMatch, BOOL *stop) {
//                                       NSLog(@"%@", date);
////                                       if (++dateCount == 50) {
////                                           *stop = YES;
////                                       }
//                                   }];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
