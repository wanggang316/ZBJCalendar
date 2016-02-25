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
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5,(w - 80)/7,30)];
        [self addSubview:_dayLabel];
        _dayLabel.backgroundColor = [UIColor redColor];
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}


@end
