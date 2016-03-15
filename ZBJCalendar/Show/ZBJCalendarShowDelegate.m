//
//  ZBJCalendarShowDelegate.m
//  ZBJCalendar
//
//  Created by wanggang on 3/15/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarShowDelegate.h"
#import "ZBJCalendarShowCell.h"
#import "ZBJCalendarSectionHeader.h"

@implementation ZBJCalendarShowDelegate


#pragma mark - private methods
- (ZBJOfferDay *)offerDateWithDate:(NSDate *)date {
    for (ZBJOfferDay *day in self.offerCal.dates) {
        if ([day.date isEqualToDate:date]) {
            return day;
            break;
        }
    }
    return nil;
}

#pragma mark - ZBJCalendarDelegate
- (BOOL)calendarView:(ZBJCalendarView *)calendarView shouldSelectDate:(NSDate *)date {
    return YES;
}
- (void)calendarView:(ZBJCalendarView *)calendarView configureCell:(ZBJCalendarShowCell *)cell forDate:(NSDate *)date {
    
    cell.date = date;
    
    ZBJCalendarCellState cellState = -1;
    NSNumber *price = nil;
    
    if (date) {
        // 如果小于起始日期或大于结束日期，那么disabled
        if ([[date dateByAddingTimeInterval:86400.0 - 1] compare:calendarView.firstDate] == NSOrderedAscending ||
            [date compare:calendarView.lastDate] != NSOrderedAscending) { //不小于最后一天
            cellState = ZBJCalendarCellStateDisabled;
        } else {
            
            ZBJOfferDay *day = [self offerDateWithDate:date];
            price = day.price;
            
            if (day.available.boolValue) {
                cellState = ZBJCalendarCellStateAvaible;
            } else {
                cellState = ZBJCalendarCellStateUnavaible;
            }
        }
    } else {
        cellState = ZBJCalendarCellStateEmpty;
    }

    cell.price = price;
    cell.cellState = cellState;
}
- (void)calendarView:(ZBJCalendarView *)calendarView didSelectDate:(NSDate *)date {
    
}

- (void)calendarView:(ZBJCalendarView *)calendarView configureSectionHeaderView:(ZBJCalendarSectionHeader *)headerView forYear:(NSInteger)year month:(NSInteger)month {
    headerView.year = year;
    headerView.month = month;
}





@end
