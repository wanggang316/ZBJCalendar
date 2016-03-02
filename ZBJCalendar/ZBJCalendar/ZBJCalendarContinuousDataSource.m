//
//  ZBJCalendarDataSource.m
//  ZBJCalendar
//
//  Created by wanggang on 3/1/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarContinuousDataSource.h"
#import "ZBJCalendarSectionHeader.h"
#import "ZBJCalendarCell.h"
#import "NSDate+ZBJAddition.h"
#import "NSDate+IndexPath.h"

static NSString * const headerIdentifier = @"header";

@implementation ZBJCalendarContinuousDataSource


#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [NSDate numberOfDaysFromMonth:self.firstDate toMonth:self.lastDate];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZBJCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
    cell.firstDayShowMonth = YES;
    cell.day = [NSDate dateAtIndexPath:indexPath firstDate:self.firstDate];

    if ([collectionView.delegate respondsToSelector:@selector(fromIndexPath)]) {
        cell.selected = [[collectionView.delegate performSelector:@selector(fromIndexPath) withObject:nil]  isEqual:indexPath];
    }
    if ([collectionView.delegate respondsToSelector:@selector(toIndexPath)]) {
        cell.selected = [[collectionView.delegate performSelector:@selector(toIndexPath) withObject:nil]  isEqual:indexPath];
    }
    
    
    return cell;
}




@end
