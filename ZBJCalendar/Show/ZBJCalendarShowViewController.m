//
//  ZBJCalendarShowViewController.m
//  ZBJCalendar
//
//  Created by wanggang on 3/10/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarShowViewController.h"
#import "ZBJCalendarShowDelegate.h"
#import "ZBJCalendarShowCell.h"
#import "ZBJCalendarSectionHeader.h"

@interface ZBJCalendarShowViewController()

@property (nonatomic, strong) ZBJCalendarView *calendarView;
@property (nonatomic, strong) ZBJCalendarShowDelegate *delegate;

@end

@implementation ZBJCalendarShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.calendarView.firstDate = self.offerCal.startDate;
    self.calendarView.lastDate = self.offerCal.endDate;

    self.delegate = [[ZBJCalendarShowDelegate alloc] init];
    self.delegate.offerCal = self.offerCal;
    self.calendarView.delegate = self.delegate;

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
        [_calendarView registerCellClass:[ZBJCalendarShowCell class] withReuseIdentifier:@"cell"];
        [_calendarView registerSectionHeader:[ZBJCalendarSectionHeader class] withReuseIdentifier:@"header"];
        _calendarView.selectionMode = ZBJSelectionModeNone;
    }
    return _calendarView;
}

@end
