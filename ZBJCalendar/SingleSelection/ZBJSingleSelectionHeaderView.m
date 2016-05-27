//
//  ZBJSingleSelectionHeaderView.m
//  ZBJCalendar
//
//  Created by wanggang on 5/26/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJSingleSelectionHeaderView.h"
#import "ZBJCalendar.h"

@interface ZBJSingleSelectionHeaderView ()

@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, assign) NSInteger weekday;
@end
@implementation ZBJSingleSelectionHeaderView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.monthLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.monthLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.monthLabel.frame), 20);
    self.monthLabel.center = CGPointMake(25 * ((self.weekday - 1) * 2 + 1), CGRectGetHeight(self.frame) / 2);
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
