//
//  fkGridView.h
//  fkGridView
//
//  Created by Ueoka Kazuya on 2014/03/02.
//  Copyright (c) 2014年 fromKK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKGridView : UIScrollView

@property (nonatomic, strong, readonly) NSMutableArray *itemViews;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) NSInteger cols;
@property (nonatomic, assign) BOOL autoresizeWidth;

- (void)addGridItemView:(UIView *)view;
- (void)addGridItemView:(UIView *)view animated:(BOOL)animated;
- (void)setGridItemViews:(NSArray *)views;
- (void)setGridItemViews:(NSArray *)views animated:(BOOL)animated;
- (void)clearGridItems;

@end
