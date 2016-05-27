//
//  ZBJSingleSelectionCell.h
//  ZBJCalendar
//
//  Created by gumpwang on 5/26/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CF_ENUM(NSInteger, ZBJCalendarCellState) {
    ZBJCalendarCellStateEmpty,
    ZBJCalendarCellStateNormal,
    ZBJCalendarCellStateSelected,
};



@interface ZBJSingleSelectionCell : UICollectionViewCell

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) ZBJCalendarCellState cellState;

@end
