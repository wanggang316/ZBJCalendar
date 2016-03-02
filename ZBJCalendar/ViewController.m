//
//  ViewController.m
//  ZBJCalendar
//
//  Created by 王刚 on 15/12/8.
//  Copyright © 2015年 ZBJ. All rights reserved.
//

#import "ViewController.h"
#import "CalendarViewController.h"

static NSString * const ZBJCellIdentifier = @"cell";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *tableData;

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
    CalendarViewController *calendarViewController = [CalendarViewController new];
    calendarViewController.selectedType = indexPath.row;
    
    if (indexPath.row == 2 || indexPath.row == 3) {
        calendarViewController.continuous = YES;
    } else {
        calendarViewController.continuous = NO;
    }
    calendarViewController.title = self.tableData[indexPath.row];
    [self.navigationController pushViewController:calendarViewController animated:YES];
}

#pragma mark - getter
- (NSArray *)tableData {
    if (!_tableData) {
        _tableData = @[@"SingalSelection", @"MultiSelection", @"Continuous&SingalSelection", @"Continuous&MultiSelection"];
    }
    return _tableData;
}

@end
