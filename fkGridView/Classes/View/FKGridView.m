//
//  fkGridView.m
//  fkGridView
//
//  Created by Ueoka Kazuya on 2014/03/02.
//  Copyright (c) 2014年 fromKK. All rights reserved.
//

#import "FKGridView.h"

#define FKGridViewDefaultPadding 5.0f
#define FKGridViewDefaultCols    2
#define FKGridViewDefaultAutoresizeWidth NO

@interface FKGridView ()

- (void)initialize;

@end

@implementation FKGridView

- (void)dealloc
{
    _itemViews = nil;
    
    for (int i = 0; i < _itemViews.count; i++) {
        UIView *itemView = [_itemViews objectAtIndex:i];
        [itemView removeFromSuperview];
        itemView = nil;
        
        [_itemViews removeObjectAtIndex:i];
    }
}

- (id)init {
    self = [super init];
    
    if ( self ) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _itemViews = [[NSMutableArray alloc] init];
    self.padding = FKGridViewDefaultPadding;
    self.cols    = FKGridViewDefaultCols;
    self.autoresizeWidth = FKGridViewDefaultAutoresizeWidth;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    int loopCount   = 0;
    int currentCol  = 0;
    int currentRow  = 0;
    
    NSMutableDictionary *heights = [NSMutableDictionary dictionary];
    
    CGRect lastFrame;
    NSString *key;
    NSString *lastKey;
    
    CGFloat maxHeight = 0.0f;
    
    for (UIView *view in _itemViews) {
        CGRect itemFrame = view.frame;
        
        currentCol = loopCount % self.cols;
        currentRow = 0 == loopCount ? 0 : (int)ceil(loopCount / self.cols);
        
        key = [NSString stringWithFormat:@"%d-%d", currentCol, currentRow];
        
        itemFrame.origin.x = self.padding * (currentCol + 1) + ((self.frame.size.width - (self.padding * (self.cols + 1))) / self.cols) * currentCol;
        
        if ( self.autoresizeWidth ) {
            itemFrame.size.width = (self.frame.size.width - self.padding * (self.cols + 1)) / self.cols;
        }
        
        if ( currentRow == 0 ) {
            itemFrame.origin.y = self.padding;
        } else {
            lastKey = [NSString stringWithFormat:@"%d-%d", currentCol, currentRow - 1];
            
            itemFrame.origin.y = [[heights objectForKey:lastKey] floatValue] + self.padding;
            
            lastKey = nil;
        }
        
        [heights setObject:@(CGRectGetMaxY(itemFrame)) forKey:key];
        
        key = nil;
        
        view.frame = itemFrame;
        lastFrame  = itemFrame;
        
        if ( CGRectGetMaxY(lastFrame) > maxHeight ) {
            maxHeight = CGRectGetMaxY(lastFrame);
        }
        loopCount++;
    }
    heights = nil;
    
    self.contentSize = CGSizeMake(self.frame.size.width, maxHeight + self.padding);
}

- (void)setGridItemViews:(NSArray *)views {
    [_itemViews setArray:views];
    
    for (UIView *view in views) {
        [self addSubview:view];
    }
    [self setNeedsLayout];
}

- (void)addGridItemView:(UIView *)view {
    [_itemViews addObject:view];
    
    [self addSubview:view];
    
    [self setNeedsLayout];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
