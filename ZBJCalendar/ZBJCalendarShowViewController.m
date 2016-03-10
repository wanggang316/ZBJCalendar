//
//  ZBJCalendarShowViewController.m
//  ZBJCalendar
//
//  Created by wanggang on 3/10/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarShowViewController.h"
#import "UINavigationBar+ZBJAddition.h"
#import "ZBJCalendarView.h"

@interface ZBJCalendarShowViewController()

@property (nonatomic, strong) ZBJCalendarView *calendarView;

@end

@implementation ZBJCalendarShowViewController

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
    
    self.calendarView.firstDate = fromDate;
    self.calendarView.lastDate = toDate;
    self.calendarView.selectionMode = ZBJSelectionModeNone;
    
    [self.view addSubview:self.calendarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -
- (ZBJCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[ZBJCalendarView alloc] initWithFrame:self.view.bounds];
        _calendarView.backgroundColor = [UIColor lightGrayColor];
    }
    return _calendarView;
}

@end
