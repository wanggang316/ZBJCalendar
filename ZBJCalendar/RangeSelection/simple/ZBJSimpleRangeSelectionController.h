//
//  ZBJSimpleRangeSelectionController.h
//  ZBJCalendar
//
//  Created by gumpwang on 2/26/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZBJCalendarRangeSelectorDelegate;

@interface ZBJSimpleRangeSelectionController : UIViewController

@property (nonatomic, weak) id<ZBJCalendarRangeSelectorDelegate> delegate;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end

@protocol ZBJCalendarRangeSelectorDelegate <NSObject>

- (void)popViewController:(UIViewController *)viewController startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@end
