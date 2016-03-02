//
//  ZBJCalendarView.m
//  ZBJCalendar
//
//  Created by wanggang on 2/24/16.
//  Copyright © 2016 ZBJ. All rights reserved.
//

#import "ZBJCalendarView.h"
#import "ZBJCalendarSectionHeader.h"
#import "ZBJCalendarCell.h"
#import "ZBJCalendarHeaderView.h"
#import "ZBJCalendarSingleDelegate.h"
#import "ZBJCalendarMultiDelegate.h"
#import "ZBJCalendarDataSource.h"
#import "ZBJCalendarContinuousDataSource.h"

static NSString * const headerIdentifier = @"header";

@interface ZBJCalendarView()

@property (nonatomic, strong) ZBJCalendarHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) id<UICollectionViewDataSource> collectionDataSource;
@property (nonatomic, strong) id<UICollectionViewDelegate> collectionDelegate;

@end



@implementation ZBJCalendarView

#pragma  mark - Override

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self addSubview:self.headerView];
    }
    return self;
}

- (void)setContinuous:(BOOL)continuous {
    _continuous = continuous;
    if (_continuous) {
        _collectionDataSource = [ZBJCalendarContinuousDataSource new];
    } else {
        _collectionDataSource = [ZBJCalendarDataSource new];
    }
    
    [_collectionDataSource performSelector:@selector(setFirstDate:) withObject:self.firstDate];
    [_collectionDataSource performSelector:@selector(setLastDate:) withObject:self.lastDate];
    [_collectionDataSource performSelector:@selector(setSelectedDate:) withObject:self.selectedDate];

    self.collectionView.dataSource = _collectionDataSource;
}

- (void)setSelectedType:(ZBJCalendarSelectedType)selectedType {
    _selectedType = selectedType;
    if (_selectedType == ZBJCalendarSelectedTypeMulti) {
        _collectionDelegate = [ZBJCalendarMultiDelegate new];
        self.collectionView.allowsMultipleSelection = YES;
    } else {
        _collectionDelegate = [ZBJCalendarSingleDelegate new];
    }
    [_collectionDelegate performSelector:@selector(setFirstDate:) withObject:self.firstDate];
    self.collectionView.delegate = _collectionDelegate;

    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerView.frame = CGRectMake(0, 64, CGRectGetWidth(self.frame), 20);
    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}







#pragma mark - getters

- (ZBJCalendarHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[ZBJCalendarHeaderView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.frame), 20)];
    }
    return _headerView;
}



- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZBJCalendarCell class] forCellWithReuseIdentifier:@"identifier"];
        [_collectionView registerClass:[ZBJCalendarSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    }
    return _collectionView;
}
@end
