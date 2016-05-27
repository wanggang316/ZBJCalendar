//
//  ZBJComplexRangeSelectionController.h
//  ZBJCalendar
//
//  Created by gumpwang on 3/10/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBJCalendarDates.h"

@protocol ZBJCalendarAdvanceSelectorDelegate;

@interface ZBJComplexRangeSelectionController : UIViewController

@property (nonatomic, weak) id<ZBJCalendarAdvanceSelectorDelegate> delegate;

@property (nonatomic, strong) NSDate *firstDate;
@property (nonatomic, strong) NSDate *lastDate;

@property (nonatomic, strong) NSSet *dates;

@property (nonatomic, assign) NSInteger minNights; // 最小入住天数

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end

@protocol ZBJCalendarAdvanceSelectorDelegate <NSObject>

- (void)popViewController:(UIViewController *)viewController startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@end
