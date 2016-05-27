//
//  NSDate+ZBJAddition.m
//  ZBJCalendar
//
//  Created by gumpwang on 2/26/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "NSDate+ZBJAddition.h"
#import <objc/runtime.h>

const char * const JmoCalendarStoreKey = "jmo.calendar";
const char * const JmoLocaleStoreKey = "jmo.locale";

@implementation NSDate (ZBJAddition)

#pragma mark -
+ (void)setGregorianCalendar:(NSCalendar *)gregorianCalendar
{
    objc_setAssociatedObject(self, JmoCalendarStoreKey, gregorianCalendar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSCalendar *)gregorianCalendar
{
    NSCalendar *cal = objc_getAssociatedObject(self, JmoCalendarStoreKey);
    if (nil == cal) {
        cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [cal setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        [cal setLocale:[self locale]];
        [self setGregorianCalendar:cal];
    }
    return cal;
}

+ (void)setLocal:(NSLocale *)locale
{
    objc_setAssociatedObject(self, JmoLocaleStoreKey, locale, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSLocale *)locale
{
    NSLocale *locale  = objc_getAssociatedObject(self, JmoLocaleStoreKey);
    if (nil == locale) {
        locale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
        [self setLocal:locale];
    }
    return locale;
}


#pragma mark -
+ (NSDate *)today {
    NSDate *sourceDate = [NSDate date];
    
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    return [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
}
+ (NSInteger)numberOfMonthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendar *calendar = [self gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:[fromDate firstDateOfMonth] toDate:[toDate lastDateOfMonth] options:NSCalendarMatchStrictly];
    // 2016.9.16 - 2016.3.16 = 5  if use [fromDate firstDateOfMonth] and [toDate lastDateOfMonth], the result is 6. ok
    // 2017.3.16 - 2016.3.16 = 12
    return components.month + 1;
}

+ (NSInteger)numberOfDaysFromMonth:(NSDate *)fromMonth toMonth:(NSDate *)toMonth {
    NSCalendar *calendar = [self gregorianCalendar];
    NSDate *firstDate = [fromMonth firstDateOfMonth];
    NSDate *lastDate = [toMonth lastDateOfMonth];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:firstDate toDate:lastDate options:NSCalendarMatchStrictly];
    return components.day + 1;
}

+ (NSInteger)numberOfDaysInMonth:(NSDate *)date {
    NSCalendar *calendar = [self gregorianCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

+ (NSInteger)numberOfNightsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlag = NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unitFlag fromDate:fromDate toDate:toDate options:0];
    NSInteger days = [components day];
    return days;
}

#pragma mark -
- (NSDate *)firstDateOfMonth {
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    components.day = 1;
    return [calendar dateFromComponents:components];
}

- (NSDate *)firstDateOfWeek {
    
    NSInteger weekDay = self.weekday;
    
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self];
    components.day = components.day - weekDay + 1;
    return [calendar dateFromComponents:components];
}

- (NSDate *)lastDateOfMonth {
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    components.month = components.month + 1;
    components.day = 0;
    return [calendar dateFromComponents:components];
}

- (NSInteger)weekday {
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSDateComponents *compoents = [calendar components:NSCalendarUnitWeekday fromDate:self];
    return compoents.weekday;
}

- (BOOL)isToday {
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSDateComponents *otherDay = [calendar components:NSCalendarUnitEra | NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    if([today day] == [otherDay day] &&
       [today month] == [otherDay month] &&
       [today year] == [otherDay year] &&
       [today era] == [otherDay era]) {
        return YES;
    }
    return NO;
}

- (BOOL)isWeekend {
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSRange weekdayRange = [calendar maximumRangeOfUnit:NSCalendarUnitWeekday];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSUInteger weekdayOfDate = [components weekday];
    
    if (weekdayOfDate == weekdayRange.location || weekdayOfDate == weekdayRange.length) {
        //the date falls somewhere on the first or last days of the week
        return YES;
    }
    return NO;
}





@end
