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

// layout
@property (nonatomic, assign) UIEdgeInsets contentInsets;   // the inner padding
@property (nonatomic, assign) CGFloat sectionHeaderHeight;
@property (nonatomic, assign) CGFloat sectionFooterHeight;
@property (nonatomic, assign) CGFloat cellScale; // height/width
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat weekViewHeight;

- (void)registerCellClass:(id)clazz withReuseIdentifier:(NSString *)identifier;
- (void)registerSectionHeader:(id)clazz withReuseIdentifier:(NSString *)identifier;
- (void)registerSectionFooter:(id)clazz withReuseIdentifier:(NSString *)identifier;

@end


@protocol ZBJCalendarDelegate <NSObject>

- (BOOL)calendarView:(ZBJCalendarView *)calendarView shouldSelectDate:(NSDate *)date;
- (void)calendarView:(ZBJCalendarView *)calendarView configureCell:(id)cell forDate:(NSDate *)date;
- (void)calendarView:(ZBJCalendarView *)calendarView didSelectDate:(NSDate *)date;

@optional
- (void)calendarView:(ZBJCalendarView *)calendarView configureSectionHeaderView:(id)headerView forYear:(NSInteger)year month:(NSInteger)month;
- (void)calendarView:(ZBJCalendarView *)calendarView configureSectionFooterView:(id)headerView forYear:(NSInteger)year month:(NSInteger)month;
@end
