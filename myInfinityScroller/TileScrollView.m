/**
 
 Simple Tile View: TileContainerView
 
 Created by SoleilPQD on 11 Oct 2012.
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

#import "TileScrollView.h"

@implementation TileScrollView

@synthesize tileView = _tileView;

- ( void )setContentSize:(CGSize)contentSize {
    [ super setContentSize:contentSize ];
    _tileView.frame = CGRectMake( 0, 0, self.contentSize.width, self.contentSize.height );
}

- ( void )layoutSubviews {
    [ super layoutSubviews ];
    CGRect visibleBounds = [ self convertRect:self.bounds toView:_tileView ];
    [ _tileView showViewsInRect:visibleBounds ];
}

#pragma mark - Life cycle

- ( void )settingMeUp {
    _tileView = [[ TileContainerView alloc ] initWithFrame:self.bounds ];
    [ self addSubview:_tileView ];
    _tileView.clipsToBounds = YES;
    _tileView.backgroundColor = [ UIColor clearColor ];
    if ( CGSizeEqualToSize( self.contentSize, CGSizeZero )) {
        [ self setContentSize:self.bounds.size ];
    } else {
        _tileView.frame = CGRectMake( 0, 0, self.contentSize.width, self.contentSize.height );
    }
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
    [ _tileView release ];
    [ super dealloc ];
}

@end
