//
//  ZBJCalendarWeekView.h
//  ZBJCalendar
//
//  Created by gumpwang on 16/2/25.
//  Copyright © 2016年 ZBJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZBJCalendarWeekViewDelegate;

/**
 *  `ZBJCalendarWeekView` is the default view for display week days.
 *  By default, is contains 7 labels present monday to sunday.
 *  You can custom weekView style by the public property `weekView` of `ZBJCalendarView`.
 *  If you want to change each week day's style, you can conform the `ZBJCalendarWeekViewDelegate` and implement `- (void)calendarWeekView:(ZBJCalendarWeekView *)weekView configureWeekDayLabel:(UILabel *)dayLabel atWeekDay:(NSInteger)weekDay;` method.
 */
@interface ZBJCalendarWeekView : UIView

/**
 *  A reference of `ZBJCalendarWeekViewDelegate` which can custom week day label.
 */
@property (nonatomic, weak) id<ZBJCalendarWeekViewDelegate> delegate;

/**
 *  The inner padding of week view.
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;   // the inner padding

/**
 *  Default line at the bottom of week view.
 */
@property (nonatomic, strong) CALayer *bottomLine;

/**
 *  reload week View manual
 */
- (void)reloadWeekView;

@end

@protocol ZBJCalendarWeekViewDelegate <NSObject>

@optional
/**
 *  Used to configure the weekday label with the `weekDay`
 *
 *  @param weekView  self
 *  @param dayLabel  weekday label
 *  @param weekDay   integer of the weekday
 */
- (void)calendarWeekView:(ZBJCalendarWeekView *)weekView configureWeekDayLabel:(UILabel *)dayLabel atWeekDay:(NSInteger)weekDay;

@end
