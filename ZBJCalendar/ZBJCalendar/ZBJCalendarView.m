//
//  ZBJCalendarView.m
//  ZBJCalendar
//
//  Created by wanggang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarView.h"
#import "ZBJCalendarCell.h"
#import "ZBJCalendarSectionHeader.h"
#import "NSDate+ZBJAddition.h"
#import "ZBJCalendarHeaderView.h"

@interface ZBJCalendarView() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ZBJCalendarHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *calendarData;

@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

static NSString *headerIdentifier = @"header";

@implementation ZBJCalendarView

- (NSDate *)dateForFirstDayInSection:(NSInteger)section {
    
    NSCalendar *calendar = [NSDate gregorianCalendar];
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.month = section;
    return [calendar dateByAddingComponents:dateComponents toDate:[self.firstDate firstDateOfMonth] options:0];
}

- (NSDate *)dateAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *firstDay = [self dateForFirstDayInSection:indexPath.section];
    NSInteger weekDay = [firstDay weekday];
    NSDate *dateToReturn = nil;
    
    if (indexPath.row < (weekDay-1)) {
        dateToReturn = nil;
    } else {
        NSCalendar *calendar = [NSDate gregorianCalendar];

        NSDateComponents *components = [calendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:firstDay];
        [components setDay:indexPath.row - (weekDay - 1)];
        [components setMonth:indexPath.section];
        dateToReturn = [calendar dateByAddingComponents:components toDate:[self.firstDate firstDateOfMonth] options:0];
    }
    return dateToReturn;
}









#pragma  mark - Override

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self addSubview:self.headerView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerView.frame = CGRectMake(0, 64, CGRectGetWidth(self.frame), 20);
    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDate *firstDay = [self dateForFirstDayInSection:section];
    NSInteger weekDay = [firstDay weekday] -1;
    NSInteger items =  weekDay + [NSDate numberOfDaysInMonth:firstDay];
    return items;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger months = [NSDate numberOfMonthsFormDate:self.firstDate toDate:self.lastDate];
    return months;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZBJCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
    NSDate *date = [self dateAtIndexPath:indexPath];
    if (date) {
        NSCalendar *calendar = [NSDate gregorianCalendar];
        cell.day = [calendar component:NSCalendarUnitDay fromDate:date];
        cell.isToday = [date isToday];
    } else {
        cell.day = 0;
        cell.isToday = NO;
    }
    
    cell.selected = [self.selectedIndexPath isEqual:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    return NO;
//}


//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    ZBJCalendarCell *cell = (ZBJCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.selected = NO;
//}

//- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    ZBJCalendarCell *cell = (ZBJCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.selected = YES;
//}



- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectedIndexPath isEqual:indexPath]) {
        return NO;
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectedIndexPath isEqual:indexPath]) {
        return YES;
    }
    return NO;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    ZBJCalendarCell *cell = (ZBJCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.selected = YES;
    self.selectedIndexPath = indexPath;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    ZBJCalendarCell *cell = (ZBJCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.selected = NO;
}





#pragma mark UICollectionViewDelegateFlowLayout

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ZBJCalendarSectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
    
    NSDate *firstDateOfMonth = [self dateForFirstDayInSection:indexPath.section];
    
    NSCalendar *calendar = [NSDate gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:firstDateOfMonth];
    headerView.calendarLabel.text = [NSString stringWithFormat:@" %ld年%ld月", components.year, components.month];
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat w = collectionView.bounds.size.width;
    return CGSizeMake(w, 60);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = collectionView.bounds.size.width;
    CGFloat cellWidth = (w - 6) / 7;
    return CGSizeMake(cellWidth, cellWidth);
}

#pragma mark - getters

- (ZBJCalendarHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[ZBJCalendarHeaderView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.frame), 20)];
    }
    return _headerView;
}



- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
         [_collectionView registerClass:[ZBJCalendarCell class] forCellWithReuseIdentifier:@"identifier"];
        [_collectionView registerClass:[ZBJCalendarSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    }
    return _collectionView;
}
@end
