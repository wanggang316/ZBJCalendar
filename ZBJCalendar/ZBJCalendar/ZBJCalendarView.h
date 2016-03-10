//
//  ZBJCalendarView.h
//  ZBJCalendar
//
//  Created by wanggang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZBJCalendarSelectedType) {
    ZBJCalendarSelectedTypeSingle,
    ZBJCalendarSelectedTypeMulti,
};


@protocol ZBJCalendarDelegate;

@interface ZBJCalendarView : UIView

@property (nonatomic, weak) id<ZBJCalendarDelegate> delegate;

@property (nonatomic, strong) NSDate *firstDate;
@property (nonatomic, strong) NSDate *lastDate;

@property (nonatomic, assign) UIEdgeInsets contentInsets;   // the inner padding

@end



@protocol ZBJCalendarDelegate <NSObject>



@end
