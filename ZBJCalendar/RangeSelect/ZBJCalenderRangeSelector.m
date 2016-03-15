//
//  ZBJCalenderRangeSelector.m
//  ZBJCalendar
//
//  Created by wanggang on 3/15/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalenderRangeSelector.h"
#import "ZBJCalendarRangeCell.h"

typedef CF_ENUM(NSInteger, ZBJCalendarSelectedState) {
    ZBJCalendarStateSelectedNone,
    ZBJCalendarStateSelectedStart,
    ZBJCalendarStateSelectedRange,
};

@interface ZBJCalenderRangeSelector()

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, assign) ZBJCalendarSelectedState selectedState;
@end

@implementation ZBJCalenderRangeSelector

#pragma mark - ZBJCalendarDelegate
- (BOOL)calendarView:(ZBJCalendarView *)calendarView shouldSelectDate:(NSDate *)date {
    
    // 日期在今天之前
    // 先取到当天的最后一秒: xxxx-xx-xx 23:59:59
    if ([[date dateByAddingTimeInterval:86400.0 - 1] compare:calendarView.firstDate] == NSOrderedAscending) {
        return NO;
    }
    switch (self.selectedState) {
        case ZBJCalendarStateSelectedStart: {
            // self.startDate && !self.endDate && 结束日期 < 起始日期
            if ([date compare:self.startDate] == NSOrderedAscending) {
                return NO;
            }
            break;
        }
        default:
            break;
            
    }
    return YES;
}
- (void)calendarView:(ZBJCalendarView *)calendarView configureCell:(ZBJCalendarRangeCell *)cell forDate:(NSDate *)date {
    
    cell.date = date;
    
    ZBJCalendarCellState cellState = -1;
    
    if (date) {
        // 如果小于起始日期或大于结束日期，那么disabled
        if ([[date dateByAddingTimeInterval:86400.0 - 1] compare:calendarView.firstDate] == NSOrderedAscending ||
            [date compare:calendarView.lastDate] != NSOrderedAscending) { //不大于最后一天
            cellState = ZBJCalendarCellStateDisabled;
        } else {
            
            switch (self.selectedState) {
                case ZBJCalendarStateSelectedStart: {
                    
                    if ([[date dateByAddingTimeInterval:86400.0 - 1] compare:self.startDate] == NSOrderedAscending &&
                        [date compare:calendarView.firstDate] == NSOrderedDescending) {
                        
                        cellState = ZBJCalendarCellStateAvaibleDisabled;
                    }  else if ([self.startDate isEqualToDate:date]) {
                        cellState = ZBJCalendarCellStateSelectedStart;
                    } else {
                        cellState = ZBJCalendarCellStateAvaible;
                    }
                    
                    break;
                }
                case ZBJCalendarStateSelectedRange: {
                    
                    if ([self.startDate isEqualToDate:date]) {
                        cellState = ZBJCalendarCellStateSelectedStart;
                    } else if ([self.endDate isEqualToDate:date]) {
                        cellState = ZBJCalendarCellStateSelectedEnd;
                    } else if (self.startDate && self.endDate &&
                               [[date dateByAddingTimeInterval:86400.0 - 1] compare:self.endDate] == NSOrderedAscending &&
                               [date compare:self.startDate] == NSOrderedDescending) {
                        cellState = ZBJCalendarCellStateSelectedMiddle;
                    } else {
                        cellState = ZBJCalendarCellStateAvaible;
                    }
                    
                    break;
                }
                default: {
                    cellState = ZBJCalendarCellStateAvaible;
                    break;
                }
            }
        }
    } else {
        cellState = ZBJCalendarCellStateEmpty;
    }
   
    cell.cellState = cellState;
}
- (void)calendarView:(ZBJCalendarView *)calendarView didSelectDate:(NSDate *)date {
    
    if (calendarView.selectionMode == ZBJSelectionModeRange) {
        if (date) {
            if (!self.startDate) {
                self.startDate = date;
                [self setSelectedState:ZBJCalendarStateSelectedStart calendarView:calendarView];
            } else if (!self.endDate) {
                if ([self.startDate isEqualToDate:date]) {
                    [self setSelectedState:ZBJCalendarStateSelectedNone calendarView:calendarView];
                    return;
                }
                self.endDate = date;
                [self setSelectedState:ZBJCalendarStateSelectedRange calendarView:calendarView];
            } else {
                self.startDate = date;
                [self setSelectedState:ZBJCalendarStateSelectedStart calendarView:calendarView];
            }
        }
    }
}


- (void)reset {
   
}


- (void)setSelectedState:(ZBJCalendarSelectedState)selectedState calendarView:(ZBJCalendarView *)calendarView {

    _selectedState = selectedState;
    
    switch (_selectedState) {
        case ZBJCalendarStateSelectedNone: {
            self.startDate = nil;
            self.endDate = nil;
            [calendarView.collectionView reloadData];
            calendarView.collectionView.allowsSelection = YES;
            break;
        }
        case ZBJCalendarStateSelectedStart: {
            self.endDate = nil;
            [calendarView.collectionView reloadData];
            break;
        }
        case ZBJCalendarStateSelectedRange: {
            [calendarView.collectionView reloadData];
            break;
        }
        default:
            break;
    }
}

@end
