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
        _calendarLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _calendarLabel.backgroundColor = [UIColor whiteColor];
        _calendarLabel.font = [UIFont systemFontOfSize:15];
        _calendarLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:59.0f/255.f blue:48.0f/255.0f alpha:1.0];
    }
    return _calendarLabel;
}

@end
