//
//  ZBJCalendarCell.h
//  ZBJCalendar
//
//  Created by wanggang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CF_ENUM(NSInteger, ZBJCalendarCellState) {
    ZBJCalendarCellStateEmpty,
    ZBJCalendarCellStateDisabled,
    ZBJCalendarCellStateUnavaible,
    ZBJCalendarCellStateAvaible,
    ZBJCalendarCellStateAvaibleDisabled,
    ZBJCalendarCellStateSelectedStart,
    ZBJCalendarCellStateSelectedMiddle,
    ZBJCalendarCellStateSelectedEnd,
    ZBJCalendarCellStateSelectedTempEnd,
};


@interface ZBJCalendarCell : UICollectionViewCell

@property (nonatomic, strong) NSDate *day;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, assign) BOOL isToday;


@property (nonatomic, assign) ZBJCalendarCellState cellState;


/*
// equals forbiden status
@property (nonatomic, assign) BOOL isDisabledDate;

// is selectable and is selected
@property (nonatomic, assign) BOOL isStartDate;
@property (nonatomic, assign) BOOL isEndDate;
@property (nonatomic, assign) BOOL isMidDate;  // between selected `startDate` and selected `endDate`

// is selectable but not available
@property (nonatomic, assign) BOOL isUnavailableDate;

// other status is normal
 
*/
@end
