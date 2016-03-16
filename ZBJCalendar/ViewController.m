//
//  ViewController.m
//  ZBJCalendar
//
//  Created by 王刚 on 15/12/8.
//  Copyright © 2015年 ZBJ. All rights reserved.
//

#import "ViewController.h"
#import "ZBJCalendarRangeViewController.h"
#import "ZBJCalendarShowViewController.h"
#import "ZBJCalendarAdvanceViewController.h"
#import "ZBJOfferCalendarView.h"
#import "ZBJOfferCalendar.h"
#import "ZBJRangeViewController.h"

static NSString * const ZBJCellIdentifier = @"cell";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, ZBJCalendarRangeSelectorDelegate, ZBJCalendarAdvanceSelectorDelegate>

@property (nonatomic, strong) NSArray *tableData;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) ZBJCalendarRangeViewController *rangeController;
@property (nonatomic, strong) ZBJCalendarAdvanceViewController *advanceCalController;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZBJCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.tableData[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"calendar_dates" ofType:@"json"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            
            NSError *error;
            ZBJOfferCalendar *offerCal;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (!error) {
                offerCal = [[ZBJOfferCalendar alloc] initWithDictionary:dic];
            }
            
            
            ZBJOfferCalendarView *calendarView = [[ZBJOfferCalendarView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame offerCal:offerCal];
            calendarView.alpha = 0.0;
            
            [[UIApplication sharedApplication].keyWindow addSubview:calendarView];
            [UIView animateWithDuration:0.3f animations:^{
                calendarView.alpha = 1.0;
            } completion:^(BOOL finished) {
                
            }];
            break;
        }
        case 1: {
            self.rangeController.startDate = self.startDate;
            self.rangeController.endDate = self.endDate;
            [self.navigationController pushViewController:self.rangeController animated:YES];
            break;
        }
            
        case 2: {
            ZBJRangeViewController *calendarViewController = [ZBJRangeViewController new];
            calendarViewController.title = self.tableData[indexPath.row];
            [self.navigationController pushViewController:calendarViewController animated:YES];
            break;
        }
        case 3: {
            
            self.advanceCalController.startDate = self.startDate;
            self.advanceCalController.endDate = self.endDate;
            [self.navigationController pushViewController:self.advanceCalController animated:YES];
            break;
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
        _tableData = @[@"ShowOnly", @"RangeSelection", @"RangeSelection1", @"Advance"];
    }
    return _tableData;
}

- (ZBJCalendarRangeViewController *)rangeController {
    if (!_rangeController) {
        _rangeController = [ZBJCalendarRangeViewController new];
        _rangeController.delegate = self;
    }
    return _rangeController;
}

- (ZBJCalendarAdvanceViewController *)advanceCalController {
    if (!_advanceCalController) {
        _advanceCalController = [ZBJCalendarAdvanceViewController new];
        _advanceCalController.delegate = self;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"calendar_dates" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        NSError *error;
        ZBJOfferCalendar *offerCal;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            offerCal = [[ZBJOfferCalendar alloc] initWithDictionary:dic];
        }
        
        _advanceCalController.firstDate = offerCal.startDate;
        _advanceCalController.lastDate = offerCal.endDate;
        _advanceCalController.dates = offerCal.dates;
        _advanceCalController.minNights = 2;
    }
    return _advanceCalController;
}

@end
