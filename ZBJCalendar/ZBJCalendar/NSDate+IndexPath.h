//
//  NSDate+IndexPath.h
//  ZBJCalendar
//
//  Created by wanggang on 2/29/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This category provide methods used to corresponding relations between indexpath and date.
 */
@interface NSDate (IndexPath)

+ (NSDate *)dateForFirstDayInSection:(NSInteger)section firstDate:(NSDate *)firstDate;
+ (NSDate *)dateAtIndexPath:(NSIndexPath *)indexPath firstDate:(NSDate *)firstDate;

@end
