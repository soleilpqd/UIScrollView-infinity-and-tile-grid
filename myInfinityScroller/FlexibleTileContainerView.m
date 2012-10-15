/**
 
 Infinity Tile View: FlexibleTileContainerView
 
 Created by SoleilPQD on 12 Oct 2012.
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

#import "FlexibleTileContainerView.h"
#import <objc/runtime.h>

@interface UIView (infinity)

@property ( nonatomic, retain ) NSString *identifier;
@property ( nonatomic, assign ) NSInteger row;
@property ( nonatomic, assign ) NSInteger col;

@end

NSString * const kRowPropertyKey = @"kRowPropertyKey";
NSString * const kColPropertyKey = @"kColPropertyKey";
NSString * const kInfCellIdPropertyKey = @"kInfCellIdPropertyKey";

@implementation UIView (infinity)
@dynamic row;
@dynamic col;
@dynamic identifier;

- ( void )setCol:(NSInteger)col {
    objc_setAssociatedObject(self, kColPropertyKey, [ NSNumber numberWithInteger:col ], OBJC_ASSOCIATION_RETAIN );
}

- ( NSInteger )col {
    return [ objc_getAssociatedObject( self, kColPropertyKey ) integerValue ];
}

- ( void )setRow:(NSInteger)row {
    objc_setAssociatedObject( self, kRowPropertyKey, [ NSNumber numberWithInteger:row ], OBJC_ASSOCIATION_RETAIN );
}

- ( NSInteger )row {
    return [ objc_getAssociatedObject( self, kRowPropertyKey ) integerValue ];
}

- ( void )setIdentifier:(NSString *)identifier {
    objc_setAssociatedObject(self, kInfCellIdPropertyKey, identifier, OBJC_ASSOCIATION_RETAIN );
}

- ( NSString* )identifier {
    return objc_getAssociatedObject( self, kInfCellIdPropertyKey );
}

@end

/*=========================================================================*/
#pragma mark -

@interface NSArray (infinity)

- ( id )firstObject;

@end

@implementation NSArray (infinity)

- ( id )firstObject {
    if ( self.count > 0 )
        return [ self objectAtIndex:0 ];
    return nil;
}

@end

/*=========================================================================*/
#pragma mark -

@interface NSMutableArray (infinity)

- ( void )setFirstObject:( id )obj;
- ( void )removeFirstObject;

@end

@implementation NSMutableArray (infinity)

- ( void )setFirstObject:( id )obj {
    [ self insertObject:obj atIndex:0 ];
}

- ( void )removeFirstObject {
    if ( self.count > 0 )
        [ self removeObjectAtIndex:0 ];
}

@end

/*=========================================================================*/
#pragma mark -
#pragma mark -

@interface FlexibleTileContainerView() {
    NSMutableDictionary *_freeViews;
    NSString *_currentCellId;
    NSMutableArray *_visibleRows;
    NSMutableDictionary *_rowsHeightDic;
    NSMutableDictionary *_columnsWidthDic;
    CGRect _visibleRect;
}

@end

@implementation FlexibleTileContainerView

#pragma mark Properties

@synthesize dataSource = _dataSource;
@synthesize rowsInitIndex = _rowsInitIndex;
@synthesize rowsMinIndex = _rowsMinIndex;
@synthesize rowsMaxIndex = _rowsMaxIndex;
@synthesize columnsInitIndex = _columnsInitIndex;
@synthesize columnsMinIndex = _columnsMinIndex;
@synthesize columnsMaxIndex = _columnsMaxIndex;
@synthesize cellSize = _cellSize;

- ( NSArray* )visibleCells {
	NSMutableArray *res = [[ NSMutableArray alloc ] init ];
	for ( NSMutableArray *row in _visibleRows ) {
		[ res addObjectsFromArray:row ];
	}
	return [ res autorelease ];
}

- ( UIView* )viewAtPoint:( CGPoint )testPoint atRow:( NSInteger* )row atCol:( NSInteger* )col {
//    NSLog( @"FLEX view at point %@", NSStringFromCGPoint( testPoint ));
    for ( UIView *view in self.subviews ) {
        if ( CGRectContainsPoint( view.frame, testPoint )) {
            *row = view.row;
            *col = view.col;
//            NSLog( @"Found %ix%i", view.row, view.col );
            return view;
        }
    }
    return nil;
}

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
        NSMutableArray *cache = [ _freeViews objectForKey:identifier ];
        if ( cache ) {
            view = [ cache.lastObject retain ];
            [ cache removeLastObject ];
            if ( cache.count == 0 )
                [ _freeViews removeObjectForKey:identifier ];
        }
    }
    if ( _currentCellId )[ _currentCellId release ];
    _currentCellId = [ identifier retain ];
    return view;
}

- ( void )reloadData {
    for ( UIView *view in self.subviews ) {
        [ self removeViewToCache:view ];
    }
    [ _visibleRows removeAllObjects ];
    [ _rowsHeightDic removeAllObjects ];
    [ _columnsWidthDic removeAllObjects ];
    _visibleRect = CGRectNull;
}

#pragma mark - Private methods

- ( CGFloat )heightForRow:( NSInteger )row {
    CGFloat res = 0;
    if ( _dataSource && [ _dataSource respondsToSelector:@selector( flexibleTileView:heightOfRow: )]) {
        NSNumber *k = [ NSNumber numberWithInt:row ];
        if ([ _rowsHeightDic.allKeys containsObject:k ]) {
            res = [[ _rowsHeightDic objectForKey:k] floatValue ];
        } else {
            res = [ _dataSource flexibleTileView:self heightOfRow:row ];
        }
        if ( res < 0 ) res = 0;
        [ _rowsHeightDic setObject:[ NSNumber numberWithFloat:res ] forKey:k ];
    } else {
        res = _cellSize.height;
    }
    return res;
}

- ( CGFloat )widthForColumn:( NSInteger )col {
    CGFloat res = 0;
    if ( _dataSource && [ _dataSource respondsToSelector:@selector( flexibleTileView:widthOfColumn: )]) {
        NSNumber *k = [ NSNumber numberWithInt:col ];
        if ([ _columnsWidthDic.allKeys containsObject:k ]) {
            res = [[ _columnsWidthDic objectForKey:k] floatValue ];
        } else {
            res = [ _dataSource flexibleTileView:self widthOfColumn:col ];
        }
        if ( res < 0 ) res = 0;
        [ _columnsWidthDic setObject:[ NSNumber numberWithFloat:res ] forKey:k ];
    } else {
        res = _cellSize.width;
    }
//    NSLog( @"Width for column %i is %f", col, res );
    return res;
}

- ( UIView* )cellForRow:( NSInteger )row andColumn:( NSInteger )col {
    if ( _dataSource && [ _dataSource respondsToSelector:@selector( flexibleTileView:viewForRow:andColumn: )]) {
        UIView *cell = [ _dataSource flexibleTileView:self viewForRow:row andColumn:col ];
        if ( cell ) {
            cell.row = row;
            cell.col = col;
            cell.identifier = _currentCellId;
            return cell;
        } else {
            [ NSException raise:@"Infinity list view data error"
                         format:@"The view for cell must not be nil." ];
        }
    } else {
        [ NSException raise:@"Infinity list view datasource error"
                     format:@"The delegate must implement viewForRow:andColumn: method" ];
    }
    return nil;
}

- ( CGRect )rowEdges:( NSMutableArray* )aRow {
    UIView *first = aRow.firstObject;
    UIView *last = aRow.lastObject;
    return CGRectUnion( first.frame, last.frame );
}

- ( NSInteger )rowIndex:( NSMutableArray* )aRow {
    UIView *cell = aRow.firstObject;
    return cell.row;
}

#pragma mark - Layout methods

#pragma mark Layout cells in row

- ( void )removeLeftCellOfRow:( NSMutableArray* )rowCells {
    UIView *cell = rowCells.firstObject;
    [ self removeViewToCache:cell ];
    [ rowCells removeFirstObject ];
}

- ( void )removeRightCellOfRow:( NSMutableArray* )rowCells {
    UIView *cell = rowCells.lastObject;
    [ self removeViewToCache:cell ];
    [ rowCells removeLastObject ];
}

- ( void )tileCellsInRow:( NSMutableArray* )rowCells inRect:( CGRect )bounds {
    //    NSLog( @"%s", __func__ );
    // Fill row on left
    UIView *cell = rowCells.firstObject;
    CGRect cellFrame = cell.frame;
    NSInteger rowId = cell.row;
//    NSLog( @"Begin add cell on left %i %@", cell.col, NSStringFromCGRect( cellFrame ));
    while ( cellFrame.origin.x > bounds.origin.x && cellFrame.origin.x > 0 ) {
        NSInteger colId = cell.col - 1;
        if ( _columnsMinIndex < _columnsMaxIndex )
            if ( colId < _columnsMinIndex )
                colId = _columnsMaxIndex;
        CGFloat cellW = [ self widthForColumn:colId ];
        CGFloat cellH = cellFrame.size.height;
        cell = [ self cellForRow:rowId andColumn:colId ];
        cell.frame = CGRectMake( cellFrame.origin.x - cellW, cellFrame.origin.y, cellW, cellH );
        rowCells.firstObject = cell;
        [ self addSubview:cell ];
        cellFrame = cell.frame;
//        NSLog( @"Add column %i %@", colId, NSStringFromCGRect( cellFrame ));
    }
    // Fill row on right
    cell = rowCells.lastObject;
    cellFrame = cell.frame;
//    NSLog( @"Begin add cell on right %i %@", cell.col, NSStringFromCGRect( cellFrame ));
    while ((( cellFrame.origin.x + cellFrame.size.width ) < ( bounds.origin.x + bounds.size.width )) &&
           (( cellFrame.origin.x + cellFrame.size.width ) < self.bounds.size.width )) {
        NSInteger colId = cell.col + 1;
        if ( _columnsMinIndex < _columnsMaxIndex )
            if ( colId > _columnsMaxIndex )
                colId = _columnsMinIndex;
        CGFloat cellW = [ self widthForColumn:colId ];
        CGFloat cellH = cellFrame.size.height;
        cell = [ self cellForRow:rowId andColumn:colId ];
        cell.frame = CGRectMake( cellFrame.origin.x + cellFrame.size.width, cellFrame.origin.y, cellW, cellH );
        [ rowCells addObject:cell ];
        [ self addSubview:cell ];
        cellFrame = cell.frame;
//        NSLog( @"Add column %i %@", colId, NSStringFromCGRect( cellFrame ));
    }
}

#pragma mark Layout rows

- ( void )addNewRowOnTopInRect:( CGRect )bounds {
    NSMutableArray *row = [[ NSMutableArray alloc ] init ];
    NSInteger rowId = _rowsInitIndex;
    NSInteger colId = _columnsInitIndex;
    CGRect targetRect = bounds;
    if ( _visibleRows.count ) {
        NSMutableArray *topRow = _visibleRows.firstObject;
        UIView *cell = topRow.firstObject;
        rowId = cell.row - 1;
        if ( _rowsMinIndex < _rowsMaxIndex ) {
            if ( rowId < _rowsMinIndex )
                rowId = _rowsMaxIndex;
        }
        colId = cell.col;
        targetRect.origin.y = cell.frame.origin.y;
        targetRect.origin.x = cell.frame.origin.x;
    }
    targetRect.size.height = [ self heightForRow:rowId ];
    targetRect.size.width = [ self widthForColumn:colId ];
    if ( _visibleRows.count )
        targetRect.origin.y -= targetRect.size.height;
    
    UIView *view = [ self cellForRow:rowId andColumn:colId ];
    view.frame = targetRect;
    [ row addObject:view ];
    [ self addSubview:view ];
    
//    NSLog( @"Add row on top %i", rowId );
    
    [ self tileCellsInRow:row inRect:bounds ];
    _visibleRows.firstObject = row;
}

- ( void )addNewRowOnBottomInRect:( CGRect )bounds {
    NSMutableArray *row = [[ NSMutableArray alloc ] init ];
    NSInteger rowId = _rowsInitIndex;
    NSInteger colId = _columnsInitIndex;
    CGRect targetRect = bounds;
    if ( _visibleRows.count ) {
        NSMutableArray *lastRow = _visibleRows.lastObject;
        UIView *cell = lastRow.firstObject;
        rowId = cell.row + 1;
        if ( _rowsMinIndex < _rowsMaxIndex ) {
            if ( rowId > _rowsMaxIndex )
                rowId = _rowsMinIndex;
        }
        colId = cell.col;
        targetRect.origin.y = cell.frame.origin.y + cell.frame.size.height;
        targetRect.origin.x = cell.frame.origin.x;
    }
    targetRect.size.height = [ self heightForRow:rowId ];
    targetRect.size.width = [ self widthForColumn:colId ];
    
    UIView *view = [ self cellForRow:rowId andColumn:colId ];
    view.frame = targetRect;
    [ row addObject:view ];
    [ self addSubview:view ];
    
//    NSLog( @"Add row  on bottom %i", rowId );
    
    [ self tileCellsInRow:row inRect:bounds ];
    [ _visibleRows addObject:row ];
}

- ( void )removeTopRow {
    if ( _visibleRows.count == 0 ) return;
    NSMutableArray *row = _visibleRows.firstObject;
    //    NSLog( @"Remove row from top %i", [ self rowIndex:row ]);
    while ( row.count ) {
        [ self removeRightCellOfRow:row ];
    }
    [ _visibleRows removeFirstObject ];
}

- ( void )removeBottomRow {
    if ( _visibleRows.count == 0 ) return;
    NSMutableArray *row = _visibleRows.lastObject;
    //    NSLog( @"Remove row from bottom %i", [ self rowIndex:row ]);
    while ( row.count ) {
        [ self removeRightCellOfRow:row ];
    }
    [ _visibleRows removeLastObject ];
}

- ( void )showViewInRect:(CGRect)visibleBounds {
    //    NSLog( @"%s %@", __func__, NSStringFromCGRect( visibleRect ));
//    NSLog( @"Show view in rect %@ / %@", NSStringFromCGRect( visibleBounds ), NSStringFromCGRect( _visibleRect ));
    if ( CGRectEqualToRect( visibleBounds, _visibleRect ) || _dataSource == nil ) return;
    
    if ( _visibleRows.count ) {
        // Remove invisible rows
        CGRect topRowRect = [ self rowEdges:_visibleRows.firstObject ];
        while (( topRowRect.origin.y + topRowRect.size.height ) < visibleBounds.origin.y ) {
            [ self removeTopRow ];
            if ( _visibleRows.count == 0 ) break;
            topRowRect = [ self rowEdges:_visibleRows.firstObject ];
        }
        if ( _visibleRows.count ) {
            CGRect bottomRowRect = [ self rowEdges:_visibleRows.lastObject ];
            while ( bottomRowRect.origin.y > ( visibleBounds.origin.y + visibleBounds.size.height )) {
                [ self removeBottomRow ];
                if ( _visibleRows.count == 0 ) break;
                bottomRowRect = [ self rowEdges:_visibleRows.lastObject ];
            }
            // Remove invisible cells
            for ( NSMutableArray* row in _visibleRows ) {
                if ( row.count > 0 ) {
                    // Remove most left cell
                    UIView *cell = row.firstObject;
                    while (( cell.frame.origin.x + cell.frame.size.width ) < visibleBounds.origin.x ) {
                        [ self removeLeftCellOfRow:row ];
                        if ( row.count == 0 ) break;
                        cell = row.firstObject;
                    }
                    if ( row.count > 0 ) {
                        // Remove most right cell
                        cell = row.lastObject;
                        while ( cell.frame.origin.x > ( visibleBounds.origin.x + visibleBounds.size.width )) {
                            [ self removeRightCellOfRow:row ];
                            if ( row.count == 0 ) break;
                            cell = row.lastObject;
                        }
                    }
                }
            }
        }
    }
    
    // Fill the existing rows
    for ( NSMutableArray *row in _visibleRows ) {
        [ self tileCellsInRow:row inRect:visibleBounds ];
    }
    // Fill the row to top
    if ( _visibleRows.count ) {
        NSMutableArray *row = _visibleRows.firstObject;
        CGRect topRowRect = [ self rowEdges:row ];
        while ( topRowRect.origin.y > visibleBounds.origin.y && topRowRect.origin.y > 0 ) {
            [ self addNewRowOnTopInRect:visibleBounds ];
            row = _visibleRows.firstObject;
            topRowRect = [ self rowEdges:row ];
        }
    }
    // Fill the row to bottom
    CGRect bottomRowRect;
    if ( _visibleRows.count ) {
        NSMutableArray *row = _visibleRows.lastObject;
        bottomRowRect = [ self rowEdges:row ];
    } else {
        bottomRowRect = CGRectMake( visibleBounds.origin.x, visibleBounds.origin.y, 0, 0 );
    }
    while (( bottomRowRect.origin.y + bottomRowRect.size.height ) < ( visibleBounds.origin.y + visibleBounds.size.height ) &&
           ( bottomRowRect.origin.y + bottomRowRect.size.height ) < self.bounds.size.height ) {
        [ self addNewRowOnBottomInRect:visibleBounds ];
        NSMutableArray *row = _visibleRows.lastObject;
        bottomRowRect = [ self rowEdges:row ];
    }
    _visibleRect = visibleBounds;
}

#pragma mark - Life cycle

- ( void )settingMeUp {
    if ( CGSizeEqualToSize( _cellSize, CGSizeZero ))
        _cellSize = [[ UIScreen mainScreen ] bounds ].size;
    _freeViews = [[ NSMutableDictionary alloc ] init ];
    self.clipsToBounds = YES;
    _visibleRows = [[ NSMutableArray alloc ] init ];
    _rowsHeightDic = [[ NSMutableDictionary alloc ] init ];
    _columnsWidthDic = [[ NSMutableDictionary alloc ] init ];
}

- (id)initWithFrame:(CGRect)frame {
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
    [ _visibleRows release ];
    [ _columnsWidthDic release ];
    [ _rowsHeightDic release ];
    [ super dealloc ];
}

@end
