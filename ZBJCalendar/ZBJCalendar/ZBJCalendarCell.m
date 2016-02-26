//
//  ZBJCalendarCell.m
//  ZBJCalendar
//
//  Created by wanggang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarCell.h"

@interface ZBJCalendarCell ()

@property (nonatomic, strong) UILabel *dayLabel;

@end

@implementation ZBJCalendarCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.dayLabel];
    }
    return self;
}

- (void)setDay:(NSInteger)day {
    _day = day;
    if (_day) {
        _dayLabel.text = [NSString stringWithFormat:@"%ld", day];
        self.backgroundColor = [UIColor colorWithRed:249.0f/255.0f green:249.0f/255.0f blue:249.0f/255.0f alpha:1.0];
    } else {
        _dayLabel.text = nil;
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dayLabel;
}


@end
