//
//  ZBJCalendarView.h
//  ZBJCalendar
//
//  Created by gumpwang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBJCalendarWeekView.h"

typedef CF_ENUM(NSInteger, ZBJSelectionMode) {
    ZBJSelectionModeDisable = 0,    // Can not select
    ZBJSelectionModeSingle,         // Single selection mode
    ZBJSelectionModeMutiple,        // Mutile selection mode
};

typedef CF_ENUM(NSInteger, ZBJCalendarViewHeadStyle) {
    ZBJCalendarViewHeadStyleCurrentMonth = 0,    // Show current month of the first day.
    ZBJCalendarViewHeadStyleCurrentWeek,        // Show current week of the first day, the days before current will hiden.
};

@protocol ZBJCalendarDataSource, ZBJCalendarDelegate;

/**
 * `ZBJCalendarView` provide a convenience way to write a calendar view. The concept of `ZBJCalendarView` is `UICollectionView` or `UITableView`, some properties contains `dataSource` which to used to custom cells or headers and `delegate` which used to handle the display and behaviour of the day cells.
 *
 * The structure of `ZBJCalendarView` is simple, it contains a `weekView` as public.
    - The `weekView` is an instance of `ZBJCalendarWeekView` that you can implements the methods in `dataSource` about week view.
    - The `collectionView` is an instance of `UICollectionView`, the UICollectionView cell correspond the day of the calendar.
 *
 * The usage of `ZBJCalendarView` is simple, is familiar like `UITableView` or `UICollectionView`
    - first, you should point the `firstDate` and `lastDate`, 
    - second, like `UITableView` or `UICollectionView`, it must registe a cell through `- (void)registerCellClass:(id)clazz withReuseIdentifier:(NSString *)identifier;`, 
    - finally, conform the `ZBJCalendarDataSource` protocol and must implement `- (void)calendarView:(ZBJCalendarView *)calendarView configureCell:(id)cell forDate:(NSDate *)date;` as `@required`.
 *
 */
@interface ZBJCalendarView : UIView

/**
 CollectionView is public
 */
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 * A reference of `ZBJCalendarDataSource` used to custom calendar day cells.
 */
@property (nonatomic, weak) id<ZBJCalendarDataSource> dataSource;

/**
 *  A reference of `ZBJCalendarDelegate` used to handle the calendar day cells's display and behaviours.
 */
@property (nonatomic, weak) id<ZBJCalendarDelegate> delegate;

/**
 *  The tow properties `firstDate` and `lastDate` are necessary for calendar.
    - `firstDate` is the start date of the calendar
    - `lastDate` is the end date of the calendar
 */
@property (nonatomic, strong) NSDate *firstDate;
@property (nonatomic, strong) NSDate *lastDate;

/**
 *  `weekView` is used to display the week days.
 *  It's a public property that means you can define the style as you like.
 */
@property (nonatomic, strong) ZBJCalendarWeekView *weekView;

/**
 *  `ZBJCalendarView` has three selection mode, it's defined as a enum `ZBJSelectionMode`.
 *  The concept of selection mode is to control the `collectionView`'s `allowsSelection` and `allowsMultipleSelection`.
 *  Default value is `ZBJSelectionModeRange`
 */
@property (nonatomic, assign) ZBJSelectionMode selectionMode;

/**
 *  This property used to control whether the calendar view is selectable or not directly.
 *  As `selectionMode`, it controler the collectionView's `allowsSelection` property.
 */
@property (nonatomic, assign) BOOL allowsSelection;

/**
 *  This `headStyle` is the style of the current month display style.
 */
@property (nonatomic, assign) ZBJCalendarViewHeadStyle headStyle;

///-------------------------------
/// @name layout properties
///-------------------------------

/**
 * The calendarView inner padding.
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat weekViewHeight;
@property (nonatomic, assign) CGFloat sectionHeaderHeight;
@property (nonatomic, assign) CGFloat sectionFooterHeight;

/**
 *  Calendar offset which is not contains contentInset
 *  `contentOffset.x` = `collectionView.contentOffset.x` + `collectionView.contentInset.left`
 *  `contentOffset.y` = `collectionView.contentOffset.y` + `collectionView.contentInset.top`
 */
@property (nonatomic, assign) CGPoint contentOffset;

/**
 *  Calendar content size which is not contains weekHeight in vertical.
 */
@property (nonatomic, assign, readonly) CGSize contentSize;

/**
 * In calendar view, the cell width is calculated as by this expression, `cellWidth = (calendar.width - contentInsets.left - contentInsets.right) / 7`
   cellWidth is variable with the screen changing,
   So, we define a scale to calculate cellHeight is convenient, `cellScale = cellHeight / cellWidth`.
 */
@property (nonatomic, assign) CGFloat cellScale;

/**
 *  Registe a class for calendar day cell.
 *
 *  @param clazz      Calendar day cell, it should be a subclass of `UICollectionViewCell`
 *  @param identifier The cell's reuse identifier.
 */
- (void)registerCellClass:(id)clazz withReuseIdentifier:(NSString *)identifier;

/**
 *  This two methods used to registe a class for calendar section header or footer view.
 *
 *  @param clazz      Calendar section header or footer view, it should be a subclass of `UICollectionReusableView`
 *  @param identifier The view's reuse identifier.
 */
- (void)registerSectionHeader:(id)clazz withReuseIdentifier:(NSString *)identifier;
- (void)registerSectionFooter:(id)clazz withReuseIdentifier:(NSString *)identifier;

/**
 *  Reloads everything from scratch, redisplays visible cells.
 */
- (void)reloadData;

/**
 *  Get corresponding cell with `date`
 *
 *  @param date
 *
 *  @return The corresponding cell.
 */
- (id)cellAtDate:(NSDate *)date;

/**
 *  Reload cell with `NSDate` set.
 *
 *  @param dates
 */
- (void)reloadItemsAtDates:(NSSet<NSDate *> *)dates;

/**
 *  Reload month section with `NSDate` set
 *
 *  @param months month element in this set should contains year and month
 */
- (void)reloadItemsAtMonths:(NSSet<NSDate *> *)months;

/**
 *  Set content offset of calendar view
 *
 *  @param contentOffset
 *  @param animated
 */
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;

@end
/**
 *  This protocol represents the cell data model object. 
 *  As such, it supplies the cell's information about appearance and data.
 */
@protocol ZBJCalendarDataSource <NSObject>

@required
/**
 *  This method is used for configure the day cell with current `date`.
 *  Implementers can setup `date` to cell and custom appearance for cell by this method.
 *
 *  @param calendarView  self
 *  @param cell          current reuse cell
 *  @param date          current date
 */
- (void)calendarView:(ZBJCalendarView *)calendarView configureCell:(id)cell forDate:(NSDate *)date;

@optional
/**
 *  If you registe a section header or footer, you should configure them by them two methods, calendar will provide current `year` and `month` for you.
 *
 *  @param calendarView self
 *  @param headerView   current reuse section header or footer view
 *  @param firstDateOfMonth & lastDateOfMonth
 */
- (void)calendarView:(ZBJCalendarView *)calendarView configureSectionHeaderView:(id)headerView firstDateOfMonth:(NSDate *)firstDateOfMonth;
- (void)calendarView:(ZBJCalendarView *)calendarView configureSectionFooterView:(id)headerView lastDateOfMonth:(NSDate *)lastDateOfMonth;

/**
 *  This method is used for configure the cell of the week view with the `weekDay`
 *
 *  @param calendarView self
 *  @param dayLabel     week day label
 *  @param weekDay      current week day
 */
- (void)calendarView:(ZBJCalendarView *)calendarView configureWeekDayLabel:(UILabel *)dayLabel atWeekDay:(NSInteger)weekDay;
@end

@protocol ZBJCalendarDelegate <NSObject>

@optional
/**
 *  Return whether the date is selectable
 *
 *  @param calendarView self
 *  @param date         current date
 *
 *  @return selectable of the calendarView cell
 */
- (BOOL)calendarView:(ZBJCalendarView *)calendarView shouldSelectDate:(NSDate *)date;

/**
 *  Correspond the selection event of the calendarView with current `date`.
 *
 *  @param calendarView self
 *  @param date         current date
 */
- (void)calendarView:(ZBJCalendarView *)calendarView didSelectDate:(NSDate *)date ofCell:(id)cell;

/**
 *  ScrollView delegate methods
 *
 *  @param scrollView UICollectionView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
