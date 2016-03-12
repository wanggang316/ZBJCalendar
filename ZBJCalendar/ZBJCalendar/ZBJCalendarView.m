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


typedef CF_ENUM(NSInteger, ZBJCalendarSelectedState) {
    ZBJCalendarStateSelectedNone,
    ZBJCalendarStateSelectedStart,
    ZBJCalendarStateSelectedRange,
};


static NSString * const headerIdentifier = @"header";

@interface ZBJCalendarView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) ZBJCalendarHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) ZBJCalendarSelectedState selectedState;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
//@property (nonatomic, strong) NSMutableSet *tempAvaibleDates;
@property (nonatomic, strong) NSMutableSet *tempUnavaibleDates;
@property (nonatomic, strong) NSDate *nearestUnavaibleDate;

@end



@implementation ZBJCalendarView

#pragma  mark - Override
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self addSubview:self.headerView];
        
        self.selectionMode = ZBJSelectionModeRange;
        
//        self.tempAvaibleDates = [[NSMutableSet alloc] init];
        self.tempUnavaibleDates = [[NSMutableSet alloc] init];
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
    
    NSNumber *price = nil;
    ZBJCalendarCellState cellState = -1;
    
    if (date) {
        // 如果小于起始日期或大于结束日期，那么disabled
        if ([[date dateByAddingTimeInterval:86400.0 - 1] compare:self.firstDate] == NSOrderedAscending ||
            [date compare:self.lastDate] != NSOrderedAscending) { //不大于最后一天
            
            cellState = ZBJCalendarCellStateDisabled;
        } else {
            
            ZBJOfferDay *day = [self offerDateWithDate:date];
            price = day.price;
            
            BOOL isAvaible = day.available.boolValue;
            
            switch (self.selectedState) {
                case ZBJCalendarStateSelectedStart: {
                    
                    if ([[date dateByAddingTimeInterval:86400.0 - 1] compare:self.startDate] == NSOrderedAscending &&
                        [date compare:self.firstDate] == NSOrderedDescending) {
                        
                        if (isAvaible) {
                            cellState = ZBJCalendarCellStateAvaibleDisabled;
                        } else {
                            cellState = ZBJCalendarCellStateUnavaible;
                        }
                    } else if ([self.startDate isEqualToDate:date]) {
                        cellState = ZBJCalendarCellStateSelectedStart;
                    } else if ([self.tempUnavaibleDates containsObject:date]) {
                        cellState = ZBJCalendarCellStateAvaibleDisabled;
                    } else if (self.nearestUnavaibleDate && [self.nearestUnavaibleDate isEqualToDate:date]) {
                        cellState = ZBJCalendarCellStateSelectedTempEnd;
                    } else if (self.nearestUnavaibleDate &&
                               [date compare:self.nearestUnavaibleDate] == NSOrderedDescending &&
                               [[date dateByAddingTimeInterval:86400.0 - 1] compare:self.lastDate] == NSOrderedAscending
                               ) {
                        if (isAvaible) {
                            cellState = ZBJCalendarCellStateAvaibleDisabled;
                        } else {
                            cellState = ZBJCalendarCellStateUnavaible;
                        }
                    } else {
                        
                        if (isAvaible) {
                            cellState = ZBJCalendarCellStateAvaible;
                        } else {
                            cellState = ZBJCalendarCellStateUnavaible;
                        }
                    }

                    break;
                }
                case ZBJCalendarStateSelectedRange: {
                    
//                    if ([[date dateByAddingTimeInterval:86400.0 - 1] compare:self.startDate] == NSOrderedAscending &&
//                        [date compare:self.firstDate] == NSOrderedDescending) {
//                        
//                        if (isAvaible) {
//                            cellState = ZBJCalendarCellStateAvaible;
//                        } else {
//                            cellState = ZBJCalendarCellStateUnavaible;
//                        }
//                    } else
                    if ([self.startDate isEqualToDate:date]) {
                        cellState = ZBJCalendarCellStateSelectedStart;
                    } else if ([self.endDate isEqualToDate:date]) {
                        cellState = ZBJCalendarCellStateSelectedEnd;
                    } else if (self.startDate && self.endDate &&
                               [[date dateByAddingTimeInterval:86400.0 - 1] compare:self.endDate] == NSOrderedAscending &&
                               [date compare:self.startDate] == NSOrderedDescending) {
                        
                        cellState = ZBJCalendarCellStateSelectedMiddle;
                    } else {
                        if (isAvaible) {
                            cellState = ZBJCalendarCellStateAvaible;
                        } else {
                            cellState = ZBJCalendarCellStateUnavaible;
                        }
                    }
                    break;
                }
                default: {
                    
                    if (isAvaible) {
                        cellState = ZBJCalendarCellStateAvaible;
                    } else {
                        cellState = ZBJCalendarCellStateUnavaible;
                    }
                    break;
                }
                    
                    
            }
        }
    } else {
        cellState = ZBJCalendarCellStateEmpty;
    }
    
    
    cell.price = price;
    cell.cellState = cellState;
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectionMode == ZBJSelectionModeRange) {
        NSDate *date = [NSDate dateAtIndexPath:indexPath firstDate:self.firstDate];
        
        if (date) {

            // 日期在今天之前
            // 先取到当天的最后一秒: xxxx-xx-xx 23:59:59
            if ([[date dateByAddingTimeInterval:86400.0 - 1] compare:[NSDate date] ] == NSOrderedAscending) {
                return NO;
            }

            switch (self.selectedState) {
                case ZBJCalendarStateSelectedStart: {
                    // self.startDate && !self.endDate && 结束日期 < 起始日期
                    if ([date compare:self.startDate] == NSOrderedAscending) {
                        return NO;
                    }
                    
                    // 暂时可选集合中如果包涵此日期，那么可选
//                    if ([self.tempAvaibleDates containsObject:date]) {
//                        return YES;
//                    }
                    // 如果最近的不可选日期等于此日期，那么可选
                    if ([self.nearestUnavaibleDate isEqualToDate:date]) {
                        return YES;
                    }
                    
                    // 暂时不可选集合包涵次日期，那么不可选
                    if ([self.tempUnavaibleDates containsObject:date]) {
                        return NO;
                    }
                    
                    if (self.nearestUnavaibleDate &&
                        [date compare:self.nearestUnavaibleDate] == NSOrderedDescending) {
                        return NO;
                    }
                    
                    // 如果不满足上面的条件，那么根据data中的avaible来判断是否可选
                    ZBJOfferDay *day = [self offerDateWithDate:date];
                    if (day) {
                        return [day.available boolValue];
                    }
                    break;
                }
                case ZBJCalendarStateSelectedRange: {
//                    // 暂时可选集合中如果包涵此日期，那么可选
//                    if ([self.tempAvaibleDates containsObject:date]) {
//                        return NO;
//                    }
                    if ([self.nearestUnavaibleDate isEqualToDate:date]) {
                        return NO;
                    }
                    break;
                }
                default:
                    break;
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
                self.selectedState = ZBJCalendarStateSelectedStart;
            } else if (!self.endDate) {
                
                if ([self.startDate isEqualToDate:date]) {
                    self.selectedState = ZBJCalendarStateSelectedNone;
                    return;
                }
                
                self.endDate = date;
                self.selectedState = ZBJCalendarStateSelectedRange;
            } else {
                self.startDate = date;
                self.selectedState = ZBJCalendarStateSelectedStart;
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



#pragma mark - events 
- (void)reset {
    self.startDate = nil;
    self.endDate = nil;
    [self.collectionView reloadData];
    self.collectionView.allowsSelection = YES;
}

- (ZBJOfferDay *)offerDateWithDate:(NSDate *)date {
    for (ZBJOfferDay *day in self.dates) {
        if ([day.date isEqualToDate:date]) {
            return day;
            break;
        }
    }
    return nil;
}

// 计算开始日期之后最近的不可选日期
- (NSDate *)findTheNearestUnavaibleDateByStartDate:(NSDate *)date {
    NSDate *nextDate = [date dateByAddingTimeInterval:86400.0];
    ZBJOfferDay *theDay = [self offerDateWithDate:nextDate];
    if (theDay) {
        if (![theDay.available boolValue]) {
            return nextDate;
        } else {
            return [self findTheNearestUnavaibleDateByStartDate:nextDate];
        }
    }
    return nil;
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

- (void)setSelectedState:(ZBJCalendarSelectedState)selectedState {
    _selectedState = selectedState;
    switch (_selectedState) {
        case ZBJCalendarStateSelectedNone: {
            [self reset];
            break;
        }
        case ZBJCalendarStateSelectedStart: {
            
            self.endDate = nil;
//            [self.tempAvaibleDates removeAllObjects];
            [self.tempUnavaibleDates removeAllObjects];
            self.nearestUnavaibleDate = nil;
            
            [self.collectionView reloadData];
            
            // calculate avaible `endDate` based `startDate`.
            // - the days in `minNights` from `startDate` has days unavaible.
            for (int i = 1; i < self.minNights; i++) {
                NSDate *theDate = [self.startDate dateByAddingTimeInterval:(i * 24 * 60 * 60)];
                // find the data about `theDate` and deal.
                ZBJOfferDay *day = [self offerDateWithDate:theDate];
                if (!day.available.boolValue) {
                    self.collectionView.allowsSelection = NO;
                    [self performSelector:@selector(reset) withObject:nil afterDelay:0.8];
                    return;
                }
            }
            
            // - if the result day of `startDate` plus `minNights` is unavaible, set is avaible.
//            NSDate *theDate = [self.startDate dateByAddingTimeInterval:(self.minNights * 24 * 60 * 60)];
//            ZBJOfferDay *day = [self offerDateWithDate:theDate];
//            if (!day.available.boolValue) {
//                // 这里只需要刷新一个cell ？
//                [self.tempAvaibleDates addObject:theDate];
//            }
        
            // - set the day between and `startDate` and `minNights` unavaible.
            for (int i = 1; i < self.minNights; i++) {
                NSDate *theDate = [self.startDate dateByAddingTimeInterval:(i * 24 * 60 * 60)];
                [self.tempUnavaibleDates addObject:theDate];
            }
            
            
            // - 计算起始日期之后最近的不可选日期
            self.nearestUnavaibleDate = [self findTheNearestUnavaibleDateByStartDate:self.startDate];
            
            [self.collectionView reloadData];
            
            break;
        }
        case ZBJCalendarStateSelectedRange: {
            
         
            
            [self.collectionView reloadData];
            break;
        }
        default:
            break;
    }
}

@end
