//
//  ZBJCalendarDataSource.h
//  ZBJCalendar
//
//  Created by wanggang on 3/1/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBJCalendarDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong) NSDate *firstDate;
@property (nonatomic, strong) NSDate *lastDate;
@property (nonatomic, strong) NSDate *selectedDate;

@end
