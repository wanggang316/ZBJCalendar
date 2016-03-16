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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.title = @"选择入住日期";
    
    NSDate *firstDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:firstDate];
    components.month = components.month + 6; //
    NSDate *lastDate = [calendar dateFromComponents:components];
    
    self.rangeSelector = [[ZBJCalenderRangeSelector alloc] init];
    
    // initial `startDate` and `endDate`
    if (self.startDate && self.endDate) {
        self.rangeSelector.selectedState = ZBJCalendarStateSelectedRange;
        self.rangeSelector.startDate = self.startDate;
        self.rangeSelector.endDate = self.endDate;
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
    
    
    self.calendarView.delegate = self.rangeSelector;
    self.calendarView.firstDate = firstDate;
    self.calendarView.lastDate = lastDate;

    [self.view addSubview:self.calendarView];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self.rangeSelector removeObserver:self forKeyPath:@"startDate"];
    [self.rangeSelector removeObserver:self forKeyPath:@"endDate"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"startDate"]) {
        self.startDate = [change objectForKey:NSKeyValueChangeNewKey];
    } else if ([keyPath isEqualToString:@"endDate"]) {
        self.endDate =  [change objectForKey:NSKeyValueChangeNewKey];
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
