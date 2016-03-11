//
//  ZBJOfferCalendar.m
//  ZBJCalendar
//
//  Created by wanggang on 3/10/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJOfferCalendar.h"

@interface ZBJOfferCalendar()

@property (nonatomic, strong, readwrite) NSMutableSet *adates;

@end

@implementation ZBJOfferCalendar


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
            [self.adates addObject:[[ZBJOfferDay alloc] initWithDictionary:dic]];
        }
    }
    return self;
}

- (NSArray *)dates {
    return [self.adates copy];
}

@end


@implementation ZBJOfferDay

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