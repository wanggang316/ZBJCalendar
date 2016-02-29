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
#import "NSDate+IndexPath.h"
#import "ZBJCalendarHeaderView.h"
#import "ZBJCalendarSingleDelegate.h"
#import "ZBJCalendarMultiDelegate.h"

static NSString * const headerIdentifier = @"header";

@interface ZBJCalendarView() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ZBJCalendarHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *calendarData;

@property (nonatomic, strong) NSCalendar *calendar;



@end



@implementation ZBJCalendarView

//- (NSDate *)dateForFirstDayInSection:(NSInteger)section {
//    
//    NSCalendar *calendar = [NSDate gregorianCalendar];
//    
//    NSDateComponents *dateComponents = [NSDateComponents new];
//    dateComponents.month = section;
//    return [calendar dateByAddingComponents:dateComponents toDate:[self.firstDate firstDateOfMonth] options:0];
//}
//
//- (NSDate *)dateAtIndexPath:(NSIndexPath *)indexPath {
//    NSDate *firstDay = [self dateForFirstDayInSection:indexPath.section];
//    NSInteger weekDay = [firstDay weekday];
//    NSDate *dateToReturn = nil;
//    
//    if (indexPath.row < (weekDay-1)) {
//        dateToReturn = nil;
//    } else {
//        NSCalendar *calendar = [NSDate gregorianCalendar];
//
//        NSDateComponents *components = [calendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:firstDay];
//        [components setDay:indexPath.row - (weekDay - 1)];
//        [components setMonth:indexPath.section];
//        dateToReturn = [calendar dateByAddingComponents:components toDate:[self.firstDate firstDateOfMonth] options:0];
//    }
//    return dateToReturn;
//}









#pragma  mark - Override

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self addSubview:self.headerView];
        self.selectedType = ZBJCalendarSelectedTypeSingle;
    }
    return self;
}


- (void)setSelectedType:(ZBJCalendarSelectedType)selectedType {
    _selectedType = selectedType;
    if (_selectedType == ZBJCalendarSelectedTypeMulti) {
        ZBJCalendarMultiDelegate *delegate = [ZBJCalendarMultiDelegate new];
        delegate.firstDate = self.firstDate;
        _collectionView.delegate = delegate;
    } else {
        ZBJCalendarSingleDelegate *delegate = [ZBJCalendarSingleDelegate new];
        delegate.firstDate = self.firstDate;
        _collectionView.delegate = delegate;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerView.frame = CGRectMake(0, 64, CGRectGetWidth(self.frame), 20);
    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDate *firstDay = [NSDate dateForFirstDayInSection:section firstDate:self.firstDate];
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
    NSDate *date = [NSDate dateAtIndexPath:indexPath firstDate:self.firstDate];
    if (date) {
        NSCalendar *calendar = [NSDate gregorianCalendar];
        cell.day = [calendar component:NSCalendarUnitDay fromDate:date];
        cell.isToday = [date isToday];
    } else {
        cell.day = 0;
        cell.isToday = NO;
    }
    
//    cell.selected = [self.selectedIndexPath isEqual:indexPath];
    
    return cell;
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
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZBJCalendarCell class] forCellWithReuseIdentifier:@"identifier"];
        [_collectionView registerClass:[ZBJCalendarSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    }
    return _collectionView;
}
@end
