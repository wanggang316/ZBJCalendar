//
//  ZBJSingleSelectionController.m
//  ZBJCalendar
//
//  Created by gumpwang on 5/26/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJSingleSelectionController.h"
#import "ZBJCalendar.h"
#import "ZBJSingleSelectionCell.h"
#import "ZBJSingleSelectionHeaderView.h"
#import "UINavigationBar+ZBJAddition.h"

@interface ZBJSingleSelectionController () <ZBJCalendarDataSource, ZBJCalendarDelegate>

@property (nonatomic, strong) ZBJCalendarView *calendarView;
@property (nonatomic, strong) NSDate *selectedDate;

@end
@implementation ZBJSingleSelectionController

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
    
    self.selectedDate = firstDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - ZBJCalendarDataSource
- (void)calendarView:(ZBJCalendarView *)calendarView configureCell:(ZBJSingleSelectionCell *)cell forDate:(NSDate *)date {
    
    cell.date = date;
    if (date) {
        if ([date isEqualToDate:self.selectedDate]) {
            cell.cellState = ZBJCalendarCellStateSelected;
        } else {
            cell.cellState = ZBJCalendarCellStateNormal;
        }
    } else {
        cell.cellState = ZBJCalendarCellStateEmpty;
    }
}

- (void)calendarView:(ZBJCalendarView *)calendarView configureSectionHeaderView:(ZBJSingleSelectionHeaderView *)headerView firstDateOfMonth:(NSDate *)firstDateOfMonth {
    headerView.firstDateOfMonth = firstDateOfMonth;
}

- (void)calendarView:(ZBJCalendarView *)calendarView configureWeekDayLabel:(UILabel *)dayLabel atWeekDay:(NSInteger)weekDay {
    dayLabel.font = [UIFont systemFontOfSize:13];
    if (weekDay == 0 || weekDay == 6) {
        dayLabel.textColor = [UIColor lightGrayColor];
    }
}

#pragma mark - ZBJCalendarDelegate
- (void)calendarView:(ZBJCalendarView *)calendarView didSelectDate:(NSDate *)date ofCell:(ZBJSingleSelectionCell *)cell {
    
    NSDate *oldDate = [self.selectedDate copy];
    self.selectedDate = date;

    [calendarView reloadItemsAtDates:[NSMutableSet setWithObjects:oldDate, self.selectedDate, nil]];
//    if (date) {
        NSLog(@"selected date is : %@", self.selectedDate);
//        cell.cellState = ZBJCalendarCellStateSelected;
//    }
  
}


#pragma mark -
- (ZBJCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[ZBJCalendarView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
        [_calendarView registerCellClass:[ZBJSingleSelectionCell class] withReuseIdentifier:@"singleCell"];
        [_calendarView registerSectionHeader:[ZBJSingleSelectionHeaderView class] withReuseIdentifier:@"singleSectionHeader"];
        _calendarView.selectionMode = ZBJSelectionModeSingle;
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
