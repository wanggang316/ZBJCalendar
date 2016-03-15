//
//  ZBJCalendarSectionHeader.m
//  ZBJCalendar
//
//  Created by wanggang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarSectionHeader.h"

@interface ZBJCalendarSectionHeader()

@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UILabel *monthLabel;

@end

@implementation ZBJCalendarSectionHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.yearLabel];
        [self addSubview:self.monthLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.monthLabel sizeToFit];
    self.monthLabel.frame = CGRectMake(28, 20, CGRectGetWidth(self.monthLabel.frame), 20);
    self.yearLabel.frame = CGRectMake(CGRectGetMaxX(self.monthLabel.frame) + 5, CGRectGetMaxY(self.monthLabel.frame) - 2 - 9, 100, 9);
}

#pragma mark - setters
- (void)setYear:(NSInteger)year {
    self.yearLabel.text = [NSString stringWithFormat:@"%ld", year];
}

- (void)setMonth:(NSInteger)month {
    self.monthLabel.text = [NSString stringWithFormat:@"%ld月", month];
}


#pragma mark - getters
- (UILabel *)yearLabel {
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc] init];
        _yearLabel.font = [UIFont systemFontOfSize:9];
        _yearLabel.textColor = [UIColor darkTextColor];
        _yearLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _yearLabel;
}

- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.font = [UIFont systemFontOfSize:20];
        _monthLabel.textColor = [UIColor darkTextColor];
    }
    return _monthLabel;
}


@end
