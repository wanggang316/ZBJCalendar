//
//  ZBJCalendarView.h
//  ZBJCalendar
//
//  Created by wanggang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBJOfferCalendar.h"

typedef CF_ENUM(NSInteger, ZBJSelectionMode) {
    ZBJSelectionModeNone,
    ZBJSelectionModeSingle,
    ZBJSelectionModeRange,
};

@protocol ZBJCalendarDelegate;

@interface ZBJCalendarView : UIView

@property (nonatomic, weak) id<ZBJCalendarDelegate> delegate;

@property (nonatomic, strong) NSDate *firstDate;
@property (nonatomic, strong) NSDate *lastDate;

@property (nonatomic, strong) NSSet *dates;

@property (nonatomic, assign) ZBJSelectionMode selectionMode;  // default is `YES`, select `startDate` and `endDate`
@property (nonatomic, assign) UIEdgeInsets contentInsets;   // the inner padding

@property (nonatomic, assign) NSInteger minNights; // 最小入住天数
@end



@protocol ZBJCalendarDelegate <NSObject>



@end
