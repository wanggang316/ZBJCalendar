//
//  ZBJCalendarCell.m
//  ZBJCalendar
//
//  Created by wanggang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarCell.h"

@interface ZBJCalendarCell ()

@end

@implementation ZBJCalendarCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dayLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dayLabel];
        _dayLabel.backgroundColor = [UIColor colorWithRed:249.0f/255.0f green:249.0f/255.0f blue:249.0f/255.0f alpha:1.0];
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}


@end
