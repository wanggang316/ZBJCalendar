//
//  ZBJCalendarCell.m
//  ZBJCalendar
//
//  Created by wanggang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarComplexCell.h"
#import "NSDate+ZBJAddition.h"

@interface ZBJCalendarComplexCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation ZBJCalendarComplexCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.dateLabel];
        self.calendar = [NSDate gregorianCalendar];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (![self.priceLabel superview] || !self.priceLabel.text) {
        self.dateLabel.frame = CGRectMake(0, (CGRectGetHeight(self.bounds) - 15) / 2, CGRectGetWidth(self.bounds), 15);
    } else {
        self.dateLabel.frame = CGRectMake(0, CGRectGetHeight(self.bounds) / 2 - CGRectGetHeight(self.dateLabel.frame) - 1, CGRectGetWidth(self.bounds), 15);
        self.priceLabel.frame = CGRectMake(0, CGRectGetHeight(self.frame) / 2 + 5, CGRectGetWidth(self.contentView.frame), 9);
    }
    
    self.backgroundImageView.frame = self.bounds;
}

#pragma mark - setters
- (void)setDay:(NSDate *)day {
    _day = day;
    if (_day) {
        self.dateLabel.text = [NSString stringWithFormat:@"%ld", [self.calendar component:NSCalendarUnitDay fromDate:_day]];
    } else {
        self.dateLabel.text = nil;
    }
}

- (void)setPrice:(NSNumber *)price {
    _price = price;
    if (_price) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", _price];;
    } else {
        self.priceLabel.text = nil;
        [self.priceLabel removeFromSuperview];
    }
}


- (void)setIsToday:(BOOL)isToday {
    _isToday = isToday;
}

- (void)setCellState:(ZBJCalendarCellState)cellState {
    _cellState = cellState;
    switch (_cellState) {
        case ZBJCalendarCellStateDisabled: {
            // layout
            [self.priceLabel removeFromSuperview];
            self.backgroundView = nil;
            
            // style
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.dateLabel.textColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:200.0/255.0 alpha:1.0];
            break;
        }
        case ZBJCalendarCellStateUnavaible: {
            // layout
            if (![self.priceLabel superview]) {
                [self.contentView addSubview:self.priceLabel];
            }
            self.backgroundView = self.backgroundImageView;
            
            // style
            self.contentView.backgroundColor = [UIColor clearColor];
            self.dateLabel.textColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:200.0/255.0 alpha:1.0];
            self.priceLabel.textColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:200.0/255.0 alpha:1.0];
            
            self.priceLabel.text = @"已租";
            break;
        }
        case ZBJCalendarCellStateAvaible: {
            // layout
            if (![self.priceLabel superview]) {
                [self.contentView addSubview:self.priceLabel];
            }
            self.backgroundView = nil;
            
            // style
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.dateLabel.textColor = [UIColor colorWithRed:9.0/255.0 green:9.0/255.0 blue:26.0/255.0 alpha:1.0];
            self.priceLabel.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:163.0/255.0 alpha:1.0];
            break;
        }
        case ZBJCalendarCellStateAvaibleDisabled: {
            // layout
            if (![self.priceLabel superview]) {
                [self.contentView addSubview:self.priceLabel];
            }
            self.backgroundView = nil;
            
            // style
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.dateLabel.textColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:200.0/255.0 alpha:1.0];
            self.priceLabel.textColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:200.0/255.0 alpha:1.0];
            break;
        }
            

        case ZBJCalendarCellStateSelectedStart: {
            // layout
            if (![self.priceLabel superview]) {
                [self.contentView addSubview:self.priceLabel];
            }
            self.backgroundView = nil;
            
            // style
            self.contentView.backgroundColor =  [UIColor colorWithRed:9.0/255.0 green:9.0/255.0 blue:26.0/255.0 alpha:1.0];
            self.dateLabel.textColor = [UIColor whiteColor];
            self.priceLabel.textColor = [UIColor whiteColor];
            
            self.priceLabel.text = @"入住";
            break;
        }
        case ZBJCalendarCellStateSelectedMiddle: {
            // layout
            if (![self.priceLabel superview]) {
                [self.contentView addSubview:self.priceLabel];
            }
            self.backgroundView = nil;
            
            // style
            self.contentView.backgroundColor =  [UIColor colorWithRed:58.0/255.0 green:58.0/255.0 blue:72.0/255.0 alpha:1.0];
            self.dateLabel.textColor = [UIColor whiteColor];
            self.priceLabel.textColor = [UIColor whiteColor];
            break;
        }
        case ZBJCalendarCellStateSelectedEnd: {
            // layout
            if (![self.priceLabel superview]) {
                [self.contentView addSubview:self.priceLabel];
            }
            self.backgroundView = nil;
            
            // style
            self.contentView.backgroundColor =  [UIColor colorWithRed:9.0/255.0 green:9.0/255.0 blue:26.0/255.0 alpha:1.0];
            self.dateLabel.textColor = [UIColor whiteColor];
            self.priceLabel.textColor = [UIColor whiteColor];
            
            self.priceLabel.text = @"退房";
            break;
        }
        case ZBJCalendarCellStateSelectedTempEnd: {
            // layout
            if (![self.priceLabel superview]) {
                [self.contentView addSubview:self.priceLabel];
            }
            self.backgroundView = nil;
            
            // style
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.dateLabel.textColor = [UIColor colorWithRed:9.0/255.0 green:9.0/255.0 blue:26.0/255.0 alpha:1.0];
            self.priceLabel.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:163.0/255.0 alpha:1.0];
            
            self.priceLabel.text = @"仅退房";
            break;
        }
        case ZBJCalendarCellStateEmpty: {
            
            self.dateLabel.text = nil;
            self.priceLabel.text = nil;
            [self.priceLabel removeFromSuperview];
            self.backgroundView = nil;
            self.contentView.backgroundColor = [UIColor whiteColor];
            
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
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 15)];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont systemFontOfSize:15];
        _dateLabel.textColor = [UIColor darkTextColor];
    }
    return _dateLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 9)];
        _priceLabel.font = [UIFont systemFontOfSize:9];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:163.0/255.0 alpha:1.0];
    }
    return _priceLabel;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _backgroundImageView.image = [UIImage imageNamed:@"unavaible"];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImageView;
}
 


@end
