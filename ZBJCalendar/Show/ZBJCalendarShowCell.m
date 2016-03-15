//
//  ZBJCalendarShowCell.m
//  ZBJCalendar
//
//  Created by wanggang on 3/15/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarShowCell.h"
#import "NSDate+ZBJAddition.h"

@interface ZBJCalendarShowCell()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation ZBJCalendarShowCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.priceLabel];
        self.calendar = [NSDate gregorianCalendar];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dateLabel.frame = CGRectMake(0, self.contentView.center.y - CGRectGetHeight(self.dateLabel.frame) - 1, CGRectGetWidth(self.bounds), 15);
    self.priceLabel.frame = CGRectMake(0, self.contentView.center.y + 5, CGRectGetWidth(self.frame), 9);
    self.backgroundImageView.frame = self.contentView.bounds;
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

- (void)setPrice:(NSNumber *)price {
    _price = price;
    if (_price) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", _price];
    } else {
        self.priceLabel.text = nil;
    }
}

- (void)setCellState:(ZBJCalendarCellState)cellState {
    _cellState = cellState;
    switch (_cellState) {
        case ZBJCalendarCellStateDisabled: {
            
            self.backgroundView = nil;
            self.dateLabel.textColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:200.0/255.0 alpha:1.0];
            break;
        }
        case ZBJCalendarCellStateAvaible: {
            
            self.backgroundView = nil;
            self.dateLabel.textColor = [UIColor colorWithRed:9.0/255.0 green:9.0/255.0 blue:26.0/255.0 alpha:1.0];
            break;
        }
        case ZBJCalendarCellStateUnavaible: {
            
            self.backgroundView = self.backgroundImageView;
            
            self.dateLabel.textColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:200.0/255.0 alpha:1.0];
            self.priceLabel.textColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:200.0/255.0 alpha:1.0];
            
            self.priceLabel.text = @"已租";
            break;
        }
        
        case ZBJCalendarCellStateEmpty: {
            self.dateLabel.text = nil;
            self.priceLabel.text = nil;
            self.backgroundView = nil;
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
        _backgroundImageView.image = [UIImage imageNamed:@"unav"];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImageView;
}


@end
