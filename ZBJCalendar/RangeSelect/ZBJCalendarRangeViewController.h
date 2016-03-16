//
//  CalendarViewController.h
//  ZBJCalendar
//
//  Created by wanggang on 2/26/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZBJCalendarRangeSelectorDelegate;
@interface ZBJCalendarRangeViewController : UIViewController

@property (nonatomic, weak) id<ZBJCalendarRangeSelectorDelegate> delegate;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end

@protocol ZBJCalendarRangeSelectorDelegate <NSObject>

- (void)popViewController:(ZBJCalendarRangeViewController *)viewController startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@end
