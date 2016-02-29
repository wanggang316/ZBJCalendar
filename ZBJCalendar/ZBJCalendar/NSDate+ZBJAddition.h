//
//  NSDate+ZBJAddition.h
//  ZBJCalendar
//
//  Created by wanggang on 2/26/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZBJAddition)

+ (NSCalendar *)gregorianCalendar;
+ (NSLocale *)locale;

+ (NSInteger)numberOfMonthsFormDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+ (NSInteger)numberOfDaysInMonth:(NSDate *)date;

- (NSDate *)firstDateOfMonth;

- (NSDate *)lastDateOfMonth;

- (NSInteger)weekday;

- (BOOL)isToday;



@end
