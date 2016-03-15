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
#import "ZBJCalendarShowDelegate.h"
#import "ZBJCalendarShowCell.h"

@interface ZBJCalendarShowViewController()

@property (nonatomic, strong) ZBJCalendarView *calendarView;

@property (nonatomic, strong) ZBJOfferCalendar *offerCal;
@property (nonatomic, strong) ZBJCalendarShowDelegate *delegate;
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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"calendar_dates" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (!error) {
        self.offerCal = [[ZBJOfferCalendar alloc] initWithDictionary:dic];
    }
    
    
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
        _calendarView = [[ZBJCalendarView alloc] initWithFrame:self.view.bounds];
        _calendarView.backgroundColor = [UIColor lightGrayColor];
        [_calendarView registerCellClass:[ZBJCalendarShowCell class]];
        _calendarView.selectionMode = ZBJSelectionModeNone;
    }
    return _calendarView;
}

@end
