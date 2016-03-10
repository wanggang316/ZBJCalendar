//
//  ZBJOfferCalendar.h
//  ZBJCalendar
//
//  Created by wanggang on 3/10/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBJOfferCalendar : NSObject

@property (nonatomic, strong) NSNumber *offerId;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong, readonly) NSArray *dates;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface ZBJOfferDay : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) BOOL available;
@property (nonatomic, strong) NSNumber *price;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
