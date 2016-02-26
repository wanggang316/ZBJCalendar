//
//  ZBJCalendarSectionHeader.m
//  ZBJCalendar
//
//  Created by wanggang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarSectionHeader.h"

@implementation ZBJCalendarSectionHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.calendarLabel];
    }
    return self;
}

- (UILabel *)calendarLabel {
    if (!_calendarLabel) {
        _calendarLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _calendarLabel.backgroundColor = [UIColor whiteColor];
        _calendarLabel.font = [UIFont systemFontOfSize:15];
        _calendarLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:59.0f/255.f blue:48.0f/255.0f alpha:1.0];
    }
    return _calendarLabel;
}

@end
