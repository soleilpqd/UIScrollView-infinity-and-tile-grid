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

#import "InfinityTileView.h"

#define CONTAINER_INFINITY_SIZE 5000.0

@interface InfinityTileView() {
    infinity_direction_t _direction;
    FlexibleTileContainerView *_containerView;
}

@end

@implementation InfinityTileView

#pragma mark - Properties

- ( infinity_direction_t )direction {
	return _direction;
}

- ( id<FlexibleTileDataSource> )dataSource {
    return _containerView.dataSource;
}

- ( void )setDataSource:(id<FlexibleTileDataSource>)dataSource {
    _containerView.dataSource = dataSource;
}

- ( FlexibleTileContainerView* )backgroundView {
    return _containerView;
}

- ( void )setContentSize:(CGSize)contentSize {
    switch ( _direction ) {
        case kInfNone:
            break;
        case kInfHorizotal:
            contentSize.width = CONTAINER_INFINITY_SIZE;
            break;
        case kInfVertical:
            contentSize.height = CONTAINER_INFINITY_SIZE;
            break;
        case kInf2D:
            contentSize.width =
            contentSize.height = CONTAINER_INFINITY_SIZE;
            break;
    }
    [ super setContentSize:contentSize ];
    _containerView.frame = CGRectMake( 0, 0, self.contentSize.width, self.contentSize.height );
//    NSLog( @"INFSCR set content size %@ %@ %@", NSStringFromCGSize( contentSize ), NSStringFromCGSize( self.contentSize ), NSStringFromCGRect( _containerView.frame ));
}

- ( UIView* )viewAtPoint:( CGPoint )testPoint atRow:( NSInteger* )row atCol:( NSInteger* )col {
//    NSLog( @"INF %i view at point %@", self.tag, NSStringFromCGPoint( testPoint ));
    testPoint.x += self.contentOffset.x;
    testPoint.y += self.contentOffset.y;
    return [ _containerView viewAtPoint:testPoint atRow:row atCol:col ];
}

- ( void )reloadData {
    [ _containerView reloadData ];
    [ self layoutSubviews ];
}

- ( void )snapToBorder {
    NSInteger row = 0;
    NSInteger col = 0;
    UIView *view = [ self viewAtPoint:CGPointZero atRow:&row atCol:&col ];
    if ( view ) {
        CGPoint currentOffset = self.contentOffset;
        CGSize cellOffset = CGSizeMake( self.contentOffset.x - view.frame.origin.x, self.contentOffset.y - view.frame.origin.y );
        if ( cellOffset.width > view.bounds.size.width / 2 ) {
            currentOffset.x += view.bounds.size.width - cellOffset.width;
        } else {
            currentOffset.x -= cellOffset.width;
        }
        if ( cellOffset.height > view.bounds.size.height / 2 ) {
            currentOffset.y += view.bounds.size.height - cellOffset.height;
        } else {
            currentOffset.y -= cellOffset.height;
        }
        if ( !CGPointEqualToPoint( currentOffset, self.contentOffset ))
            [ self setContentOffset:currentOffset animated:YES ];
    }
}

#pragma mark Main layout

- ( void )recenter {
    if ( _direction == kInfNone ) return;
    CGPoint currentOffset = self.contentOffset;
    CGPoint centerOffset = CGPointMake(( self.contentSize.width - self.bounds.size.width ) / 2.0,
                                       ( self.contentSize.height - self.bounds.size.height ) / 2.0 );
    CGSize distanceFromCenter = CGSizeMake( fabs( currentOffset.x - centerOffset.x ),
                                           fabs( currentOffset.y - centerOffset.y ));
    if ( _direction == kInfHorizotal || _direction == kInf2D ) {
        if ( distanceFromCenter.width > ( self.contentSize.width / 4.0 )) {
            self.contentOffset = CGPointMake( centerOffset.x, currentOffset.y );
            // move content by the same amount so it appears to stay still
            for ( UIView *view in _containerView.subviews ) {
                CGPoint center = [ _containerView convertPoint:view.center toView:self ];
                center.x += ( centerOffset.x - currentOffset.x );
                view.center = [ self convertPoint:center toView:_containerView ];
            }
        }
    }
    if ( _direction == kInfVertical || _direction == kInf2D ) {
        if ( distanceFromCenter.height > ( self.contentSize.height / 4.0 )) {
            self.contentOffset = CGPointMake( self.contentOffset.x, centerOffset.y );
            // move content by the same amount so it appears to stay still
            for ( UIView *view in _containerView.subviews ) {
                CGPoint center = [ _containerView convertPoint:view.center toView:self ];
                center.y += ( centerOffset.y - currentOffset.y );
                view.center = [ self convertPoint:center toView:_containerView ];
            }
        }
    }
}

- ( void )layoutSubviews {
//    NSLog( @"INFSCR layout %@ %@", NSStringFromCGSize( self.contentSize ), NSStringFromCGRect( _containerView.frame ));
//    NSLog( @"INF layout subview %i", self.tag );
    [ super layoutSubviews ];
    [ self recenter ];
    CGRect visibleBounds = [ self convertRect:self.bounds toView:_containerView ];
    [ _containerView showViewInRect:visibleBounds ];
}

#pragma mark - Life cycle

- ( void )settingMeUp {
    _containerView = [[ FlexibleTileContainerView alloc ] initWithFrame:self.bounds ];
    [ self addSubview:_containerView ];
    _containerView.clipsToBounds = YES;
    _containerView.backgroundColor = [ UIColor clearColor ];
    [ self setContentSize:self.bounds.size ];
    switch ( _direction ) {
        case kInfHorizotal:
            self.showsHorizontalScrollIndicator = NO;
            self.showsVerticalScrollIndicator = YES;
            break;
        case kInfVertical:
            self.showsHorizontalScrollIndicator = YES;
            self.showsVerticalScrollIndicator = NO;
            break;
        case kInf2D:
            self.showsHorizontalScrollIndicator =
            self.showsVerticalScrollIndicator = NO;
            break;
        case kInfNone:
            self.showsHorizontalScrollIndicator =
            self.showsVerticalScrollIndicator = YES;
            break;
    }
}

- ( id )initWithFrame:(CGRect)frame {
	return [ self initWithFrame:frame andDirection:kInfNone ];
}

- (id)initWithFrame:(CGRect)frame andDirection:(infinity_direction_t)direction {
    self = [super initWithFrame:frame];
    if (self) {
        _direction = direction;
        [ self settingMeUp ];
    }
    return self;
}

- ( void )awakeFromNib {
    [ super awakeFromNib ];
    _direction = kInfNone;
    [ self settingMeUp ];
}

- ( void )dealloc {
    [ _containerView release ];
    [ super dealloc ];
}

@end
