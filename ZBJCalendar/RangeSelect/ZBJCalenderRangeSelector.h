//
//  ZBJCalenderRangeSelector.h
//  ZBJCalendar
//
//  Created by wanggang on 3/15/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBJCalendarView.h"

@interface ZBJCalenderRangeSelector : NSObject <ZBJCalendarDelegate>

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end
