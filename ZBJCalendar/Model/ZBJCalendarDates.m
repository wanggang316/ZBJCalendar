//
//  ZBJCalendarDates.m
//  ZBJCalendar
//
//  Created by gumpwang on 3/10/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarDates.h"

@interface ZBJCalendarDates()

@property (nonatomic, strong, readwrite) NSMutableSet *adates;

@end

@implementation ZBJCalendarDates

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [format  setDateFormat:@"yyyy-MM-dd"];
        
        self.offerId = [dictionary objectForKey:@"offer_id"];
        self.startDate = [format dateFromString:[dictionary objectForKey:@"start_date"]];
        self.endDate = [format dateFromString:[dictionary objectForKey:@"end_date"]];
        
        self.adates = [NSMutableSet new];
        NSArray *datesArr = [dictionary objectForKey:@"dates"];
        for (NSDictionary *dic in datesArr) {
            [self.adates addObject:[[ZBJCalendarDate alloc] initWithDictionary:dic]];
        }
    }
    return self;
}

- (NSArray *)dates {
    return [self.adates copy];
}

@end


@implementation ZBJCalendarDate

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [format  setDateFormat:@"yyyy-MM-dd"];
        
        self.date = [format dateFromString:[dictionary objectForKey:@"date"]];
        self.available = [dictionary objectForKey:@"available"];
        self.price = [dictionary objectForKey:@"price"];
    }
    return self;
}

@end