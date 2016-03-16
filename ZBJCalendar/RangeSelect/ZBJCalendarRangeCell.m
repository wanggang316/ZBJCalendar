//
//  ZBJCalendarViewCell.m
//  ZBJCalendar
//
//  Created by wanggang on 3/15/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarRangeCell.h"
#import "NSDate+ZBJAddition.h"

@interface ZBJCalendarRangeCell()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation ZBJCalendarRangeCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.dateLabel];
        self.calendar = [NSDate gregorianCalendar];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (![self.stateLabel superview] || !self.stateLabel.text) {
        self.dateLabel.frame = CGRectMake(5, 5, CGRectGetWidth(self.bounds) - 10, CGRectGetWidth(self.bounds) - 10);
    } else {
        self.dateLabel.frame = CGRectMake(5, 10, CGRectGetWidth(self.bounds) - 10, 20);
        self.stateLabel.frame = CGRectMake(0, CGRectGetMaxY(self.dateLabel.frame), CGRectGetWidth(self.frame), 9);
    }
}


#pragma mark - setters
- (void)setDate:(NSDate *)date {
    _date = date;
    if (_date) {
        self.dateLabel.text = [NSString stringWithFormat:@"%ld", [self.calendar component:NSCalendarUnitDay fromDate:_date]];
    } else {
        self.dateLabel.text = nil;
    }
}

- (void)setCellState:(ZBJCalendarCellState)cellState {
    _cellState = cellState;
    switch (_cellState) {
        case ZBJCalendarCellStateDisabled: {
            
            if (self.stateLabel.superview) {
                [self.stateLabel removeFromSuperview];
            }
            self.contentView.backgroundColor = [UIColor clearColor];
            self.dateLabel.textColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:200.0/255.0 alpha:1.0];
            break;
        }
        case ZBJCalendarCellStateAvaible: {
            
            if (self.stateLabel.superview) {
                [self.stateLabel removeFromSuperview];
            }
            self.contentView.backgroundColor = [UIColor clearColor];
            self.dateLabel.textColor = [UIColor colorWithRed:9.0/255.0 green:9.0/255.0 blue:26.0/255.0 alpha:1.0];
            break;
        }
        case ZBJCalendarCellStateAvaibleDisabled: {
            if (self.stateLabel.superview) {
                [self.stateLabel removeFromSuperview];
            }
            self.contentView.backgroundColor = [UIColor clearColor];
            self.dateLabel.textColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:200.0/255.0 alpha:1.0];
            break;
        }
        case ZBJCalendarCellStateSelectedStart: {
            
            [self.contentView addSubview:self.stateLabel];
            
            self.contentView.backgroundColor =  [UIColor colorWithRed:9.0/255.0 green:9.0/255.0 blue:26.0/255.0 alpha:1.0];
            self.dateLabel.textColor = [UIColor whiteColor];
            self.stateLabel.textColor = [UIColor whiteColor];
            self.stateLabel.text = @"入住";
            break;
        }
        case ZBJCalendarCellStateSelectedMiddle: {
            if (self.stateLabel.superview) {
                [self.stateLabel removeFromSuperview];
            }
            self.contentView.backgroundColor =  [UIColor colorWithRed:58.0/255.0 green:58.0/255.0 blue:72.0/255.0 alpha:1.0];
            self.dateLabel.textColor = [UIColor whiteColor];
            self.stateLabel.textColor = [UIColor whiteColor];
            break;
        }
        case ZBJCalendarCellStateSelectedEnd: {
            
            [self.contentView addSubview:self.stateLabel];
            self.contentView.backgroundColor =  [UIColor colorWithRed:9.0/255.0 green:9.0/255.0 blue:26.0/255.0 alpha:1.0];
            self.dateLabel.textColor = [UIColor whiteColor];
            self.stateLabel.textColor = [UIColor whiteColor];
            
            self.stateLabel.text = @"退房";
            break;
        }
        case ZBJCalendarCellStateEmpty: {
          
            self.dateLabel.text = nil;
            self.stateLabel.text = nil;
            [self.stateLabel removeFromSuperview];
            
            self.contentView.backgroundColor = [UIColor clearColor];
            break;
        }
        default: {
            break;
        }
            
    }
    [self layoutSubviews];
}

#pragma mark - getters
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont systemFontOfSize:15];
        _dateLabel.textColor = [UIColor darkTextColor];
    }
    return _dateLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:9];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:163.0/255.0 alpha:1.0];
    }
    return _stateLabel;
}

@end
