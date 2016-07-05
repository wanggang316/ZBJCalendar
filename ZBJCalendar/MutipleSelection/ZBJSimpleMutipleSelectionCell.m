//
//  ZBJMutipleSelectionCell.m
//  ZBJCalendar
//
//  Created by wanggang on 7/4/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJSimpleMutipleSelectionCell.h"
#import "NSDate+ZBJAddition.h"

@interface ZBJSimpleMutipleSelectionCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, strong) UIImageView *backView;

@end

@implementation ZBJSimpleMutipleSelectionCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.backView];
        [self.contentView addSubview:self.dateLabel];
        self.calendar = [NSDate gregorianCalendar];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min = MIN(CGRectGetHeight(self.frame), CGRectGetWidth(self.frame));
    self.dateLabel.frame = CGRectMake(0, 0, min, min);
    self.dateLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    self.backView.frame = self.bounds;
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
            self.backView.image = nil;
            self.dateLabel.text = nil;
            self.dateLabel.textColor = [UIColor whiteColor];
            break;
        }
        case ZBJCalendarCellStateDisabled: {
            self.backView.image = nil;
            self.dateLabel.textColor = [UIColor lightGrayColor];
            break;
        }
        case ZBJCalendarCellStateNormal: {
            self.backView.image = nil;
            if ([self.date isToday]) {
                self.dateLabel.textColor = [UIColor  colorWithRed:255.0/255.0 green:60.0/255.0 blue:57.0/255.0 alpha:1.0];
            } else {
                self.dateLabel.textColor = [UIColor darkTextColor];
            }
            break;
        }
        case ZBJCalendarCellStateSelected: {
            self.dateLabel.textColor = [UIColor whiteColor];
            self.backView.image = [UIImage imageNamed:@"cal_selected"];
            break;
        }
        case ZBJCalendarCellStateSelectedLeft: {
            
            self.dateLabel.textColor = [UIColor whiteColor];
            self.backView.image = [UIImage imageNamed:@"cal_selected_left"];
            
            break;
        }
        case ZBJCalendarCellStateSelectedRight: {
            self.dateLabel.textColor = [UIColor whiteColor];
            self.backView.image = [UIImage imageNamed:@"cal_selected_right"];
            break;
        }
        case ZBJCalendarCellStateSelectedMiddle: {
            self.dateLabel.textColor = [UIColor whiteColor];
            self.backView.image = [UIImage imageNamed:@"cal_selected_middle"];
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

- (UIImageView *)backView {
    if (!_backView) {
        _backView = [[UIImageView alloc] init];
        _backView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backView;
}

//- (CALayer *)topLine {
//    if (!_topLine) {
//        _topLine = [CALayer layer];
//        _topLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5);
//        _topLine.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
//    }
//    return _topLine;
//}

@end
