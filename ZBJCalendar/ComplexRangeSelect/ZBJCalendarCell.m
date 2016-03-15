//
//  ZBJCalendarCell.m
//  ZBJCalendar
//
//  Created by wanggang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarCell.h"
#import "NSDate+ZBJAddition.h"

@interface ZBJCalendarCell ()

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation ZBJCalendarCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.dayLabel];
        self.calendar = [NSDate gregorianCalendar];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (![self.priceLabel superview] || !self.priceLabel.text) {
        self.dayLabel.frame = CGRectMake(5, 5, CGRectGetWidth(self.bounds) - 10, CGRectGetWidth(self.bounds) - 10);
    } else {
        self.dayLabel.frame = CGRectMake(5, 10, CGRectGetWidth(self.bounds) - 10, 20);
        self.priceLabel.frame = CGRectMake(0, CGRectGetMaxY(self.dayLabel.frame), CGRectGetWidth(self.frame), 9);
    }
    
    self.backgroundImageView.frame = self.bounds;
}

#pragma mark - setters
- (void)setDay:(NSDate *)day {
    _day = day;
    if (_day) {
        self.dayLabel.text = [NSString stringWithFormat:@"%ld", [self.calendar component:NSCalendarUnitDay fromDate:_day]];
    } else {
        self.dayLabel.text = nil;
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
            self.dayLabel.textColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:200.0/255.0 alpha:1.0];
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
            self.dayLabel.textColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:200.0/255.0 alpha:1.0];
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
            self.dayLabel.textColor = [UIColor colorWithRed:9.0/255.0 green:9.0/255.0 blue:26.0/255.0 alpha:1.0];
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
            self.dayLabel.textColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:200.0/255.0 alpha:1.0];
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
            self.dayLabel.textColor = [UIColor whiteColor];
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
            self.dayLabel.textColor = [UIColor whiteColor];
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
            self.dayLabel.textColor = [UIColor whiteColor];
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
            self.dayLabel.textColor = [UIColor colorWithRed:9.0/255.0 green:9.0/255.0 blue:26.0/255.0 alpha:1.0];
            self.priceLabel.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:163.0/255.0 alpha:1.0];
            
            self.priceLabel.text = @"仅退房";
            break;
        }
        case ZBJCalendarCellStateEmpty: {
            
            self.dayLabel.text = nil;
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
- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont systemFontOfSize:15];
        _dayLabel.textColor = [UIColor darkTextColor];
    }
    return _dayLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
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
