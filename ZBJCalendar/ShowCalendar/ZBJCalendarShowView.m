//
//  ZBJOfferCalendarView.m
//  ZBJCalendar
//
//  Created by wanggang on 3/15/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarShowView.h"
#import "ZBJCalendar.h"
#import "ZBJCalendarShowDelegate.h"
#import "ZBJCalendarShowCell.h"
#import "ZBJCalendarSectionHeader.h"
#import "ZBJCalendarSectionFooter.h"

@interface ZBJCalendarShowView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) ZBJCalendarView *calendarView;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) ZBJCalendarShowDelegate *delegate;

@end

@implementation ZBJCalendarShowView

- (instancetype)initWithFrame:(CGRect)frame offerCal:(ZBJOfferCalendar *)offerCal {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        
        [self addSubview:self.backView];
        
        self.offerCal = offerCal;

    }
    return self;
}


- (void)setOfferCal:(ZBJOfferCalendar *)offerCal {
    _offerCal = offerCal;
    self.calendarView.firstDate = self.offerCal.startDate;
    self.calendarView.lastDate = self.offerCal.endDate;
    
    self.delegate = [[ZBJCalendarShowDelegate alloc] init];
    self.delegate.offerCal = self.offerCal;
    self.calendarView.delegate = self.delegate;
    self.calendarView.dataSource = self.delegate;
}

- (void)cancel:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.cancelButton.center = CGPointMake(self.backView.frame.size.width/2, CGRectGetHeight(self.backView.frame) - 15 - 13);
}

#pragma mark -
- (ZBJCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[ZBJCalendarView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLable.frame) + 17, CGRectGetWidth(self.backView.frame), CGRectGetHeight(self.backView.frame) - CGRectGetMaxY(self.titleLable.frame) - 17 - 55)];
        [_calendarView registerCellClass:[ZBJCalendarShowCell class] withReuseIdentifier:@"cell"];
        [_calendarView registerSectionHeader:[ZBJCalendarSectionHeader class] withReuseIdentifier:@"sectionHader"];
        [_calendarView registerSectionFooter:[ZBJCalendarSectionFooter class] withReuseIdentifier:@"sectionFooter"];
        _calendarView.selectionMode = ZBJSelectionModeDisable;
        _calendarView.contentInsets = UIEdgeInsetsMake(0, 16, 0, 16);
        _calendarView.sectionHeaderHeight = 52;
        _calendarView.sectionFooterHeight = 13;
    }
    return _calendarView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(15, 40, CGRectGetWidth(self.frame) - 30, CGRectGetHeight(self.frame) - 70)];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 3;
        _backView.clipsToBounds = YES;
        
        [_backView addSubview:self.titleLable];
        [_backView addSubview:self.calendarView];
        [_backView addSubview:self.cancelButton];
    }
    return _backView;
}

- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(25, 25, 200, 20)];
        _titleLable.font = [UIFont systemFontOfSize:20];
        _titleLable.text = @"可租价格日历";
    }
    return _titleLable;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(self.backView.frame.size.width/2 - 12,  CGRectGetHeight(self.backView.frame) - 15 - 25, 25, 25);
        [_cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
