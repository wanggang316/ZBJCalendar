//
//  ZBJCalendarView.m
//  ZBJCalendar
//
//  Created by gumpwang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarView.h"
#import "NSDate+ZBJAddition.h"
#import "NSDate+IndexPath.h"

@interface ZBJCalendarView () <UICollectionViewDataSource, UICollectionViewDelegate, ZBJCalendarWeekViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, strong) NSString *sectionHeaderIdentifier;
@property (nonatomic, strong) NSString *sectionFooterIdentifier;

@end

@implementation ZBJCalendarView

#pragma  mark - Override
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
        [self addSubview:self.weekView];
        
        self.selectionMode = ZBJSelectionModeMutiple;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // weekViewFrame
    if (self.weekViewHeight > 0) {
        self.weekView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.weekViewHeight);
    } else {
        self.weekView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 46);
    }
    
    // collecitonViewFrame
    self.collectionView.frame = CGRectMake(0,
                                           CGRectGetMaxY(self.weekView.frame),
                                           CGRectGetWidth(self.frame),
                                           CGRectGetHeight(self.frame) - CGRectGetMaxY(self.weekView.frame));
    
    // cellWith
    NSInteger collectionContentWidth = CGRectGetWidth(self.collectionView.frame) - self.contentInsets.left - self.contentInsets.right;
    NSInteger residue = collectionContentWidth % 7;

    CGFloat cellWidth = collectionContentWidth / 7.0;
    if (residue != 0) {
        
        CGFloat newPadding;
        if (residue > 7.0 / 2) {
            newPadding = self.contentInsets.left - (7 - residue) / 2.0;
            cellWidth = (collectionContentWidth + 7 - residue) / 7.0;
        } else {
            newPadding = self.contentInsets.left + (residue / 2.0);
            cellWidth = (collectionContentWidth - residue) / 7.0;
        }
        
        UIEdgeInsets inset = UIEdgeInsetsMake(self.contentInsets.top, newPadding, self.contentInsets.bottom, newPadding);
        self.contentInsets = inset;
    }
    self.collectionView.contentInset = self.contentInsets;
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(self.contentInsets.top, 0, self.contentInsets.bottom, 0);
    self.weekView.contentInsets = self.contentInsets;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    // cellHeight
    if (self.cellScale > 0) {
        layout.itemSize = CGSizeMake(cellWidth, (int)(cellWidth * self.cellScale));
    } else {
        layout.itemSize = CGSizeMake(cellWidth, cellWidth);
    }

    self.collectionView.collectionViewLayout = layout;
}

#pragma mark - public method
- (void)registerCellClass:(id)clazz withReuseIdentifier:(NSString *)identifier {
    self.cellIdentifier = identifier;
    [self.collectionView registerClass:clazz forCellWithReuseIdentifier:identifier];
}

- (void)registerSectionHeader:(id)clazz withReuseIdentifier:(NSString *)identifier{
    self.sectionHeaderIdentifier = identifier;
    [self.collectionView registerClass:clazz forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
}

- (void)registerSectionFooter:(id)clazz withReuseIdentifier:(NSString *)identifier{
    self.sectionFooterIdentifier = identifier;
    [self.collectionView registerClass:clazz forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
}

- (void)setWeekViewHeight:(CGFloat)weekViewHeight {
    _weekViewHeight = weekViewHeight;
    self.weekView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), _weekViewHeight);
}

- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing {
    _minimumLineSpacing = minimumLineSpacing;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    if (_minimumLineSpacing > 0) {
        layout.minimumLineSpacing = _minimumLineSpacing;
    } else {
        layout.minimumLineSpacing = 0;
    }
    self.collectionView.collectionViewLayout = layout;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.collectionView.backgroundColor = backgroundColor;
    self.weekView.backgroundColor = backgroundColor;
}

- (void)setAllowsSelection:(BOOL)allowsSelection {
    _allowsSelection = allowsSelection;
    self.collectionView.allowsSelection = _allowsSelection;
}

- (void)setDataSource:(id<ZBJCalendarDataSource>)dataSource {
    _dataSource = dataSource;
    self.weekView.delegate = self;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (id)cellAtDate:(NSDate *)date {
    NSIndexPath *indexPath = [NSDate indexPathAtDate:date firstDate:self.firstDate];
    return [self.collectionView cellForItemAtIndexPath:indexPath];
}

- (void)reloadItemsAtDates:(NSSet<NSDate *> *)dates {
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (NSDate *date in dates) {
        NSIndexPath *indexPath = [NSDate indexPathAtDate:date firstDate:self.firstDate];
        [indexPaths addObject:indexPath];
    }
    [self.collectionView reloadItemsAtIndexPaths:indexPaths];
}

- (void)reloadItemsAtMonths:(NSSet<NSDate *> *)months {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSDate *date in months) {
        NSIndexPath *indexPath = [NSDate indexPathAtDate:date firstDate:self.firstDate];
        [indexSet addIndex:indexPath.section];
    }
    [self.collectionView reloadSections:indexSet];
}


#pragma mark - private methods
- (NSDate *)dateForCollectionView:(UICollectionView *)collection atIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = nil;
    
    // if headStyle is `ZBJCalendarViewHeadStyleCurrentWeek`, the first month is special
    if (self.headStyle == ZBJCalendarViewHeadStyleCurrentWeek && indexPath.section == 0) {
        NSDate *firstDay = [self.firstDate firstDateOfWeek];
        NSDate *lastDateOfMonth = [self.firstDate lastDateOfMonth];
        NSInteger items = [NSDate numberOfNightsFromDate:firstDay toDate:lastDateOfMonth];
        if (indexPath.row > items) {
        } else {
            NSCalendar *calendar = [NSDate gregorianCalendar];
            NSDateComponents *components = [calendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:firstDay];
            [components setDay:indexPath.row];
            [components setMonth:indexPath.section];
            date = [calendar dateByAddingComponents:components toDate:firstDay options:0];
        }
    } else { // normal logic
        date = [NSDate dateAtIndexPath:indexPath firstDate:self.firstDate];
    }

    return date;
}

#pragma mark UICollectionViewDataSource

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *firstDateOfMonth = [NSDate dateForFirstDayInSection:indexPath.section firstDate:self.firstDate];
    
    if (self.sectionHeaderIdentifier && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        id headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:self.sectionHeaderIdentifier forIndexPath:indexPath];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(calendarView:configureSectionHeaderView:firstDateOfMonth:)]) {
            [self.dataSource calendarView:self configureSectionHeaderView:headerView firstDateOfMonth:firstDateOfMonth];
        }
        return headerView;
    } else if (self.sectionFooterIdentifier && [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        id footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:self.sectionFooterIdentifier forIndexPath:indexPath];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(calendarView:configureSectionFooterView:lastDateOfMonth:)]) {
            [self.dataSource calendarView:self configureSectionFooterView:footerView lastDateOfMonth:[firstDateOfMonth lastDateOfMonth]];
        }
        return footerView;
    }
   
    return NULL;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // if headStyle is `ZBJCalendarViewHeadStyleCurrentWeek`, the first month is special
    if (self.headStyle == ZBJCalendarViewHeadStyleCurrentWeek && section == 0) {
        NSInteger weekDay = [self.firstDate weekday];
        NSDate *lastDateOfMonth = [self.firstDate lastDateOfMonth];
        NSInteger lastDateOfMonthWeekDay = [lastDateOfMonth weekday];
        NSInteger items = weekDay + [NSDate numberOfNightsFromDate:self.firstDate toDate:lastDateOfMonth] + 7 - lastDateOfMonthWeekDay;
        return items;
    }
    
    // normal logic
    NSDate *firstDay = [NSDate dateForFirstDayInSection:section firstDate:self.firstDate];
    NSInteger weekDay = [firstDay weekday] -1;
    NSInteger items =  weekDay + [NSDate numberOfDaysInMonth:firstDay];
    return items;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger months = [NSDate numberOfMonthsFromDate:self.firstDate toDate:self.lastDate];
    return months;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    NSDate *date = [self dateForCollectionView:collectionView atIndexPath:indexPath];
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(calendarView:configureCell:forDate:)]) {
        [self.dataSource calendarView:self configureCell:cell forDate:date];
    }
   
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *date = [self dateForCollectionView:collectionView atIndexPath:indexPath];
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:shouldSelectDate:)]) {
        return [self.delegate calendarView:self shouldSelectDate:date];
    }
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    NSDate *date = [self dateForCollectionView:collectionView atIndexPath:indexPath];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:didSelectDate:ofCell:)]) {
        id cell = [collectionView cellForItemAtIndexPath:indexPath];
        [self.delegate calendarView:self didSelectDate:date ofCell:cell];
    }
}


#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.sectionHeaderIdentifier) {
        if (self.sectionHeaderHeight > 0) {
            return CGSizeMake(CGRectGetWidth(collectionView.frame), self.sectionHeaderHeight);
        } else {
            return CGSizeMake(CGRectGetWidth(collectionView.frame), 52);
        }
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.sectionFooterIdentifier) {
        if (self.sectionFooterIdentifier > 0) {
            return CGSizeMake(CGRectGetWidth(collectionView.frame), self.sectionFooterHeight);
        } else {
            return CGSizeMake(CGRectGetWidth(collectionView.frame), 13);
        }
    }
    return CGSizeZero;
}

#pragma mark - ZBJCalendarWeekViewDelegate
- (void)calendarWeekView:(ZBJCalendarWeekView *)weekView configureWeekDayLabel:(UILabel *)dayLabel atWeekDay:(NSInteger)weekDay {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(calendarView:configureWeekDayLabel:atWeekDay:)]) {
        [self.dataSource calendarView:self configureWeekDayLabel:dayLabel atWeekDay:weekDay];
    }
}

#pragma mark - getters

- (ZBJCalendarWeekView *)weekView {
    if (!_weekView) {
        _weekView = [[ZBJCalendarWeekView alloc] init];
    }
    return _weekView;
}



- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}


#pragma mark - setters
- (void)setSelectionMode:(ZBJSelectionMode)selectionMode {
    _selectionMode = selectionMode;
    switch (_selectionMode) {
        case ZBJSelectionModeSingle: {
            self.collectionView.allowsSelection = YES;
            self.collectionView.allowsMultipleSelection = NO;
            break;
        }
        case ZBJSelectionModeMutiple: {
            self.collectionView.allowsSelection = YES;
            self.collectionView.allowsMultipleSelection = YES;
            break;
        }
        default: {
            self.collectionView.allowsSelection = NO;
            self.collectionView.allowsMultipleSelection = NO;
            break;
        }
    }
}


@end
