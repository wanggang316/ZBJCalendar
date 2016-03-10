//
//  ZBJCalendarView.m
//  ZBJCalendar
//
//  Created by wanggang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarView.h"
#import "ZBJCalendarHeaderView.h"
#import "ZBJCalendarSectionHeader.h"
#import "ZBJCalendarCell.h"
#import "NSDate+ZBJAddition.h"
#import "NSDate+IndexPath.h"

static NSString * const headerIdentifier = @"header";

@interface ZBJCalendarView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) ZBJCalendarHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@end



@implementation ZBJCalendarView

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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ZBJCalendarSectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
    
    NSDate *firstDateOfMonth = [NSDate dateForFirstDayInSection:indexPath.section firstDate:self.firstDate];
    
    NSCalendar *calendar = [NSDate gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:firstDateOfMonth];
    headerView.calendarLabel.text = [NSString stringWithFormat:@" %ld年%ld月", components.year, components.month];
    return headerView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
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
    ZBJCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
    
    NSDate *date = [NSDate dateAtIndexPath:indexPath firstDate:self.firstDate];
    cell.day = date;

    cell.selected = [self.startDate isEqualToDate:date] || [self.endDate isEqualToDate:date];
    
    return cell;
}



#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat w = collectionView.bounds.size.width;
    return CGSizeMake(w, 60);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = collectionView.bounds.size.width;
    CGFloat cellWidth = (w - 6) / 7;
    return CGSizeMake(cellWidth, cellWidth);
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
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 结束日期大于起始日期
    // 起始日期小于结束日期
    
    NSDate *date = [NSDate dateAtIndexPath:indexPath firstDate:self.firstDate];
    if (!self.startDate) {
        self.startDate = date;
        NSLog(@"=====> start date is : %@", date);
    } else if(!self.endDate) {
        self.endDate = date;
        NSLog(@"=====> to date is : %@", date);
    } else {
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
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
        [_collectionView registerClass:[ZBJCalendarCell class] forCellWithReuseIdentifier:@"identifier"];
        [_collectionView registerClass:[ZBJCalendarSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}
@end
