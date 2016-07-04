//
//  ZBJSimpleMutipleSelectionViewController.m
//  ZBJCalendar
//
//  Created by wanggang on 7/4/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJSimpleMutipleSelectionViewController.h"
#import "ZBJCalendar.h"
#import "ZBJSimpleMutipleSelectionCell.h"
#import "ZBJMutipleSelectionSectionHeaderView.h"
#import "UINavigationBar+ZBJAddition.h"

@interface ZBJSimpleMutipleSelectionViewController () <ZBJCalendarDataSource, ZBJCalendarDelegate>

@property (nonatomic, strong) ZBJCalendarView *calendarView;

@property (nonatomic, strong) NSMutableArray *selectedMonths;
@property (nonatomic, strong) NSMutableArray *selectedDates;

@end

@implementation ZBJSimpleMutipleSelectionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar hidenHairLine:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar hidenHairLine:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 获取当前日期
    NSDate *today = [NSDate today];
    
    //    NSDate *today = [NSDate date];
    // 获取6个月后的最后一天
    NSCalendar *calendar = [NSDate gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:today];
    
    NSDate *firstDate = [calendar dateFromComponents:components];
    
    components.month = components.month + 6 + 1;
    components.day = 0;
    NSDate *lastDate = [calendar dateFromComponents:components];
    
    self.calendarView.firstDate = firstDate;
    self.calendarView.lastDate = lastDate;
    
    [self.view addSubview:self.calendarView];
    
    self.selectedDates = [NSMutableArray new];
    self.selectedMonths = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)addDateFromMonth:(NSDate *)month {
    
    NSCalendar *calendar = [NSDate gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday fromDate:month];
    
    NSInteger count = [NSDate numberOfDaysInMonth:month];
    
    if ([self.selectedMonths containsObject:month]) {
        [self.selectedMonths removeObject:month];
        for (int i = 1; i <= count; i++) {
            components.day = i;
            NSDate *date = [calendar dateFromComponents:components];
            [self.selectedDates removeObject:date];
        }
    } else {
        [self.selectedMonths addObject:month];
        for (int i = 1; i <= count; i++) {
            components.day = i;
            NSDate *date = [calendar dateFromComponents:components];
            [self.selectedDates addObject:date];
        }
    }
}

#pragma mark - ZBJCalendarDataSource
- (void)calendarView:(ZBJCalendarView *)calendarView configureCell:(ZBJSimpleMutipleSelectionCell *)cell forDate:(NSDate *)date {
    
    cell.date = date;
    if (date) {
        if ([[date dateByAddingTimeInterval:86400.0 - 1] compare:calendarView.firstDate] == NSOrderedAscending ||
            [date compare:calendarView.lastDate] == NSOrderedDescending) { //大于最后一天
            cell.cellState = ZBJCalendarCellStateDisabled;
        } else if ([self.selectedDates containsObject:date]) {
            cell.cellState = ZBJCalendarCellStateSelected;
        } else {
            cell.cellState = ZBJCalendarCellStateNormal;
        }
    } else {
        cell.cellState = ZBJCalendarCellStateEmpty;
    }
}

- (void)calendarView:(ZBJCalendarView *)calendarView configureSectionHeaderView:(ZBJMutipleSelectionSectionHeaderView *)headerView firstDateOfMonth:(NSDate *)firstDateOfMonth {
    headerView.firstDateOfMonth = firstDateOfMonth;
    
    __weak ZBJSimpleMutipleSelectionViewController *me = self;
    headerView.tapHandler = ^(NSDate *month) {
        [me addDateFromMonth:month];
        [me.calendarView reloadItemsAtMonths:[NSMutableSet setWithObjects:month, nil]];
    };
}

- (void)calendarView:(ZBJCalendarView *)calendarView configureWeekDayLabel:(UILabel *)dayLabel atWeekDay:(NSInteger)weekDay {
    dayLabel.font = [UIFont systemFontOfSize:13];
    if (weekDay == 0 || weekDay == 6) {
        dayLabel.textColor = [UIColor lightGrayColor];
    }
}

#pragma mark - ZBJCalendarDelegate
- (BOOL)calendarView:(ZBJCalendarView *)calendarView shouldSelectDate:(NSDate *)date {
    if (date) {
        if ([[date dateByAddingTimeInterval:86400.0 - 1] compare:calendarView.firstDate] == NSOrderedAscending ||
            [date compare:calendarView.lastDate] == NSOrderedDescending) {
            return NO;
        }
    }
    return YES;
}

- (void)calendarView:(ZBJCalendarView *)calendarView didSelectDate:(NSDate *)date ofCell:(ZBJSimpleMutipleSelectionCell *)cell {
    
    if ([self.selectedDates containsObject:date]) {
        [self.selectedDates removeObject:date];
    } else {
        [self.selectedDates addObject:date];
    }
    
    [calendarView reloadItemsAtDates:[NSMutableSet setWithObjects:date, nil]];
    NSLog(@"selected dates is : %@", self.selectedDates);
}


#pragma mark -
- (ZBJCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[ZBJCalendarView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
        [_calendarView registerCellClass:[ZBJSimpleMutipleSelectionCell class] withReuseIdentifier:@"cell"];
        [_calendarView registerSectionHeader:[ZBJMutipleSelectionSectionHeaderView class] withReuseIdentifier:@"sectionHeader"];
        _calendarView.selectionMode = ZBJSelectionModeMutiple;
        _calendarView.dataSource = self;
        _calendarView.delegate = self;
        _calendarView.backgroundColor = [UIColor whiteColor];
        _calendarView.contentInsets = UIEdgeInsetsMake(0, 14, 0, 14);
        _calendarView.cellScale = 140.0 / 100.0;
        _calendarView.sectionHeaderHeight = 27;
        _calendarView.weekViewHeight = 20;
        _calendarView.weekView.backgroundColor = [UIColor colorWithRed:249.0f/255.0f green:249.0f/255.0f blue:249.0f/255.0f alpha:1.0];
    }
    return _calendarView;
}

@end
