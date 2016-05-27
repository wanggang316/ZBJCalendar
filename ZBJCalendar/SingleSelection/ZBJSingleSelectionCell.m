//
//  ZBJSingleSelectionCell.m
//  ZBJCalendar
//
//  Created by gumpwang on 5/26/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJSingleSelectionCell.h"
#import "NSDate+ZBJAddition.h"

@interface ZBJSingleSelectionCell()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, strong) CALayer *topLine;
@end
@implementation ZBJSingleSelectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.dateLabel];
        [self.contentView.layer addSublayer:self.topLine];
        self.calendar = [NSDate gregorianCalendar];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.topLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5);
    self.dateLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2 - 13);
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
        case ZBJCalendarCellStateEmpty: {
            self.dateLabel.text = nil;
            self.dateLabel.textColor = [UIColor whiteColor];
            self.dateLabel.backgroundColor = [UIColor whiteColor];
            self.dateLabel.layer.cornerRadius = 0;
            
            self.topLine.hidden = YES;
            break;
        }
        case ZBJCalendarCellStateNormal: {
            self.dateLabel.backgroundColor = [UIColor whiteColor];
            self.dateLabel.layer.cornerRadius = 0;
            
            if ([self.date isWeekend]) {
                self.dateLabel.textColor = [UIColor lightGrayColor];
            } else if ([self.date isToday]) {
                self.dateLabel.textColor = [UIColor  colorWithRed:255.0/255.0 green:60.0/255.0 blue:57.0/255.0 alpha:1.0];
            } else {
                self.dateLabel.textColor = [UIColor darkTextColor];
            }
            
            self.topLine.hidden = NO;
            break;
        }
        case ZBJCalendarCellStateSelected: {
            self.dateLabel.textColor = [UIColor whiteColor];
            self.dateLabel.layer.cornerRadius = 17;
            
            if ([self.date isToday]) {
                self.dateLabel.backgroundColor = [UIColor  colorWithRed:255.0/255.0 green:60.0/255.0 blue:57.0/255.0 alpha:1.0];
            } else {
                self.dateLabel.backgroundColor = [UIColor darkTextColor];
            }
            
            self.topLine.hidden = NO;
            break;
        }
        default:
            break;
    }
    
    [self layoutSubviews];
}

#pragma mark - getters
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont systemFontOfSize:17];
        _dateLabel.textColor = [UIColor darkTextColor];
        _dateLabel.clipsToBounds = YES;
    }
    return _dateLabel;
}

- (CALayer *)topLine {
    if (!_topLine) {
        _topLine = [CALayer layer];
        _topLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5);
        _topLine.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    }
    return _topLine;
}
@end
