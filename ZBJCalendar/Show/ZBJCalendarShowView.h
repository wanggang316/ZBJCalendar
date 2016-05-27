//
//  ZBJCalendarShowView.h
//  ZBJCalendar
//
//  Created by gumpwang on 3/15/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBJCalendarDates.h"

@interface ZBJCalendarShowView : UIView

- (instancetype)initWithFrame:(CGRect)frame calendarDates:(ZBJCalendarDates *)calendarDates;

@property (nonatomic, strong) ZBJCalendarDates *calendarDates;


@end
