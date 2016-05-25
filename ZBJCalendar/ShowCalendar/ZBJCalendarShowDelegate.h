//
//  ZBJCalendarShowDelegate.h
//  ZBJCalendar
//
//  Created by wanggang on 3/15/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBJCalendarView.h"
#import "ZBJOfferCalendar.h"

@interface ZBJCalendarShowDelegate : NSObject <ZBJCalendarDelegate, ZBJCalendarDataSource>

@property (nonatomic, strong) ZBJOfferCalendar *offerCal;

@end
