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

@end
