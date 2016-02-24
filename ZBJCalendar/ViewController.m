//
//  ViewController.m
//  ZBJCalendar
//
//  Created by 王刚 on 15/12/8.
//  Copyright © 2015年 ZBJ. All rights reserved.
//

#import "ViewController.h"
#import "ZBJCalendarView.h"

@interface ViewController ()

@property (nonatomic, strong) ZBJCalendarView *calendarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.calendarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
- (ZBJCalendarView *)calendarView {
    if (!_calendarView) {
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        _calendarView = [[ZBJCalendarView alloc] initWithFrame:CGRectMake(0, 80, w, h - 100)];
        _calendarView.backgroundColor = [UIColor lightGrayColor];
    }
    return _calendarView;
}


@end
