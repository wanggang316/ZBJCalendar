//
//  NSDate+ZBJAddition.h
//  ZBJCalendar
//
//  Created by gumpwang on 2/26/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This category provide utility methods for `NSDate`.
 */
@interface NSDate (ZBJAddition)

+ (NSCalendar *)gregorianCalendar;
+ (NSLocale *)locale;

+ (NSDate *)today;
+ (NSInteger)numberOfMonthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+ (NSInteger)numberOfDaysFromMonth:(NSDate *)fromMonth toMonth:(NSDate *)toMonth;
+ (NSInteger)numberOfDaysInMonth:(NSDate *)date;
+ (NSInteger)numberOfNightsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (NSDate *)firstDateOfMonth;
- (NSDate *)firstDateOfWeek;
- (NSDate *)lastDateOfMonth;

- (NSInteger)weekday;

- (BOOL)isToday;
- (BOOL)isWeekend;

@end
