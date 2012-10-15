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

#import <UIKit/UIKit.h>

@protocol TileContainerDataSource;

@interface TileContainerView : UIView

// Instance which provides the view to display
@property ( nonatomic, retain ) id<TileContainerDataSource> delegate;
// The number of rows and columns depend on cellSize and self.bounds
@property ( nonatomic, assign ) CGSize cellSize;
// Get the arranged cells after showViewsInRect;
@property ( nonatomic, readonly ) NSArray *visibleCells;

// Display the cell in specified rect.
// This function is designed for TileScrollView
// if you use this view directly, just call showViewsInrect:self.bounds.
- ( void )showViewsInRect:( CGRect )visibleBounds;
// Rearrange the existing views in new rect with animation,
// if existing cells can not fill the rect, get new cell from data source as showViewsInRect does
- ( void )reArrangeInRect:( CGRect )visibleBounds withAnimation:( CGFloat )animDuration;
// Get the view for reuse
// This also set the identifer for the next cell view return from DataSource delegate
- ( UIView* )viewForReuseWithKey:( NSString* )identifier;

// IMPORTANT: DO NOT USE the TAG property of the cell view
// I use it to get the cell from self.subviews

@end


@protocol TileContainerDataSource <NSObject>

- ( UIView* )tileContainerView:( TileContainerView* )tileView viewForRow:( NSInteger )row andColumn:( NSInteger )col;

@end
