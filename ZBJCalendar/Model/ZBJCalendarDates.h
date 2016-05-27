//
//  ZBJCalendarDates.h
//  ZBJCalendar
//
//  Created by gumpwang on 3/10/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBJCalendarDates : NSObject

@property (nonatomic, strong) NSNumber *offerId;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong, readonly) NSSet *dates;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface ZBJCalendarDate : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *available;
@property (nonatomic, strong) NSNumber *price;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
