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
    
    if (!self.fromIndexPath || !self.toIndexPath) {
        return YES;
    }
    return NO;
    
//    if ([self.fromIndexPath isEqual:indexPath] ||
//        [self.toIndexPath isEqual:indexPath]) {
//        return NO;
//    }
//    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (![self.fromIndexPath isEqual:indexPath]) {
        return YES;
//    }
//    return NO;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    ZBJCalendarCell *cell = (ZBJCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.selected = YES;
    
    if (!self.fromIndexPath) {
        self.fromIndexPath = indexPath;
    } else if(!self.toIndexPath) {
        self.toIndexPath = indexPath;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    ZBJCalendarCell *cell = (ZBJCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.selected = NO;
}

@end
