//
//  TimeSelectorViewController.m
//  myInfinityScroller
//
//  Created by Soleil on 10/15/12.
//  Copyright (c) 2012 Soleil. All rights reserved.
//

#import "TimeSelectorViewController.h"

@interface TimeSelectorViewController () {
    InfinityTileView *_hourList, *_minList, *_secList;
    NSInteger _hourOffset, _minOffset, _secOffset;
}

@end

@implementation TimeSelectorViewController

- ( NSInteger )valueOfRow:( NSInteger )row withOffset:( NSInteger )offset andMax:( NSInteger )maxVal {
    row += offset;
    if ( row >= maxVal ) row -= maxVal;
    return row;
}

- ( void )updateContent {
    NSInteger row = 0;
    NSInteger col = 0;
    NSInteger h = 0, m = 0, s = 0;
    CGPoint center = CGPointMake( _hourList.bounds.size.width / 2, _hourList.bounds.size.height / 2 );
    UIView *view = [ _hourList viewAtPoint:center
                                     atRow:&row atCol:&col ];
    if ( view ) h = row;
    row = 0;
    col = 0;
    view = [ _minList viewAtPoint:center
                            atRow:&row atCol:&col ];
    if ( view ) m = row;
    row = 0;
    col = 0;
    view = [ _secList viewAtPoint:center
                            atRow:&row atCol:&col ];
    if ( view ) s = row;
    self.title = [ NSString stringWithFormat:@"%02i:%02i:%02i", [ self valueOfRow:h
                                                                       withOffset:_hourOffset
                                                                           andMax:24 ],
                  [ self valueOfRow:m
                         withOffset:_minOffset
                             andMax:60 ],
                  [ self valueOfRow:s
                         withOffset:_secOffset
                             andMax:60 ]];
}

- ( void )scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    InfinityTileView *infTileView = ( InfinityTileView* )scrollView;
    [ infTileView snapToBorder ];
    [ self updateContent ];
}

- ( void )scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    InfinityTileView *infTileView = ( InfinityTileView* )scrollView;
    [ infTileView snapToBorder ];
    [ self updateContent ];
}

- ( UIView* )flexibleTileView:(FlexibleTileContainerView *)flexTileView viewForRow:(NSInteger)row andColumn:(NSInteger)col {
    static NSString *key = @"default";
    UILabel *label = ( UILabel* )[ flexTileView viewForReuseWithKey:key ];
    if ( label == nil ) {
        label = [[ UILabel alloc ] init ];
#ifdef __IPHONE_6_0
        label.textAlignment = NSTextAlignmentRight;
#else
        label.textAlignment = UITextAlignmentRight;
#endif
        label.textColor = [ UIColor blackColor ];
        label.font = [ UIFont boldSystemFontOfSize:24 ];
    }
    if ( row % 2 ) {
        label.backgroundColor = [ UIColor lightGrayColor ];
    } else {
        label.backgroundColor = [ UIColor whiteColor ];
    }
    switch ( flexTileView.superview.tag ) {
        case 1:
            label.text = [ NSString stringWithFormat:@"%02i", [ self valueOfRow:row
                                                                     withOffset:_hourOffset
                                                                         andMax:24 ]];
            break;
        case 2:
            label.text = [ NSString stringWithFormat:@"%02i", [ self valueOfRow:row
                                                                     withOffset:_minOffset
                                                                         andMax:60 ]];
            break;
        case 3:
            label.text = [ NSString stringWithFormat:@"%02i", [ self valueOfRow:row
                                                                     withOffset:_secOffset
                                                                         andMax:60 ]];
            break;
    }
    
    return [ label autorelease ];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define COL_PADDING 5

- ( void )viewDidAppear:(BOOL)animated {
    [ super viewDidAppear:animated ];
    [ self updateContent ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat colWidth = ( _vwContainer.bounds.size.width - 2 * COL_PADDING ) / 3;
    _hourList = [[ InfinityTileView alloc ] initWithFrame:CGRectMake( 0, 0, colWidth, _vwContainer.bounds.size.height )
                                             andDirection:kInfVertical ];
    _minList = [[ InfinityTileView alloc ] initWithFrame:CGRectMake( colWidth + COL_PADDING, 0, colWidth, _vwContainer.bounds.size.height )
                                            andDirection:kInfVertical ];
    _secList = [[ InfinityTileView alloc ] initWithFrame:CGRectMake(( colWidth + COL_PADDING ) * 2, 0, colWidth, _vwContainer.bounds.size.height )
                                            andDirection:kInfVertical ];
    _hourList.dataSource = _minList.dataSource = _secList.dataSource = self;
    _hourList.delegate = _minList.delegate = _secList.delegate = self;
    _hourList.tag = 1;
    _minList.tag = 2;
    _secList.tag = 3;
    _hourList.backgroundView.rowsMaxIndex = 23;
    _minList.backgroundView.rowsMaxIndex = 59;
    _secList.backgroundView.rowsMaxIndex = 59;
    // Setup for 5 rows
    _hourList.backgroundView.cellSize =
    _minList.backgroundView.cellSize =
    _secList.backgroundView.cellSize = CGSizeMake( _hourList.bounds.size.width, _hourList.bounds.size.height / 5 );
    [ _vwContainer addSubview:_hourList ];
    [ _vwContainer addSubview:_minList ];
    [ _vwContainer addSubview:_secList ];
    [ _vwContainer bringSubviewToFront:_vwHighlight ];
    // Setup to display the current time first
    NSCalendar *aCalender = [[[ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ] autorelease ];
	NSDateComponents *component = [ aCalender components:( NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit )
                                                fromDate:[ NSDate date ]];
    _hourOffset = component.hour - 2;
    _minOffset = component.minute - 2;
    _secOffset = component.second - 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- ( BOOL )shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- ( void )dealloc {
    [ _vwContainer release ];
    [ _vwHighlight release ];
    [ _hourList release ];
    [ _minList release ];
    [ _secList release ];
    [ super dealloc ];
}

@end
