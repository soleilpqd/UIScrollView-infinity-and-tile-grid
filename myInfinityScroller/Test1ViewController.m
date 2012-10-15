//
//  Test1ViewController.m
//  myInfinityScroller
//
//  Created by soleilpqd on 10/14/12.
//  Copyright (c) 2012 Soleil. All rights reserved.
//

#import "Test1ViewController.h"
@interface Test1ViewController () {
	NSArray *_colors;
    NSArray *_textColors;
}

@end

@implementation Test1ViewController

- ( UIView* )viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _tileScrollview.tileView;
}

#pragma mark - Tile data source

- ( UIView* )tileContainerView:(TileContainerView *)tileView viewForRow:(NSInteger)row andColumn:(NSInteger)col {
    NSInteger lucky = arc4random() % 120;
    if ( lucky % 2 == 0 ) {
        NSString *key = @"Image";
        UIImageView *imgView = ( UIImageView* )[ tileView viewForReuseWithKey:key ];
        if ( imgView == nil ) {
            imgView = [[ UIImageView alloc ] init ];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
        }
        imgView.image = [ UIImage imageWithContentsOfFile:[[[ NSBundle mainBundle ] bundlePath ] stringByAppendingFormat:@"/images/Icons/%i.png", lucky / 10 ]];
        return imgView;
    } else {
        NSString *key = @"Label";
        UILabel *label = ( UILabel* )[ tileView viewForReuseWithKey:key ];
        if ( label == nil ) {
            label = [[ UILabel alloc ] init ];
            label.numberOfLines = 0;
#ifdef __IPHONE_6_0
            label.lineBreakMode = NSLineBreakByWordWrapping;
#else
            label.lineBreakMode = UILineBreakModeWordWrap;
#endif
        }
        label.text = [ NSString stringWithFormat:@"Row: %i\nCol: %i", row, col ];
        // Here I set cell color randomly for each time the cell is displayed
        // so you can find that the cell at same position can change color after scrolling
        NSInteger i = arc4random() % _colors.count;
        label.backgroundColor = [ _colors objectAtIndex:i ];
        label.textColor = [ _textColors objectAtIndex:i ];
        return [ label autorelease ];
    }
    return nil;
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_tileScrollview.tileView.delegate = self;
	_colors = [[ NSArray alloc ]  initWithObjects:[ UIColor whiteColor ],
               [ UIColor grayColor ],
               [ UIColor blackColor ],
               [ UIColor redColor ],
               [ UIColor yellowColor ],
               [ UIColor cyanColor ],
               [ UIColor greenColor ],
               [ UIColor magentaColor ],
               [ UIColor purpleColor ],
               [ UIColor blueColor ],
               [ UIColor brownColor ],
               [ UIColor orangeColor ],
               [ UIColor underPageBackgroundColor ], nil ];
    _textColors = [[ NSArray alloc ]  initWithObjects:[ UIColor blackColor ], // white
                   [ UIColor purpleColor ], // gray
                   [ UIColor whiteColor ], // black
                   [ UIColor yellowColor ], // red
                   [ UIColor redColor ], // yellow
                   [ UIColor blackColor ], // cyan
                   [ UIColor blueColor ], // green
                   [ UIColor blueColor ], // magenta
                   [ UIColor whiteColor ], // purple
                   [ UIColor whiteColor ], // blue
                   [ UIColor whiteColor ], // brown
                   [ UIColor blackColor ], // orange
                   [ UIColor blueColor ], nil ]; // underPage
	self.title = @"Test simple tile view";
}

- ( void )viewWillAppear:(BOOL)animated {
	[ super viewWillAppear:animated ];
	// setup for 15 columns 20 rows with each cell 100x100
	_tileScrollview.contentSize = CGSizeMake( 100 * 15, 100 * 20 );
	_tileScrollview.tileView.cellSize = CGSizeMake( 150, 150 );
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- ( void )dealloc {
	[ _colors release ];
	[ _textColors release ];
	[ _tileScrollview release ];
	[ super dealloc ];
}

@end
