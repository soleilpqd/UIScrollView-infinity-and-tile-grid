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

#import <UIKit/UIKit.h>

@protocol FlexibleTileDataSource;

@interface FlexibleTileContainerView : UIView

@property ( nonatomic, retain ) id<FlexibleTileDataSource> dataSource;
// Set these properties if you want to repeat displaying cells in an infinity scrollview
// When scrolling, if the cell identifier (row, column) pass the maximum/minimum value,
// the cell identifier (row, cell) will be set to its minmum/maximum value
// The InitIndex value is used at first time when this arranges subviews
@property ( nonatomic, assign ) NSInteger rowsMinIndex;
@property ( nonatomic, assign ) NSInteger rowsMaxIndex;
@property ( nonatomic, assign ) NSInteger rowsInitIndex;
@property ( nonatomic, assign ) NSInteger columnsMinIndex;
@property ( nonatomic, assign ) NSInteger columnsMaxIndex;
@property ( nonatomic, assign ) NSInteger columnsInitIndex;
@property ( nonatomic, assign ) CGSize cellSize;
@property ( nonatomic, readonly ) NSArray *visibleCells;

- ( UIView* )viewForReuseWithKey:( NSString* )identifier;
- ( void )reloadData;
- ( void )showViewInRect:( CGRect )visibleBounds;
- ( UIView* )viewAtPoint:( CGPoint )testPoint atRow:( NSInteger* )row atCol:( NSInteger* )col;

@end


@protocol FlexibleTileDataSource <NSObject>

// Like UITableView, you should return this functions fast,
// or it will hang up your app for a time if it displays many cells in same time.
- ( UIView* )flexibleTileView:( FlexibleTileContainerView* )flexTileView viewForRow:( NSInteger )row andColumn:( NSInteger )col;

@optional
// If data source does not implement these functions, I use cellSize.
- ( CGFloat )flexibleTileView:( FlexibleTileContainerView* )flexTileView widthOfColumn:( NSInteger )col;
- ( CGFloat )flexibleTileView:( FlexibleTileContainerView* )flexTileView heightOfRow:( NSInteger )row;

@end
