/**
 
 Simple Tile View: TileContainerView
 
 Created by SoleilPQD on 10 Oct 2012.
 Copyright © 2012 Runsytem.vn
 
 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 3 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

#import "TileContainerView.h"
#import <objc/runtime.h>

@interface UIView (tileview)

@property ( nonatomic, retain ) NSString *identifier;

@end

NSString * const kTileCellIdentifierPropertyKey = @"kTileCellIdentifierPropertyKey";

@implementation UIView (tileview)
@dynamic identifier;

- ( void )setIdentifier:(NSString *)identifier {
    objc_setAssociatedObject(self, kTileCellIdentifierPropertyKey, identifier, OBJC_ASSOCIATION_RETAIN );
}

- ( NSString* )identifier {
    return objc_getAssociatedObject( self, kTileCellIdentifierPropertyKey );
}

@end

#pragma mark -
#pragma mark -

#define DEBUG_RECT          0 // draw the visibleRect passed to showViewsInRect
                              // I use cell tag as identifier, calculated from cell row and column as below equation
                              // This makes the number of rows is limited
#define MAX_ROW_CAPACITY    1000 // add 0 to increase rows capacity
#define ID_MAKE(col, row) ( col + 1 ) * MAX_ROW_CAPACITY + ( row + 1 )
// this means the row number taking the 3 lowest digits of the number used as indentifier
// Cell at row 1 column 2 (count from 0) has the id 3002
// Change to this to limit column instead row
//#define ID_MAKE(col, row) ( row + 1 ) * MAX_ROW_CAPACITY + ( col + 1 )

@interface TileContainerView() {
    NSMutableDictionary *_freeViews;
    CGRect _visibleRect;
    NSString *_currentReuseKey;
#if DEBUG_RECT
    CGRect _DebubRect;
#endif
}

@end

@implementation TileContainerView

@synthesize delegate = _delegate;
@synthesize cellSize = _cellSize;

- ( void )removeViewToCache:( UIView* )view {
    if ( view.identifier ) {
        NSMutableArray *cache = [ _freeViews objectForKey:view.identifier ];
        if ( cache == nil ) {
            cache = [[[ NSMutableArray alloc ] init ] autorelease ];
            [ _freeViews setObject:cache forKey:view.identifier ];
        }
        [ cache addObject:view ];
    }
    [ view removeFromSuperview ];
}

- ( UIView* )viewForReuseWithKey:(NSString *)identifier {
    UIView *view = nil;
    if ( _freeViews.count > 0 ) {
        if ( identifier ) {
            NSMutableArray *cache = [ _freeViews objectForKey:identifier ];
            if ( cache ) {
                view = [ cache.lastObject retain ];
                [ cache removeLastObject ];
                if ( cache.count == 0 )
                    [ _freeViews removeObjectForKey:identifier ];
            }
        }
    }
    if ( _currentReuseKey ) [ _currentReuseKey release ];
    _currentReuseKey = [ identifier retain ];
    return view;
}

- ( NSArray* )visibleCells {
    NSInteger firstRow = _visibleRect.origin.y    / _cellSize.height;
    NSInteger firstCol = _visibleRect.origin.x    / _cellSize.width;
    NSInteger lastRow  = _visibleRect.size.height / _cellSize.height + firstRow;
    NSInteger lastCol  = _visibleRect.size.width  / _cellSize.width  + firstCol;
    
    NSMutableArray *listOfView = [[ NSMutableArray alloc ] initWithCapacity:self.subviews.count ];
    for ( NSInteger row = firstRow; row < lastRow; row++  ) {
        for ( NSInteger col = firstCol; col < lastCol; col++ ) {
            NSInteger identifier = ID_MAKE(col, row);
            UIView *aView = [ self viewWithTag:identifier ];
            if ( aView )
                [ listOfView addObject:aView ];
        }
    }
    return [ listOfView autorelease ];
}

- ( void )showViewsInRect:(CGRect)visibleBounds {
//    NSLog( @"Show views in rect %@ / %@", NSStringFromCGRect( visibleBounds ), NSStringFromCGRect( self.bounds ));
    if (!( _cellSize.width > 0 && _cellSize.height > 0 ))
        [ NSException raise:@"Tile Container View setting error"
                     format:@"Cell size not defined" ];
#if DEBUG_RECT
    _DebubRect = visibleBounds;
    [ self setNeedsDisplay ];
#endif
    
    if ( visibleBounds.origin.x < 0 ) visibleBounds.origin.x = 0;
    if ( visibleBounds.origin.y < 0 ) visibleBounds.origin.y = 0;
    if (( visibleBounds.origin.x + visibleBounds.size.width ) > self.bounds.size.width )
        visibleBounds.size.width -= ( visibleBounds.origin.x + visibleBounds.size.width - self.bounds.size.width );
    if (( visibleBounds.origin.y + visibleBounds.size.height ) > self.bounds.size.height )
        visibleBounds.size.height -= ( visibleBounds.origin.y + visibleBounds.size.height - self.bounds.size.height );
    // Get the biggest bounds
    CGFloat tmp = fmod( visibleBounds.origin.x, _cellSize.width );
    if ( tmp > 0 ) {
        visibleBounds.origin.x -= tmp;
        visibleBounds.size.width += tmp;
    }
    tmp = fmod( visibleBounds.origin.y, _cellSize.height );
    if ( tmp > 0 ) {
        visibleBounds.origin.y -= tmp;
        visibleBounds.size.height += tmp;
    }
    tmp = fmodf( visibleBounds.size.width, _cellSize.width );
    if ( tmp > 0 ) {
        visibleBounds.size.width += ( _cellSize.width - tmp );
    }
    tmp = fmodf( visibleBounds.size.height, _cellSize.height );
    if ( tmp > 0 ) {
        visibleBounds.size.height += ( _cellSize.height - tmp );
    }
    
    if (( visibleBounds.origin.x + visibleBounds.size.width ) > self.bounds.size.width ) {
        while (( visibleBounds.origin.x + visibleBounds.size.width ) > self.bounds.size.width )
            visibleBounds.size.width -= _cellSize.width;
        visibleBounds.size.width += _cellSize.width;
    }
    if (( visibleBounds.origin.y + visibleBounds.size.height ) > self.bounds.size.height ) {
        while (( visibleBounds.origin.y + visibleBounds.size.height ) > self.bounds.size.height )
            visibleBounds.size.height -= _cellSize.height;
        visibleBounds.size.height += _cellSize.height;
    }
    
    if ( CGRectEqualToRect( visibleBounds, _visibleRect ))
        return;
    
    _visibleRect = visibleBounds;
//    NSLog( @"Last rect %@", NSStringFromCGRect( visibleBounds ));
    
    // Remove invisible view
    for ( UIView *view in self.subviews ) {
        if ( !CGRectIntersectsRect( view.frame, visibleBounds )) {
            [ self removeViewToCache:view ];
            [ view removeFromSuperview ];
        }
    }
    
    NSInteger firstRow = visibleBounds.origin.y    / _cellSize.height;
    NSInteger firstCol = visibleBounds.origin.x    / _cellSize.width;
    NSInteger lastRow  = visibleBounds.size.height / _cellSize.height + firstRow;
    NSInteger lastCol  = visibleBounds.size.width  / _cellSize.width  + firstCol;
    
//    NSLog( @"1st row %i last row %i", firstRow, lastRow );
//    NSLog( @"1st col %i last col %i", firstCol, lastCol );
    
    for ( NSInteger row = firstRow; row < lastRow; row++  ) {
        for ( NSInteger col = firstCol; col < lastCol; col++ ) {
            NSInteger identifier = ID_MAKE(col, row);
            UIView *aView = [ self viewWithTag:identifier ];
            if ( aView == nil ) {
                if ( _delegate && [ _delegate respondsToSelector:@selector( tileContainerView:viewForRow:andColumn: )]) {
                    aView = [ _delegate tileContainerView:self viewForRow:row andColumn:col ];
                    aView.identifier = _currentReuseKey;
                } else {
                    [ NSException raise:@"Tile Container View data source error"
                                 format:@"Delegate not found or the data source function not implemented" ];
                }
                if ( aView != nil ) {
//                    NSLog( @"Handle cell %i %i begin", row, col );
#if DEBUG_RECT
                    aView.backgroundColor = [ aView.backgroundColor colorWithAlphaComponent:0.5 ];
#endif
                    aView.frame = CGRectMake( col * _cellSize.width, row * _cellSize.height, _cellSize.width, _cellSize.height );
                    aView.tag = identifier;
//                    NSLog( @"Handle cell %i %i in progress", row, col );
                    [ self addSubview:aView ];
//                    NSLog( @"Add cell %i done", identifier );
                }
            }
//            NSLog( @"Handle cell %i %i done", row, col );
        }
    }
//    NSLog( @"Fill view in rect %@ done", NSStringFromCGRect( visibleBounds ));
}

- ( void )reArrangeInRect:( CGRect )visibleBounds withAnimation:( CGFloat )animDuration {
    if ( CGRectIsEmpty( _visibleRect )) {
        [ self showViewsInRect:visibleBounds ];
        return;
    }
    if (!( _cellSize.width > 0 && _cellSize.height > 0 ))
        [ NSException raise:@"Tile Container View setting error"
                     format:@"Cell size not defined or invalid" ];   
    // Get the current cell
    NSInteger firstRow = _visibleRect.origin.y    / _cellSize.height;
    NSInteger firstCol = _visibleRect.origin.x    / _cellSize.width;
    NSInteger lastRow  = _visibleRect.size.height / _cellSize.height + firstRow;
    NSInteger lastCol  = _visibleRect.size.width  / _cellSize.width  + firstCol;
    
//    NSLog( @"Old rect %@", NSStringFromCGRect( _visibleRect ));
//    NSLog( @"Old row %i - %i", firstRow, lastRow );
//    NSLog( @"Old col %i - %i", firstCol, lastCol );
    
    NSMutableArray *listOfView = [[ NSMutableArray alloc ] initWithCapacity:self.subviews.count ];
    for ( NSInteger row = firstRow; row < lastRow; row++  ) {
        for ( NSInteger col = firstCol; col < lastCol; col++ ) {
            NSInteger identifier = ID_MAKE(col, row);
            UIView *aView = [ self viewWithTag:identifier ];
            NSLog( @"Old view for id %i is %i", identifier, aView.tag );
            if ( aView )
                [ listOfView addObject:aView ];
        }
    }
    
#if DEBUG_RECT
    _DebubRect = visibleBounds;
    [ self setNeedsDisplay ];
#endif
    // Get the biggest bounds
    CGFloat tmp = fmod( visibleBounds.origin.x, _cellSize.width );
    if ( tmp > 0 ) {
        visibleBounds.origin.x -= tmp;
        visibleBounds.size.width += tmp;
    }
    tmp = fmod( visibleBounds.origin.y, _cellSize.height );
    if ( tmp > 0 ) {
        visibleBounds.origin.y -= tmp;
        visibleBounds.size.height += tmp;
    }
    tmp = fmodf( visibleBounds.size.width, _cellSize.width );
    if ( tmp > 0 ) {
        visibleBounds.size.width += ( _cellSize.width - tmp );
    }
    tmp = fmodf( visibleBounds.size.height, _cellSize.height );
    if ( tmp > 0 ) {
        visibleBounds.size.height += ( _cellSize.height - tmp );
    }
    
    if ( animDuration > 0 ) {
        [ UIView beginAnimations:@"TileViewRearrange" context:NULL ];
        [ UIView setAnimationDuration:animDuration ];
    }
    _visibleRect = visibleBounds;
    
    firstRow = visibleBounds.origin.y    / _cellSize.height;
    firstCol = visibleBounds.origin.x    / _cellSize.width;
    lastRow  = visibleBounds.size.height / _cellSize.height + firstRow;
    lastCol  = visibleBounds.size.width  / _cellSize.width  + firstCol;
    
    for ( NSInteger row = firstRow; row < lastRow; row++  ) {
        for ( NSInteger col = firstCol; col < lastCol; col++ ) {
            NSInteger identifier = ID_MAKE(col, row);
            UIView *aView = nil;
            if ( listOfView.count > 0 ) {
                aView = [ listOfView objectAtIndex:0 ];
                [ listOfView removeObjectAtIndex:0 ];
            }
            if ( aView == nil ) { // not enough views ready to fill, create new
                if ( _delegate && [ _delegate respondsToSelector:@selector( tileContainerView:viewForRow:andColumn: )]) {
                    aView = [ _delegate tileContainerView:self viewForRow:row andColumn:col ];
                    aView.identifier = _currentReuseKey;
                } else {
                    [ NSException raise:@"Tile Container View data source error"
                                 format:@"Delegate not found or the data source function not implemented" ];
                }
                if ( aView != nil )
                    [ self addSubview:aView ];
            }
            if ( aView != nil ) {
#if DEBUG_RECT
                aView.backgroundColor = [ aView.backgroundColor colorWithAlphaComponent:0.5 ];
#endif
                aView.frame = CGRectMake( col * _cellSize.width, row * _cellSize.height, _cellSize.width, _cellSize.height );
                aView.tag = identifier;
            }
        }
    }
    
    if ( animDuration > 0 ) {
        [ UIView commitAnimations ];
    }
    // remove unused views
    for ( UIView *view in listOfView ) {
        [ self removeViewToCache:view ];
    }
    [ listOfView removeAllObjects ];
    [ listOfView release ];
}

#pragma mark - Life cylce

- ( void )settingMeUp {
    _freeViews = [[ NSMutableDictionary alloc ] init ];
    self.clipsToBounds = YES;
    self.backgroundColor = [ UIColor clearColor ];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [ self settingMeUp ];
    }
    return self;
}

- ( void )awakeFromNib {
    [ super awakeFromNib ];
    [ self settingMeUp ];
}

- ( void )dealloc {
    [ _freeViews release ];
    [ _delegate release ];
    [ super dealloc ];
}

#if DEBUG_RECT

- ( void )setBounds:(CGRect)bounds {
    [ super setBounds:bounds ];
    [ self setNeedsDisplay ];
}

- ( void )setFrame:(CGRect)frame {
    [ super setFrame:frame ];
    [ self setNeedsDisplay ];
}

- ( void )drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor( context, [[ UIColor redColor ] CGColor ]);
    CGContextSetLineWidth( context, 2.0 );
    CGContextStrokeRect( context, _DebubRect );
}
#endif

@end
