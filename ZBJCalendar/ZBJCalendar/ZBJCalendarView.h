//
//  ZBJCalendarView.h
//  ZBJCalendar
//
//  Created by wanggang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBJOfferCalendar.h"

typedef CF_ENUM(NSInteger, ZBJSelectionMode) {
    ZBJSelectionModeNone,
    ZBJSelectionModeSingle,
    ZBJSelectionModeRange,
};

@protocol ZBJCalendarDelegate;

@interface ZBJCalendarView : UIView

@property (nonatomic, weak) id<ZBJCalendarDelegate> delegate;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSDate *firstDate;
@property (nonatomic, strong) NSDate *lastDate;

@property (nonatomic, assign) ZBJSelectionMode selectionMode;  // default is `YES`, select `startDate` and `endDate`
@property (nonatomic, assign) UIEdgeInsets contentInsets;   // the inner padding

- (void)registerCellClass:(id)clazz;
- (void)registerSectionHeader:(id)clazz;

@end


@protocol ZBJCalendarDelegate <NSObject>

- (BOOL)calendarView:(ZBJCalendarView *)calendarView shouldSelectDate:(NSDate *)date;
- (void)calendarView:(ZBJCalendarView *)calendarView configureCell:(id)cell forDate:(NSDate *)date;
- (void)calendarView:(ZBJCalendarView *)calendarView didSelectDate:(NSDate *)date;

- (void)calendarView:(ZBJCalendarView *)calendarView configureSectionHeaderView:(id)headerView forYear:(NSInteger)year month:(NSInteger)month;
@end
