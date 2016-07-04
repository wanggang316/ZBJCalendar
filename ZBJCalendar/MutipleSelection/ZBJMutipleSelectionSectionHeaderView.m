//
//  ZBJMutipleSelectionSectionHeaderView.m
//  ZBJCalendar
//
//  Created by wanggang on 7/4/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJMutipleSelectionSectionHeaderView.h"
#import "ZBJCalendar.h"

@interface ZBJMutipleSelectionSectionHeaderView ()

@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, assign) NSInteger weekday;

@end

@implementation ZBJMutipleSelectionSectionHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.monthLabel];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMonthView:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.monthLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.monthLabel.frame), 20);
    self.monthLabel.center = CGPointMake(25 * ((self.weekday - 1) * 2 + 1), CGRectGetHeight(self.frame) / 2);
}

#pragma mark - events
- (void)tapMonthView:(id)sender {
    if (self.tapHandler) {
        self.tapHandler(self.firstDateOfMonth);
    }
}

#pragma mark - setters
- (void)setFirstDateOfMonth:(NSDate *)firstDateOfMonth {
    _firstDateOfMonth = firstDateOfMonth;
    NSCalendar *calendar = [NSDate gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday fromDate:firstDateOfMonth];
    self.weekday = components.weekday;
    self.monthLabel.text = [NSString stringWithFormat:@"%ld月", components.month];
    [self.monthLabel sizeToFit];
    [self layoutSubviews];
}


#pragma mark - getters
- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.font = [UIFont systemFontOfSize:17];
        _monthLabel.textColor = [UIColor darkTextColor];
    }
    return _monthLabel;
}
@end
