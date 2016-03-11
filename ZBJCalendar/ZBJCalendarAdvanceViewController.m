//
//  ZBJCalendarAdvanceViewController.m
//  ZBJCalendar
//
//  Created by wanggang on 3/10/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarAdvanceViewController.h"
#import "UINavigationBar+ZBJAddition.h"
#import "ZBJCalendarView.h"
#import "ZBJOfferCalendar.h"

@interface ZBJCalendarAdvanceViewController ()

@property (nonatomic, strong) ZBJCalendarView *calendarView;
@end

@implementation ZBJCalendarAdvanceViewController

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
    ZBJOfferCalendar *offerCal;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (!error) {
        offerCal = [[ZBJOfferCalendar alloc] initWithDictionary:dic];
    }
    
    NSLog(@"offerCal : \n %@", offerCal);
   
    self.calendarView.firstDate = offerCal.startDate;
    self.calendarView.lastDate = offerCal.endDate;
    self.calendarView.dates = offerCal.dates;
    self.calendarView.minNights = 2;
    
    [self.view addSubview:self.calendarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -

#pragma mark -
- (ZBJCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[ZBJCalendarView alloc] initWithFrame:self.view.bounds];
        _calendarView.backgroundColor = [UIColor lightGrayColor];
    }
    return _calendarView;
}
@end
