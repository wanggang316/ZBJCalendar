//
//  CalendarViewController.m
//  ZBJCalendar
//
//  Created by wanggang on 2/26/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarRangeViewController.h"
#import "ZBJCalendarView.h"
#import "ZBJCalenderRangeSelector.h"
#import "ZBJCalendarRangeCell.h"
#import "ZBJCalendarSectionHeader.h"

@interface ZBJCalendarRangeViewController ()

@property (nonatomic, strong) ZBJCalendarView *calendarView;

@property (nonatomic, strong) ZBJCalenderRangeSelector *rangeSelector;

@end

@implementation ZBJCalendarRangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    NSDateComponents *components = [NSDateComponents new];
    components.month = 2;
    components.day = 26;
    components.year = 2016;
    NSDate *fromDate = [calendar dateFromComponents:components];
    components.year = 2017;
    components.month = 12;
    components.day = 1;
    NSDate *toDate = [calendar dateFromComponents:components];
    
    self.rangeSelector = [[ZBJCalenderRangeSelector alloc] init];
    self.calendarView.delegate = self.rangeSelector;
    
    self.calendarView.firstDate = fromDate;
    self.calendarView.lastDate = toDate;

    
    [self.view addSubview:self.calendarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -
- (ZBJCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[ZBJCalendarView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
        _calendarView.backgroundColor = [UIColor lightGrayColor];
        [_calendarView registerCellClass:[ZBJCalendarRangeCell class] withReuseIdentifier:@"cell"];
        [_calendarView registerSectionHeader:[ZBJCalendarSectionHeader class] withReuseIdentifier:@"sectionHeader"];
    }
    return _calendarView;
}

@end
