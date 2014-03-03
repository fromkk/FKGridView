//
//  fkGridView.m
//  fkGridView
//
//  Created by Ueoka Kazuya on 2014/03/02.
//  Copyright (c) 2014年 fromKK. All rights reserved.
//

#import "FKGridView.h"

#define FKGridViewDefaultPadding 5.0f

@interface FKGridView ()

- (void)initialize;

@end

@implementation FKGridView

- (void)dealloc
{
    _itemViews = nil;
    
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
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
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    int loopCount   = 0;
    float maxWidth  = 0.0f;
    float maxHeight = 0.0f;
    float minHeight = 0.0f;
    float minWidth  = 0.0f;
    CGRect lastFrame;
    
    for (UIView *view in _itemViews) {
        CGRect itemFrame = view.frame;
        
        if ( 0 == loopCount ) {
            itemFrame.origin.x = self.padding;
            itemFrame.origin.y = self.padding;
        } else {
            
            if ( CGRectGetMaxX(lastFrame) + itemFrame.size.width + self.padding * 2.0f > self.frame.size.width ) {
                //横幅超えると次の段へ
                
                
            } else {
                //それ以外は横へスタック
                
                
            }
        }
        
        if (0.0f == minHeight) {
            minHeight = CGRectGetMaxY(itemFrame);
        } else {
            
        }
        
        if ( 0.0f == minWidth ) {
            minWidth = CGRectGetMaxX(itemFrame);
        }
        
        if ( CGRectGetMaxX(itemFrame) > maxWidth ) {
            maxWidth = CGRectGetMaxX(itemFrame);
        }
        
        if ( CGRectGetMaxY(itemFrame) > maxHeight ) {
            maxHeight = CGRectGetMaxY(itemFrame);
        }
        
        view.frame = itemFrame;
        lastFrame  = itemFrame;
        
        loopCount++;
    }
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
