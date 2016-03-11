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
        
        self.selectionMode = ZBJSelectionModeRange;
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
    
    if (date) {
        
        // 日期在今天以前
        if ([[date dateByAddingTimeInterval:86400.0 - 1] compare:[NSDate date]] == NSOrderedAscending) {
            cell.isDisabledDate = YES;
        } else {
        
            // set `isDisabledDate`, default is avaible
            BOOL isUnavailable = NO;
            for (ZBJOfferDay *day in self.dates) {
                if ([day.date isEqualToDate:date]) {
                    isUnavailable = !day.available.boolValue;
                    break;
                }
            }
            if (isUnavailable) {
                cell.isUnavailableDate = YES;
            } else {
                // avaible dates configure
                // set `isStartDate`, `isEndDate` and `isMidDate`, else is avaible.
                if ([self.startDate isEqualToDate:date]) {
                    cell.isStartDate = YES;
                } else if ( [self.endDate isEqualToDate:date]) {
                    cell.isEndDate = YES;
                } else if (self.startDate && self.endDate &&
                    ![self.startDate isEqualToDate:date] &&
                    ![self.endDate isEqualToDate:date]) {
                    
                    // between `startDate` and `endDate` is midDate.
                    cell.isMidDate = ([date compare:self.startDate] == NSOrderedDescending) && ([date compare:self.endDate] == NSOrderedAscending);
                } else {
                    cell.isUnavailableDate = NO;
                }
            }
        }
    }
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectionMode == ZBJSelectionModeRange) {
        NSDate *date = [NSDate dateAtIndexPath:indexPath firstDate:self.firstDate];
        
        if (date) {
            // 选择了起始日期，没有选择结束日期
            // 结束日期 < 起始日期
            if (self.startDate && !self.endDate &&
                [date compare:self.startDate] == NSOrderedAscending) {
                return NO;
            }
            
            // 日期在今天之前
            // 先取到当天的最后一秒: xxxx-xx-xx 23:59:59
            if ([[date dateByAddingTimeInterval:86400.0 - 1] compare:[NSDate date] ] == NSOrderedAscending) {
                return NO;
            }
            
            // avaiable
            for (ZBJOfferDay *day in self.dates) {
                if ([day.date isEqualToDate:date]) {
                    return [day.available boolValue];
                    break;
                }
            }
            
        } else {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    if (self.selectionMode == ZBJSelectionModeRange) {
        NSDate *date = [NSDate dateAtIndexPath:indexPath firstDate:self.firstDate];
        
        if (date) {
            if (!self.startDate) {
                self.startDate = date;
                NSLog(@"=====> start date is : %@", date);
            } else if(!self.endDate) {
                self.endDate = date;
                NSLog(@"=====> end date is : %@", date);
                
                [collectionView reloadData];
                
            } else {
                self.startDate = date;
                self.endDate = nil;
                
                [collectionView reloadData];
            }
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
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


#pragma mark - setters
- (void)setSelectionMode:(ZBJSelectionMode)selectionMode {
    _selectionMode = selectionMode;
    switch (_selectionMode) {
        case ZBJSelectionModeSingle: {
            self.collectionView.allowsSelection = YES;
            break;
        }
        case ZBJSelectionModeRange: {
            self.collectionView.allowsMultipleSelection = YES;
            break;
        }
        default: {
            self.collectionView.allowsSelection = NO;
            break;
        }
    }
}
@end
