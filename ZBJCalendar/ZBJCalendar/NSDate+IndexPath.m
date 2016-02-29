//
//  NSDate+IndexPath.m
//  ZBJCalendar
//
//  Created by wanggang on 2/29/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "NSDate+IndexPath.h"
#import "NSDate+ZBJAddition.h"
#import <UIKit/UIKit.h>

@implementation NSDate (IndexPath)


+ (NSDate *)dateForFirstDayInSection:(NSInteger)section firstDate:(NSDate *)firstDate {
    NSCalendar *calendar = [NSDate gregorianCalendar];
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.month = section;
    return [calendar dateByAddingComponents:dateComponents toDate:[firstDate firstDateOfMonth] options:0];
}

+ (NSDate *)dateAtIndexPath:(NSIndexPath *)indexPath firstDate:(NSDate *)firstDate {
    NSDate *firstDay = [NSDate  dateForFirstDayInSection:indexPath.section firstDate:firstDate];
    NSInteger weekDay = [firstDay weekday];
    NSDate *dateToReturn = nil;
    
    if (indexPath.row < (weekDay-1)) {
        dateToReturn = nil;
    } else {
        NSCalendar *calendar = [NSDate gregorianCalendar];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:firstDay];
        [components setDay:indexPath.row - (weekDay - 1)];
        [components setMonth:indexPath.section];
        dateToReturn = [calendar dateByAddingComponents:components toDate:[firstDate firstDateOfMonth] options:0];
    }
    return dateToReturn;
}

@end
