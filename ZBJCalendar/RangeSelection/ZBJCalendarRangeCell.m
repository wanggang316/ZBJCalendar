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

@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *stateLabel;
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
    
    if (self.cellStyle == ZBJRangeCellStyle2) {

        if (![self.stateLabel superview] || !self.stateLabel.text) {
            self.dateLabel.frame = CGRectMake(0, (CGRectGetHeight(self.bounds) - 15) / 2, CGRectGetWidth(self.bounds), 15);
        } else {
            self.dateLabel.frame = CGRectMake(0, CGRectGetHeight(self.bounds) / 2 - CGRectGetHeight(self.dateLabel.frame) - 2, CGRectGetWidth(self.bounds), 15);
            self.stateLabel.frame = CGRectMake(0, CGRectGetHeight(self.frame) / 2 + 5, CGRectGetWidth(self.contentView.frame), 9);
        }
        
    } else {
        if (![self.stateLabel superview] || !self.stateLabel.text) {
            self.dateLabel.frame = CGRectMake(0, (CGRectGetHeight(self.bounds) - 17) / 2, CGRectGetWidth(self.bounds), 17);
        } else {
            self.dateLabel.frame = CGRectMake(0, CGRectGetHeight(self.bounds) / 2 - CGRectGetHeight(self.dateLabel.frame) + 1, CGRectGetWidth(self.bounds), 17);
            self.stateLabel.frame = CGRectMake(0, CGRectGetHeight(self.frame) / 2 + 4, CGRectGetWidth(self.contentView.frame), 10);
        }
       
    }
    
   
}


#pragma mark - setters

- (void)setCellStyle:(ZBJRangeCellStyle)cellStyle {
    
    if (_cellStyle != cellStyle) {
        _cellStyle = cellStyle;

        switch (_cellStyle) {
            case ZBJRangeCellStyle2: {
                self.dateLabel.font = [UIFont systemFontOfSize:15];
                self.stateLabel.font = [UIFont systemFontOfSize:9];
                break;
            }
            default: {
                self.dateLabel.font = [UIFont systemFontOfSize:17];
                self.stateLabel.font = [UIFont systemFontOfSize:10];
                break;
            }
        }
    }
}

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
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 17)];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont systemFontOfSize:17];
        _dateLabel.textColor = [UIColor darkTextColor];
    }
    return _dateLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 10)];
        _stateLabel.font = [UIFont systemFontOfSize:10];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:163.0/255.0 alpha:1.0];
    }
    return _stateLabel;
}

@end
