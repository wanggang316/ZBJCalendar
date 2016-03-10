//
//  ZBJCalendarSingleDelegate.m
//  ZBJCalendar
//
//  Created by wanggang on 2/29/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarSingleDelegate.h"
#import "NSDate+ZBJAddition.h"
#import "ZBJCalendarSectionHeader.h"
#import "NSDate+IndexPath.h"

static NSString * const headerIdentifier = @"header";

@interface ZBJCalendarSingleDelegate()

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation ZBJCalendarSingleDelegate

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    [collectionView.dataSource numberOfSectionsInCollectionView:collectionView];
    CGFloat w = collectionView.bounds.size.width;
    return CGSizeMake(w, 60);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = collectionView.bounds.size.width;
    CGFloat cellWidth = (w - 6) / 7;
    return CGSizeMake(cellWidth, cellWidth);
}


#pragma mark - UICollectionViewDelegate


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectedIndexPath isEqual:indexPath]) {
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndexPath = indexPath;
    
    NSDate *date = [NSDate dateAtIndexPath:indexPath firstDate:self.firstDate];
    self.selectedDate = date;
    NSLog(@"----> selected date is : %@", date);
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

}



@end
