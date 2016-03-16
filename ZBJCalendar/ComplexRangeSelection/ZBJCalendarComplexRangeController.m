//
//  ZBJCalendarAdvanceViewController.m
//  ZBJCalendar
//
//  Created by wanggang on 3/10/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarComplexRangeController.h"
#import "ZBJCalendarView.h"
#import "ZBJCalendarComplexCell.h"
#import "ZBJCalendarSectionHeader.h"
#import "ZBJCalendarSectionFooter.h"


@interface ZBJCalendarComplexRangeController () <ZBJCalendarDelegate>

@property (nonatomic, strong) ZBJCalendarView *calendarView;


@property (nonatomic, strong) NSMutableSet *tempUnavaibleDates;
@property (nonatomic, strong) NSDate *nearestUnavaibleDate;

@end

@implementation ZBJCalendarComplexRangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = [NSString stringWithFormat:@"选择起始日期(至少%ld天)", self.minNights];
    
    self.tempUnavaibleDates = [[NSMutableSet alloc] init];
    self.calendarView.firstDate = self.firstDate;
    self.calendarView.lastDate = self.lastDate;
    
    [self.view addSubview:self.calendarView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.startDate && self.endDate) {
        self.selectedState = ZBJCalendarStateSelectedRange;
    } else {
        self.selectedState = ZBJCalendarStateSelectedNone;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pop {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popViewController:startDate:endDate:)]) {
        [self.delegate popViewController:self startDate:self.startDate endDate:self.endDate];
    }
}


#pragma mark - private methods
- (ZBJOfferDay *)offerDateWithDate:(NSDate *)date {
    for (ZBJOfferDay *day in self.dates) {
        if ([day.date isEqualToDate:date]) {
            return day;
            break;
        }
    }
    return nil;
}

- (void)reset {
    self.startDate = nil;
    self.endDate = nil;
    [self.calendarView.collectionView reloadData];
    self.calendarView.collectionView.allowsSelection = YES;
}

// 计算开始日期之后最近的不可选日期
- (NSDate *)findTheNearestUnavaibleDateByStartDate:(NSDate *)date {
    NSDate *nextDate = [date dateByAddingTimeInterval:86400.0];
    ZBJOfferDay *theDay = [self offerDateWithDate:nextDate];
    if (theDay) {
        if (![theDay.available boolValue]) {
            return nextDate;
        } else {
            return [self findTheNearestUnavaibleDateByStartDate:nextDate];
        }
    }
    return nil;
}


#pragma mark - ZBJCalendarDelegate
- (BOOL)calendarView:(ZBJCalendarView *)calendarView shouldSelectDate:(NSDate *)date {
    
//    if (self.selectionMode == ZBJSelectionModeRange) {
        if (date) {
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
                    
                    // 如果最近的不可选日期等于此日期，那么可选
                    if ([self.nearestUnavaibleDate isEqualToDate:date]) {
                        return YES;
                    }
                    
                    // 暂时不可选集合包涵次日期，那么不可选
                    if ([self.tempUnavaibleDates containsObject:date]) {
                        return NO;
                    }
                    
                    if (self.nearestUnavaibleDate &&
                        [date compare:self.nearestUnavaibleDate] == NSOrderedDescending) {
                        return NO;
                    }
                    
                    // 如果不满足上面的条件，那么根据data中的avaible来判断是否可选
                    ZBJOfferDay *day = [self offerDateWithDate:date];
                    if (day) {
                        return [day.available boolValue];
                    }
                    break;
                }
                case ZBJCalendarStateSelectedRange: {
//                    if ([self.nearestUnavaibleDate isEqualToDate:date]) {
//                        return NO;
//                    }
                    
                    // 如果不满足上面的条件，那么根据data中的avaible来判断是否可选
                    ZBJOfferDay *day = [self offerDateWithDate:date];
                    if (day) {
                        return [day.available boolValue];
                    }
                    break;
                }
                default:
                    break;
            }
            
        } else {
            return NO;
        }
//    }

    return YES;
}


- (void)calendarView:(ZBJCalendarView *)calendarView configureCell:(ZBJCalendarComplexCell *)cell forDate:(NSDate *)date {
    
    cell.day = date;

    NSNumber *price = nil;
    ZBJCalendarCellState cellState = -1;
    
    if (date) {
        // 如果小于起始日期或大于结束日期，那么disabled
        if ([[date dateByAddingTimeInterval:86400.0 - 1] compare:calendarView.firstDate] == NSOrderedAscending ||
            [date compare:calendarView.lastDate] != NSOrderedAscending) { //不大于最后一天
            
            cellState = ZBJCalendarCellStateDisabled;
        } else {
            
            ZBJOfferDay *day = [self offerDateWithDate:date];
            price = day.price;
            
            BOOL isAvaible = day.available.boolValue;
            
            switch (self.selectedState) {
                case ZBJCalendarStateSelectedStart: {
                    
                    if ([[date dateByAddingTimeInterval:86400.0 - 1] compare:self.startDate] == NSOrderedAscending &&
                        [date compare:calendarView.firstDate] == NSOrderedDescending) {
                        
                        if (isAvaible) {
                            cellState = ZBJCalendarCellStateAvaibleDisabled;
                        } else {
                            cellState = ZBJCalendarCellStateUnavaible;
                        }
                    } else if ([self.startDate isEqualToDate:date]) {
                        cellState = ZBJCalendarCellStateSelectedStart;
                    } else if ([self.tempUnavaibleDates containsObject:date]) {
                        cellState = ZBJCalendarCellStateAvaibleDisabled;
                    } else if (self.nearestUnavaibleDate && [self.nearestUnavaibleDate isEqualToDate:date]) {
                        cellState = ZBJCalendarCellStateSelectedTempEnd;
                    } else if (self.nearestUnavaibleDate &&
                               [date compare:self.nearestUnavaibleDate] == NSOrderedDescending &&
                               [[date dateByAddingTimeInterval:86400.0 - 1] compare:calendarView.lastDate] == NSOrderedAscending
                               ) {
                        if (isAvaible) {
                            cellState = ZBJCalendarCellStateAvaibleDisabled;
                        } else {
                            cellState = ZBJCalendarCellStateUnavaible;
                        }
                    } else {
                        
                        if (isAvaible) {
                            cellState = ZBJCalendarCellStateAvaible;
                        } else {
                            cellState = ZBJCalendarCellStateUnavaible;
                        }
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
                        if (isAvaible) {
                            cellState = ZBJCalendarCellStateAvaible;
                        } else {
                            cellState = ZBJCalendarCellStateUnavaible;
                        }
                    }
                    break;
                }
                default: {
                    
                    if (isAvaible) {
                        cellState = ZBJCalendarCellStateAvaible;
                    } else {
                        cellState = ZBJCalendarCellStateUnavaible;
                    }
                    break;
                }
                    
                    
            }
        }
    } else {
        cellState = ZBJCalendarCellStateEmpty;
    }
    
    cell.price = price;
    cell.cellState = cellState;
    
}
- (void)calendarView:(ZBJCalendarView *)calendarView didSelectDate:(NSDate *)date {
    if (calendarView.selectionMode == ZBJSelectionModeRange) {
        if (date) {
            if (!self.startDate) {
                self.startDate = date;
                self.selectedState = ZBJCalendarStateSelectedStart;
            } else if (!self.endDate) {
                
                if ([self.startDate isEqualToDate:date]) {
                    self.selectedState = ZBJCalendarStateSelectedNone;
                    return;
                }
                
                self.endDate = date;
                self.selectedState = ZBJCalendarStateSelectedRange;
                
                // pop self
                [self performSelector:@selector(pop) withObject:nil afterDelay:0.4];
            } else {
                self.startDate = date;
                self.selectedState = ZBJCalendarStateSelectedStart;
            }
        }
    }
}



- (void)calendarView:(ZBJCalendarView *)calendarView configureSectionHeaderView:(ZBJCalendarSectionHeader *)headerView forYear:(NSInteger)year month:(NSInteger)month {
    headerView.year = year;
    headerView.month = month;
}

#pragma mark - getters
- (ZBJCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[ZBJCalendarView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
        _calendarView.delegate = self;
        [_calendarView registerCellClass:[ZBJCalendarComplexCell class] withReuseIdentifier:@"cell"];
        [_calendarView registerSectionHeader:[ZBJCalendarSectionHeader class] withReuseIdentifier:@"sectionHeader"];
        [_calendarView registerSectionFooter:[ZBJCalendarSectionFooter class] withReuseIdentifier:@"sectionFooter"];
        _calendarView.contentInsets = UIEdgeInsetsMake(0, 14, 0, 14);
        _calendarView.sectionHeaderHeight = 52;
        _calendarView.sectionFooterHeight = 13;
        _calendarView.minimumLineSpacing = 0.5;
        _calendarView.cellScale = 100.0 / 104.0;
    }
    return _calendarView;
}


#pragma mark - setters
- (void)setSelectedState:(ZBJCalendarSelectedState)selectedState {
    _selectedState = selectedState;
    switch (_selectedState) {
        case ZBJCalendarStateSelectedNone: {
            
            self.title = [NSString stringWithFormat:@"选择起始日期(至少%ld天)", self.minNights];
            
            [self reset];
            break;
        }
        case ZBJCalendarStateSelectedStart: {
        
            self.endDate = nil;
            [self.tempUnavaibleDates removeAllObjects];
            self.nearestUnavaibleDate = nil;
            
            [self.calendarView.collectionView reloadData];
            
            // calculate avaible `endDate` based `startDate`.
            // - the days in `minNights` from `startDate` has days unavaible.
            for (int i = 1; i < self.minNights; i++) {
                NSDate *theDate = [self.startDate dateByAddingTimeInterval:(i * 24 * 60 * 60)];
                // find the data about `theDate` and deal.
                ZBJOfferDay *day = [self offerDateWithDate:theDate];
                if (!day.available.boolValue) {
                    self.calendarView.collectionView.allowsSelection = NO;
                    [self performSelector:@selector(reset) withObject:nil afterDelay:0.8];
                    return;
                }
            }
            
            self.title = @"选择退房日期";
            
            // - set the day between and `startDate` and `minNights` unavaible.
            for (int i = 1; i < self.minNights; i++) {
                NSDate *theDate = [self.startDate dateByAddingTimeInterval:(i * 24 * 60 * 60)];
                [self.tempUnavaibleDates addObject:theDate];
            }
            
            
            // - 计算起始日期之后最近的不可选日期
            self.nearestUnavaibleDate = [self findTheNearestUnavaibleDateByStartDate:self.startDate];
            
            [self.calendarView.collectionView reloadData];
            
            break;
        }
        case ZBJCalendarStateSelectedRange: {
            [self.calendarView.collectionView reloadData];
            
            
            self.title = [NSString stringWithFormat:@"选择起始日期(至少%ld天)", self.minNights];

            break;
        }
        default:
            break;
    }
}
@end
