//
//  ZBJCalendarSectionHeader.m
//  ZBJCalendar
//
//  Created by gumpwang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarSectionHeader.h"

@interface ZBJCalendarSectionHeader()

@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation ZBJCalendarSectionHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.yearLabel];
        [self addSubview:self.monthLabel];
        [self addSubview:self.bottomLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.monthLabel.frame = CGRectMake(13, 25, CGRectGetWidth(self.monthLabel.frame), 20);
    self.yearLabel.frame = CGRectMake(CGRectGetMaxX(self.monthLabel.frame) + 3, CGRectGetMaxY(self.monthLabel.frame) - 2 - 9, 100, 9);
    self.bottomLine.frame = CGRectMake(CGRectGetMinX(self.monthLabel.frame), CGRectGetMaxY(self.monthLabel.frame) + 11, 30, 2);
}

#pragma mark - setters
- (void)setYear:(NSInteger)year {
    self.yearLabel.text = [NSString stringWithFormat:@"%ld", year];
}

- (void)setMonth:(NSInteger)month {
    self.monthLabel.text = [NSString stringWithFormat:@"%ld月", month];
    [self.monthLabel sizeToFit];
}


#pragma mark - getters
- (UILabel *)yearLabel {
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc] init];
        _yearLabel.font = [UIFont systemFontOfSize:10];
        _yearLabel.textColor = [UIColor darkTextColor];
        _yearLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _yearLabel;
}

- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.font = [UIFont systemFontOfSize:22];
        _monthLabel.textColor = [UIColor darkTextColor];
    }
    return _monthLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:233.0/255.0 alpha:1.0];
        _bottomLine.layer.cornerRadius = 1.0;
        _bottomLine.clipsToBounds = YES;
    }
   
    return _bottomLine;
}


@end
