/**
 
 Infinity Tile View: InfinityTileView
 
 Created by SoleilPQD on 13 Oct 2012.
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
#import "FlexibleTileContainerView.h"

typedef enum {
    kInfNone,
    kInfHorizotal,
    kInfVertical,
    kInf2D
} infinity_direction_t;

@interface InfinityTileView : UIScrollView

@property ( nonatomic, retain ) id<FlexibleTileDataSource> dataSource;
@property ( nonatomic, readonly ) infinity_direction_t direction;
@property ( nonatomic, readonly ) FlexibleTileContainerView *backgroundView;

- ( id )initWithFrame:( CGRect )frame andDirection:( infinity_direction_t )direction;
- ( void )reloadData;
- ( UIView* )viewAtPoint:( CGPoint )testPoint atRow:( NSInteger* )row atCol:( NSInteger* )col;
- ( void )snapToBorder;

@end