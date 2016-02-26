//
//  NSDate+ZBJAddition.m
//  ZBJCalendar
//
//  Created by wanggang on 2/26/16.
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
    NSCalendar* cal = objc_getAssociatedObject(self, JmoCalendarStoreKey);
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
+ (NSInteger)numberOfMonthsFormDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendar *calendar = [self gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:fromDate toDate:toDate options:NSCalendarMatchStrictly];
    return components.month + 1;
}

+ (NSInteger)numberOfDaysInMonth:(NSDate *)date {
    NSCalendar *calendar = [self gregorianCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

#pragma mark -
- (NSDate *)firstDateOfMonth {
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    components.day = 1;
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
    return [calendar component:NSCalendarUnitWeekday fromDate:self];
}




@end
