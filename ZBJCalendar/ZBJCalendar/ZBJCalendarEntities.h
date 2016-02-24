//
//  ZBJCalendarItem.h
//  ZBJCalendar
//
//  Created by wanggang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBJMonth : NSObject

@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSArray *days;

@end


@interface ZBJDay : NSObject

@property (nonatomic, strong) NSString *day;
@property (nonatomic, assign) BOOL selectable;  // 不可选， 可选
@property (nonatomic, assign, getter=isSelected) BOOL selected; // 选中
@property (nonatomic, assign) BOOL isToday;     // 当天

@end
