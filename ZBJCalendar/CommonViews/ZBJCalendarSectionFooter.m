//
//  ZBJCalendarSectionFooter.m
//  ZBJCalendar
//
//  Created by wanggang on 3/15/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarSectionFooter.h"

@implementation ZBJCalendarSectionFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5);
        layer.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:233.0/255.0 alpha:1.0].CGColor;
        [self.layer addSublayer:layer];
    }
    return self;
}

@end
