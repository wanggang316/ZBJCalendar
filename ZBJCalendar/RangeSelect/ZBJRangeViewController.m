//
//  ZBJRangeViewController.m
//  ZBJCalendar
//
//  Created by wanggang on 3/16/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJRangeViewController.h"
#import "ZBJCalendarView.h"
#import "ZBJCalenderRangeSelector.h"
#import "ZBJCalendarRangeCell.h"
#import "ZBJCalendarSectionHeader.h"
#import "ZBJCalendarSectionFooter.h"

@interface ZBJRangeViewController ()

@property (nonatomic, strong) ZBJCalendarView *calendarView;

@property (nonatomic, strong) ZBJCalenderRangeSelector *rangeSelector;

@end

@implementation ZBJRangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIBarButtonItem *showItem = [[UIBarButtonItem alloc] initWithTitle:@"show" style:UIBarButtonItemStylePlain target:self action:@selector(show)];
    UIBarButtonItem *hidenItem = [[UIBarButtonItem alloc] initWithTitle:@"hiden" style:UIBarButtonItemStylePlain target:self action:@selector(hiden)];
    
    [self.navigationItem setRightBarButtonItems:@[hidenItem, showItem]];
    
    
    self.title = @"筛选";
    
   
    
    
    
}

- (void)show {
    if ([self.calendarView superview]) {
        return;
    }
    self.calendarView.alpha = 0.0;
    [self.view addSubview:self.calendarView];
    [UIView animateWithDuration:0.4 animations:^{
        self.calendarView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
}

- (void)hiden {
    if (![self.calendarView superview]) {
        return;
    }
    [UIView animateWithDuration:0.4 animations:^{
        self.calendarView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.calendarView removeFromSuperview];
    }];
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

    if (![self.startDate isEqual:[NSNull null]] && self.startDate &&
               ![self.endDate isEqual:[NSNull null]] && self.endDate) {
        // 0.4s return
        [self performSelector:@selector(pop) withObject:nil afterDelay:0.4];
    }
}

- (void)pop {
    NSLog(@"----> startDate : %@, endDate: %@", self.startDate, self.endDate);
    [self hiden];
}


#pragma mark -
- (ZBJCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[ZBJCalendarView alloc] initWithFrame:CGRectMake(12, 120, CGRectGetWidth(self.view.frame) - 24, 300)];
        _calendarView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:249.0/255.0 alpha:1.0];
        [_calendarView registerCellClass:[ZBJCalendarRangeCell class] withReuseIdentifier:@"cell"];
        [_calendarView registerSectionHeader:[ZBJCalendarSectionHeader class] withReuseIdentifier:@"sectionHeader"];
        _calendarView.contentInsets = UIEdgeInsetsMake(0, 19, 0, 19);
        _calendarView.sectionHeaderHeight = 52;
        
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
        
        _calendarView.delegate = self.rangeSelector;
        _calendarView.firstDate = firstDate;
        _calendarView.lastDate = lastDate;
    }
    return _calendarView;
}

@end
