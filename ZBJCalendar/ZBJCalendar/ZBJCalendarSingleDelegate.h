//
//  ZBJCalendarSingleDelegate.h
//  ZBJCalendar
//
//  Created by wanggang on 2/29/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBJCalendarSingleDelegate : NSObject <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSDate *firstDate;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end
