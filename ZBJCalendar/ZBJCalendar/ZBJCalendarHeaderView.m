//
//  ZBJCalendarHeaderView.m
//  ZBJCalendar
//
//  Created by meili cao on 16/2/25.
//  Copyright © 2016年 ZBJ. All rights reserved.
//

#import "ZBJCalendarHeaderView.h"

@interface ZBJCalendarHeaderView ()

@end

@implementation ZBJCalendarHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.calendarLabel];
    }
    return self;
}

- (UILabel *)calendarLabel {
    if (!_calendarLabel) {
        _calendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        _calendarLabel.backgroundColor = [UIColor yellowColor];
        _calendarLabel.text = @"11";
    }
    return _calendarLabel;
}

@end
