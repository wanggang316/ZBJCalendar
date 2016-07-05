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
    self.monthLabel.frame = CGRectMake(10, (CGRectGetHeight(self.frame) - 20) / 2, CGRectGetWidth(self.monthLabel.frame), 20);
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
    self.monthLabel.text = [NSString stringWithFormat:@"%ld月%ld", components.month, components.year];
    [self.monthLabel sizeToFit];
    [self layoutSubviews];
}


#pragma mark - getters
- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.font = [UIFont systemFontOfSize:18];
        _monthLabel.textColor = [UIColor grayColor];
    }
    return _monthLabel;
}

@end
