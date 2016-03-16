//
//  ZBJCalenderRangeSelector.h
//  ZBJCalendar
//
//  Created by wanggang on 3/15/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBJCalendarView.h"
#import "ZBJCalendarRangeCell.h"


typedef CF_ENUM(NSInteger, ZBJCalendarSelectedState) {
    ZBJCalendarStateSelectedNone,
    ZBJCalendarStateSelectedStart,
    ZBJCalendarStateSelectedRange,
};

@interface ZBJCalenderRangeSelector : NSObject <ZBJCalendarDelegate>

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, assign) ZBJCalendarSelectedState selectedState;

@property (nonatomic, assign) ZBJRangeCellStyle cellStyle;

- (void)setSelectedState:(ZBJCalendarSelectedState)selectedState calendarView:(ZBJCalendarView *)calendarView;
@end
