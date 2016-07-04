//
//  ZBJMutipleSelectionCell.h
//  ZBJCalendar
//
//  Created by wanggang on 7/4/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CF_ENUM(NSInteger, ZBJCalendarCellState) {
    ZBJCalendarCellStateEmpty,
    ZBJCalendarCellStateNormal,
    ZBJCalendarCellStateSelected,
};

@interface ZBJSimpleMutipleSelectionCell : UICollectionViewCell

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) ZBJCalendarCellState cellState;

@end
