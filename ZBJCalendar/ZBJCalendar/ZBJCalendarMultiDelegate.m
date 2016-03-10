//
//  ZBJCalendarMultiDelegate.m
//  ZBJCalendar
//
//  Created by wanggang on 2/29/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarMultiDelegate.h"
#import "ZBJCalendarSectionHeader.h"
#import "NSDate+IndexPath.h"
#import "NSDate+ZBJAddition.h"

static NSString * const headerIdentifier = @"header";

@interface ZBJCalendarMultiDelegate()


@end

@implementation ZBJCalendarMultiDelegate

#pragma mark UICollectionViewDelegateFlowLayout

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
    if (!self.fromIndexPath) {
        self.fromIndexPath = indexPath;
        NSLog(@"=====> start date is : %@", date);
    } else if(!self.toIndexPath) {
        self.toIndexPath = indexPath;
        NSLog(@"=====> to date is : %@", date);
    } else if (self.fromIndexPath && self.toIndexPath) {
        
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
}

@end
