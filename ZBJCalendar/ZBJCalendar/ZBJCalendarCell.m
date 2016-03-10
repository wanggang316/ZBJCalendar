//
//  ZBJCalendarCell.m
//  ZBJCalendar
//
//  Created by wanggang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarCell.h"
#import "NSDate+ZBJAddition.h"

@interface ZBJCalendarCell ()

@property (nonatomic, strong) UILabel *dayLabel;

@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation ZBJCalendarCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.dayLabel];
        self.calendar = [NSDate gregorianCalendar];
    }
    return self;
}


#pragma mark - setters
- (void)setDay:(NSDate *)day {
    _day = day;
    if (_day) {
//        self.isToday = _day.isToday;
        _dayLabel.text = [NSString stringWithFormat:@"%ld", [self.calendar component:NSCalendarUnitDay fromDate:_day]];
        
    } else {
        _dayLabel.text = nil;
    }
}


- (void)setIsToday:(BOOL)isToday {
    _isToday = isToday;
//    if (_isToday) {
//        self.dayLabel.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:59.0f/255.f blue:48.0f/255.0f alpha:1.0];
//        self.dayLabel.textColor = [UIColor whiteColor];
//        self.dayLabel.layer.cornerRadius = CGRectGetWidth(self.dayLabel.frame) / 2;
//        self.dayLabel.clipsToBounds = YES;
//    } else {
//        self.dayLabel.backgroundColor = [UIColor whiteColor];
//        self.dayLabel.textColor = [UIColor darkTextColor];
//        self.dayLabel.clipsToBounds = NO;
//    }
}

- (void)setIsStartDate:(BOOL)isStartDate {
    _isStartDate = isStartDate;
    self.selected = _isStartDate;
}

- (void)setIsEndDate:(BOOL)isEndDate {
    _isEndDate = isEndDate;
    self.selected = _isEndDate;
}

- (void)setIsSelectedDate:(BOOL)isSelectedDate {
    _isSelectedDate = isSelectedDate;
    if (_isSelectedDate) {
        self.contentView.backgroundColor = [UIColor colorWithRed:58.0/255.0 green:58.0/255.0 blue:72.0/255.0 alpha:1.0];
        self.dayLabel.textColor = [UIColor whiteColor];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.dayLabel.textColor = [UIColor darkTextColor];
    }
}

- (void)setIsDisabledDate:(BOOL)isDisabledDate {
    _isDisabledDate = isDisabledDate;
    if (_isDisabledDate) {
        self.dayLabel.textColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:233.0/255.0 alpha:1.0];
    } else {
        self.dayLabel.textColor = [UIColor darkTextColor];
    }
}


- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.contentView.backgroundColor = [UIColor colorWithRed:9.0/255.0 green:9.0/255.0 blue:26.0/255.0 alpha:1.0];
        self.dayLabel.textColor = [UIColor whiteColor];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.dayLabel.textColor = [UIColor darkTextColor];
    }
}

#pragma mark - getters
- (UILabel *)dayLabel {
    if (!_dayLabel) {
        CGRect r = CGRectMake(5, 5, CGRectGetWidth(self.bounds) - 10, CGRectGetHeight(self.bounds) - 10);
        _dayLabel = [[UILabel alloc] initWithFrame: r];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.textColor = [UIColor darkTextColor];
    }
    return _dayLabel;
}


@end
