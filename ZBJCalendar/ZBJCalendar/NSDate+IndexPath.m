//
//  NSDate+IndexPath.m
//  ZBJCalendar
//
//  Created by gumpwang on 2/29/16.
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
    NSCalendar *calendar = [NSDate gregorianCalendar];
    NSDate *firstDay = [NSDate  dateForFirstDayInSection:indexPath.section firstDate:firstDate];
    NSDate * lastDate = [firstDay lastDateOfMonth];
    NSInteger weekDay = [firstDay weekday];
    NSInteger weekDayStart = calendar.firstWeekday;    
    NSInteger firstDayOffset = (weekDay < weekDayStart)? 7 : 0;
    
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:firstDay];
    [components setDay:indexPath.row - (weekDay - weekDayStart) - firstDayOffset];
    [components setMonth:indexPath.section];
    NSDate *dateToReturn = [calendar dateByAddingComponents:components toDate:[firstDate firstDateOfMonth] options:0];
    
    if ([dateToReturn timeIntervalSinceNow] < [firstDay timeIntervalSinceNow] || [dateToReturn timeIntervalSinceNow] > [lastDate timeIntervalSinceNow]) {
        return nil;
    }
    return dateToReturn;
}

+ (NSIndexPath *)indexPathAtDate:(NSDate *)date firstDate:(NSDate *)firstDate {
    NSCalendar *calendar = [NSDate gregorianCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSDateComponents *firstDateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:firstDate];
    NSInteger section = (components.year - firstDateComponents.year) * 12 + components.month - firstDateComponents.month;
    
    NSDate *firstDateOfMonth = [date firstDateOfMonth];
    NSInteger firstDayOffset = firstDateOfMonth.weekday - calendar.firstWeekday;
    if (firstDayOffset < 0) {
        firstDayOffset += 7;
    }
    NSInteger index = components.day + firstDayOffset - 1;

    return [NSIndexPath indexPathForItem:index inSection:section];
}

@end
