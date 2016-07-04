//
//  ZBJMutipleSelectionSectionHeaderView.h
//  ZBJCalendar
//
//  Created by wanggang on 7/4/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ZBJMonthTappedHandler)(NSDate *month);
@interface ZBJMutipleSelectionSectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) NSDate *firstDateOfMonth;
@property (nonatomic, copy) ZBJMonthTappedHandler tapHandler;

@end
