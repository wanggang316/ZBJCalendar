//
//  ZBJOfferCalendarView.h
//  ZBJCalendar
//
//  Created by wanggang on 3/15/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBJOfferCalendar.h"

@interface ZBJOfferCalendarView : UIView

- (instancetype)initWithFrame:(CGRect)frame offerCal:(ZBJOfferCalendar *)offerCal;
@property (nonatomic, strong) ZBJOfferCalendar *offerCal;


@end
