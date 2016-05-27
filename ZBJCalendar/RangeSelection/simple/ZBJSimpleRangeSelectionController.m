//
//  ZBJSimpleRangeSelectionController.m
//  ZBJCalendar
//
//  Created by gumpwang on 2/26/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJSimpleRangeSelectionController.h"
#import "ZBJCalendar.h"
#import "ZBJSimpleRangeSelectionCell.h"
#import "ZBJCalendarSectionHeader.h"
#import "ZBJCalendarSectionFooter.h"

typedef CF_ENUM(NSInteger, ZBJCalendarSelectedState) {
    ZBJCalendarStateSelectedNone,
    ZBJCalendarStateSelectedStart,
    ZBJCalendarStateSelectedRange,
};

@interface ZBJSimpleRangeSelectionController () <ZBJCalendarDelegate, ZBJCalendarDataSource>

@property (nonatomic, strong) ZBJCalendarView *calendarView;
@property (nonatomic, assign) ZBJCalendarSelectedState selectedState;
@property (nonatomic, assign) ZBJRangeCellStyle cellStyle;

@end

@implementation ZBJSimpleRangeSelectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDate *firstDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:firstDate];
    components.month = components.month + 6; //
    NSDate *lastDate = [calendar dateFromComponents:components];
    
    self.calendarView.delegate = self;
    self.calendarView.dataSource = self;
    self.calendarView.firstDate = firstDate;
    self.calendarView.lastDate = lastDate;

    [self.view addSubview:self.calendarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pop {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popViewController:startDate:endDate:)]) {
        [self.delegate popViewController:self startDate:self.startDate endDate:self.endDate];
    }
}

#pragma mark - ZBJCalendarDelegate && ZBJCalendarDataSource
- (void)calendarView:(ZBJCalendarView *)calendarView configureCell:(ZBJSimpleRangeSelectionCell *)cell forDate:(NSDate *)date {
    
    cell.cellStyle = self.cellStyle;
    
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
                    
                    if ([[date dateByAddingTimeInterval:86400.0 - 1] compare:self.startDate] == NSOrderedAscending) {
                        
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
- (void)calendarView:(ZBJCalendarView *)calendarView didSelectDate:(NSDate *)date ofCell:(id)cell {
    
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
                self.endDate = nil;
                self.startDate = date;
                [self setSelectedState:ZBJCalendarStateSelectedStart calendarView:calendarView];
            }
        }
    }
}

- (void)setSelectedState:(ZBJCalendarSelectedState)selectedState calendarView:(ZBJCalendarView *)calendarView {
    
    _selectedState = selectedState;
    
    switch (_selectedState) {
        case ZBJCalendarStateSelectedNone: {
            self.startDate = nil;
            self.endDate = nil;
            [calendarView reloadData];
            calendarView.allowsSelection = YES;
            break;
        }
        case ZBJCalendarStateSelectedStart: {
            
            [calendarView reloadData];
            break;
        }
        case ZBJCalendarStateSelectedRange: {
            [calendarView reloadData];
            // pop self
            [self performSelector:@selector(pop) withObject:nil afterDelay:0.4];
            break;
        }
        default:
            break;
    }
}


- (void)calendarView:(ZBJCalendarView *)calendarView configureSectionHeaderView:(ZBJCalendarSectionHeader *)headerView firstDateOfMonth:(NSDate *)firstDateOfMonth {
    NSCalendar *calendar = [NSDate gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:firstDateOfMonth];
    headerView.year = components.year;
    headerView.month = components.month;
}




#pragma mark -
- (ZBJCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[ZBJCalendarView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
        [_calendarView registerCellClass:[ZBJSimpleRangeSelectionCell class] withReuseIdentifier:@"cell"];
        [_calendarView registerSectionHeader:[ZBJCalendarSectionHeader class] withReuseIdentifier:@"sectionHeader"];
        [_calendarView registerSectionFooter:[ZBJCalendarSectionFooter class] withReuseIdentifier:@"sectionFooter"];
        _calendarView.contentInsets = UIEdgeInsetsMake(0, 14, 0, 14);
        _calendarView.sectionHeaderHeight = 52;
        _calendarView.sectionFooterHeight = 13;
        _calendarView.cellScale = 90.0 / 102.0;
        
    }
    return _calendarView;
}

@end
