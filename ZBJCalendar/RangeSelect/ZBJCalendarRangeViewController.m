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
#import "ZBJCalendarSectionFooter.h"

@interface ZBJCalendarRangeViewController ()

@property (nonatomic, strong) ZBJCalendarView *calendarView;

@property (nonatomic, strong) ZBJCalenderRangeSelector *rangeSelector;



@end

@implementation ZBJCalendarRangeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // initial `startDate` and `endDate`
    if (self.startDate && self.endDate) {

        self.rangeSelector.startDate = self.startDate;
        self.rangeSelector.endDate = self.endDate;
        [self.rangeSelector setSelectedState:ZBJCalendarStateSelectedRange calendarView:self.calendarView];
        self.title = @"选择入住日期";
    }
    
    // add observer
    [self.rangeSelector addObserver:self
                         forKeyPath:@"startDate"
                            options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                            context:@""];
    [self.rangeSelector addObserver:self
                         forKeyPath:@"endDate"
                            options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                            context:@""];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.rangeSelector removeObserver:self forKeyPath:@"startDate"];
    [self.rangeSelector removeObserver:self forKeyPath:@"endDate"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
   

    
    NSDate *firstDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:firstDate];
    components.month = components.month + 6; //
    NSDate *lastDate = [calendar dateFromComponents:components];
    
    self.rangeSelector = [[ZBJCalenderRangeSelector alloc] init];
    
    self.calendarView.delegate = self.rangeSelector;
    self.calendarView.firstDate = firstDate;
    self.calendarView.lastDate = lastDate;

    [self.view addSubview:self.calendarView];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"startDate"]) {
        if ([change objectForKey:NSKeyValueChangeNewKey] != [change objectForKey:NSKeyValueChangeOldKey]) {
            self.startDate = [change objectForKey:NSKeyValueChangeNewKey];
        }
    } else if ([keyPath isEqualToString:@"endDate"]) {
        if ([change objectForKey:NSKeyValueChangeNewKey] != [change objectForKey:NSKeyValueChangeOldKey]) {
            self.endDate = [change objectForKey:NSKeyValueChangeNewKey];
        }
    }
    
    // handle observer values
    if (([self.startDate isEqual:[NSNull null]] || !self.startDate) &&
        ([self.endDate isEqual:[NSNull null]] || !self.endDate)) {
        self.title = @"选择入住日期";
    } else if (![self.startDate isEqual:[NSNull null]] && self.startDate &&
               ([self.endDate isEqual:[NSNull null]] || !self.endDate)) {
        self.title = @"选择退房日期";
    } else if (![self.startDate isEqual:[NSNull null]] && self.startDate &&
               ![self.endDate isEqual:[NSNull null]] && self.endDate) {
        // 0.4s return
        [self performSelector:@selector(pop) withObject:nil afterDelay:0.4];
        self.title = @"选择入住日期";
    }
   
}

- (void)pop {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popViewController:startDate:endDate:)]) {
        [self.delegate popViewController:self startDate:self.startDate endDate:self.endDate];
    }
}


#pragma mark -
- (ZBJCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[ZBJCalendarView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
        [_calendarView registerCellClass:[ZBJCalendarRangeCell class] withReuseIdentifier:@"cell"];
        [_calendarView registerSectionHeader:[ZBJCalendarSectionHeader class] withReuseIdentifier:@"sectionHeader"];
        [_calendarView registerSectionFooter:[ZBJCalendarSectionFooter class] withReuseIdentifier:@"sectionFooter"];
        _calendarView.contentInsets = UIEdgeInsetsMake(0, 14, 0, 14);
        _calendarView.sectionHeaderHeight = 52;
        _calendarView.sectionFooterHeight = 13;
        
    }
    return _calendarView;
}

@end
