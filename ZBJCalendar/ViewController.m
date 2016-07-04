//
//  ViewController.m
//  ZBJCalendar
//
//  Created by gumpwang on 15/12/8.
//  Copyright © 2015年 ZBJ. All rights reserved.
//

#import "ViewController.h"
#import "ZBJCalendarShowView.h"
#import "ZBJSimpleRangeSelectionController.h"
#import "ZBJComplexRangeSelectionController.h"
#import "ZBJCalendarDates.h"
#import "ZBJSingleSelectionController.h"
#import "ZBJSimpleMutipleSelectionViewController.h"

static NSString * const ZBJCellIdentifier = @"cell";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, ZBJCalendarRangeSelectorDelegate, ZBJCalendarAdvanceSelectorDelegate>

@property (nonatomic, strong) NSArray *tableData;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) ZBJSimpleRangeSelectionController *rangeController;
@property (nonatomic, strong) ZBJComplexRangeSelectionController *advanceCalController;

@property (nonatomic, strong) ZBJSimpleMutipleSelectionViewController *mutipleSelectionController;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData[section][@"cells"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.tableData[section][@"sectionTitle"];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZBJCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *cellData = self.tableData[indexPath.section][@"cells"][indexPath.row];
    cell.textLabel.text = cellData[@"cellTitle"];
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"calendar_dates" ofType:@"json"];
                    NSData *data = [NSData dataWithContentsOfFile:path];
                    
                    NSError *error;
                    ZBJCalendarDates *calendarDates;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                    if (!error) {
                        calendarDates = [[ZBJCalendarDates alloc] initWithDictionary:dic];
                    }
                    
                    ZBJCalendarShowView *controller = [[ZBJCalendarShowView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame calendarDates:calendarDates];
                    controller.alpha = 0.0;
                    
                    [[UIApplication sharedApplication].keyWindow addSubview:controller];
                    [UIView animateWithDuration:0.2f animations:^{
                        controller.alpha = 1.0;
                    } completion:^(BOOL finished) {
                        
                    }];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    ZBJSingleSelectionController *controller = [[ZBJSingleSelectionController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2: {
            
            switch (indexPath.row) {
                case 0: {
                    self.rangeController.startDate = self.startDate;
                    self.rangeController.endDate = self.endDate;
                    [self.navigationController pushViewController:self.rangeController animated:YES];
                    break;
                }
                case 1: {
                    self.advanceCalController.startDate = self.startDate;
                    self.advanceCalController.endDate = self.endDate;
                    [self.navigationController pushViewController:self.advanceCalController animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 3: {
            
            switch (indexPath.row) {
                case 0:
                    [self.navigationController pushViewController:self.mutipleSelectionController animated:YES];
                    break;
                    
                default:
                    break;
            }
        }
        default:
            break;
    }
}

#pragma mark - range && advance delegate
- (void)popViewController:(UIViewController *)viewController startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    [viewController.navigationController popViewControllerAnimated:YES];
    
    NSLog(@"----> startDate : %@, endDate: %@", startDate, endDate);
    
    self.startDate = startDate;
    self.endDate = endDate;
}

#pragma mark - getter
- (NSArray *)tableData {
    if (!_tableData) {
        _tableData = @[@{@"sectionTitle": @"Show",
                        @"cells": @[@{@"cellTitle": @"view"}]},
                       @{@"sectionTitle": @"Single Selection",
                         @"cells": @[@{@"cellTitle": @"general"}]},
                       @{@"sectionTitle": @"Range Selection",
                         @"cells": @[@{@"cellTitle": @"simple"}, @{@"cellTitle": @"complex"}]},
                       @{@"sectionTitle": @"Mutiple Selection",
                         @"cells": @[@{@"cellTitle": @"simple"}]}
                      ];
    }
    return _tableData;
}

- (ZBJSimpleRangeSelectionController *)rangeController {
    if (!_rangeController) {
        _rangeController = [ZBJSimpleRangeSelectionController new];
        _rangeController.delegate = self;
    }
    return _rangeController;
}

- (ZBJComplexRangeSelectionController *)advanceCalController {
    if (!_advanceCalController) {
        _advanceCalController = [ZBJComplexRangeSelectionController new];
        _advanceCalController.delegate = self;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"calendar_dates" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        NSError *error;
        ZBJCalendarDates *calendarDates;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            calendarDates = [[ZBJCalendarDates alloc] initWithDictionary:dic];
        }
        
        _advanceCalController.firstDate = calendarDates.startDate;
        _advanceCalController.lastDate = calendarDates.endDate;
        _advanceCalController.dates = calendarDates.dates;
        _advanceCalController.minNights = 2;
    }
    return _advanceCalController;
}

- (ZBJSimpleMutipleSelectionViewController *)mutipleSelectionController {
    if (!_mutipleSelectionController) {
        _mutipleSelectionController = [[ZBJSimpleMutipleSelectionViewController alloc] init];
    }
    return _mutipleSelectionController;
}

@end
