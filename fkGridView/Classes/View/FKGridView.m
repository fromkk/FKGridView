//
//  fkGridView.m
//  fkGridView
//
//  Created by Ueoka Kazuya on 2014/03/02.
//  Copyright (c) 2014年 fromKK. All rights reserved.
//

#import "FKGridView.h"

#define FKGridViewDefaultPadding  5.0f
#define FKGridViewDefaultCols     2
#define FKGridViewDefaultAutoresizeWidth NO

@interface FKGridView () {
    BOOL _animated;
    NSMutableDictionary *_heights;
    NSTimer *timer;
    NSInteger animatedCount;
    NSMutableArray *stack;
}

- (void)initialize;
- (void)fire:(NSTimer *)timer;

@end

@implementation FKGridView

- (void)dealloc
{
    if ( [timer isValid]) {
        [timer invalidate];
    }
    timer = nil;
    
    self.delegate = nil;
    _itemViews = nil;
    _heights = nil;
    stack = nil;
    
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

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.contentSize = frame.size;
}

- (void)initialize {
    _animated            = NO;
    _itemViews           = [[NSMutableArray alloc] init];
    _heights             = [[NSMutableDictionary alloc] init];
    self.padding         = FKGridViewDefaultPadding;
    self.cols            = FKGridViewDefaultCols;
    self.autoresizeWidth = FKGridViewDefaultAutoresizeWidth;
    timer                = nil;
    animatedCount        = 0;
    stack                = [[NSMutableArray alloc] init];
    
    self.contentSize     = self.frame.size;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ( _animated ) {
        int loopCount   = 0;
        int currentCol  = 0;
        int currentRow  = 0;
        
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
                
                itemFrame.origin.y = [[_heights objectForKey:lastKey] floatValue] + self.padding;
                
                lastKey = nil;
            }
            
            if ( nil == [_heights objectForKey:key] || NO == [[_heights objectForKey:key] isEqualToNumber:@(CGRectGetMaxY(itemFrame))] ) {
                [_heights setObject:@(CGRectGetMaxY(itemFrame)) forKey:key];
            }
            
            key = nil;
            
            view.frame = itemFrame;
            lastFrame  = itemFrame;
            
            if ( CGRectGetMaxY(lastFrame) > maxHeight ) {
                maxHeight = CGRectGetMaxY(lastFrame);
            }
            loopCount++;
        }
        
        self.contentSize = CGSizeMake(self.frame.size.width, maxHeight + self.padding);
    }
}

- (void)setGridItemViews:(NSArray *)views {
    [self setGridItemViews:views animated:NO];
}

- (void)setGridItemViews:(NSArray *)views animated:(BOOL)animated {
    for (UIView *view in views) {
        [self addGridItemView:view animated:animated];
    }
}

- (void)addGridItemView:(UIView *)view {
    [self addGridItemView:view animated:NO];
}

- (void)addGridItemView:(UIView *)view animated:(BOOL)animated {
    [_itemViews addObject:view];
    
    int currentCol  = (_itemViews.count - 1) % self.cols;
    int currentRow  = _itemViews.count == 1 ? 0 : (int)ceil((_itemViews.count - 1) / self.cols);
    
    NSString *key = [NSString stringWithFormat:@"%d-%d", currentCol, currentRow];
    
    CGRect itemFrame = view.frame;
    itemFrame.origin.x = self.padding * (currentCol + 1) + ((self.frame.size.width - (self.padding * (self.cols + 1))) / self.cols) * currentCol;
    
    if ( self.autoresizeWidth ) {
        itemFrame.size.width = (self.frame.size.width - self.padding * (self.cols + 1)) / self.cols;
    }
    
    if ( currentRow == 0 ) {
        itemFrame.origin.y = self.padding;
    } else {
        NSString *lastKey = [NSString stringWithFormat:@"%d-%d", currentCol, currentRow - 1];
        
        itemFrame.origin.y = [[_heights objectForKey:lastKey] floatValue] + self.padding;
        
        lastKey = nil;
    }
    
    if ( nil == [_heights objectForKey:key] || NO == [[_heights objectForKey:key] isEqualToNumber:@(CGRectGetMaxY(itemFrame))] ) {
        [_heights setObject:@(CGRectGetMaxY(itemFrame)) forKey:key];
    }
    
    key = nil;
    
    if ( animated ) {
        if ( nil == timer ) {
            timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(fire:) userInfo:nil repeats:YES];
        }
        [stack addObject:@{@"view": view, @"frame": NSStringFromCGRect(itemFrame)}];
    } else {
        view.frame = itemFrame;
        [self addSubview:view];
        
        _animated = YES;
        [self setNeedsLayout];
    }
}

- (void)fire:(NSTimer *)_timer {

    if ( 0 == stack.count ) {
        [timer invalidate];
        timer = nil;
        
        _animated = YES;
        
        [self setNeedsLayout];
    } else {
        __weak NSDictionary *item = [stack objectAtIndex:0];
        __weak UIView *view = [item objectForKey:@"view"];
        __block CGRect frame = CGRectFromString([item objectForKey:@"frame"]);
        
        view.frame = CGRectMake(frame.origin.x, self.contentSize.height, frame.size.width, frame.size.height);
        [self addSubview:view];
        [UIView animateWithDuration:0.25f animations:^{
            view.frame = frame;
        }];
        
        [stack removeObjectAtIndex:0];
    }
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
