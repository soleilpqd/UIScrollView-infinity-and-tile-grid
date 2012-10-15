//
//  Test2ViewController.m
//  myInfinityScroller
//
//  Created by soleilpqd on 10/14/12.
//  Copyright (c) 2012 Soleil. All rights reserved.
//

#import "Test2ViewController.h"

@interface Test2ViewController () {
	NSArray *_colors;
	NSArray *_textColors;
}
@end

@implementation Test2ViewController

- ( UIView* )flexibleTileView:(FlexibleTileContainerView *)flexTileView viewForRow:(NSInteger)row andColumn:(NSInteger)col {
    NSInteger lucky = arc4random() % 120;
    if ( lucky % 5 == 0 ) {
        NSString *key = @"Image";
        UIImageView *imgView = ( UIImageView* )[ flexTileView viewForReuseWithKey:key ];
        if ( imgView == nil ) {
            imgView = [[ UIImageView alloc ] init ];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
        }
        imgView.image = [ UIImage imageWithContentsOfFile:[[[ NSBundle mainBundle ] bundlePath ] stringByAppendingFormat:@"/images/Icons/%i.png", lucky / 10 ]];
        return imgView;
    } else {
        NSString *key = @"Label";
        UILabel *label = ( UILabel* )[ flexTileView viewForReuseWithKey:key ];
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
        NSInteger i = arc4random() % _colors.count;
        label.backgroundColor = [ _colors objectAtIndex:i ];
        label.textColor = [ _textColors objectAtIndex:i ];
        return [ label autorelease ];
    }
}

- ( CGFloat )flexibleTileView:(FlexibleTileContainerView *)flexTileView heightOfRow:(NSInteger)row {
    return fmod( arc4random(), 100.0 ) + 50.0;
}

- ( CGFloat )flexibleTileView:(FlexibleTileContainerView *)flexTileView widthOfColumn:(NSInteger)col {
    return fmod( arc4random(), 150.0 ) + 50.0;
}

#pragma mark - Scroll view delegate

- ( UIView* )viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _infListView.backgroundView;
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _infListView = [[ InfinityTileView alloc ] initWithFrame:self.view.bounds
                                                    andDirection:kInf2D ];
        [ self.view addSubview:_infListView ];
        _infListView.dataSource = self;
        _infListView.delegate = self;
        _infListView.maximumZoomScale = 3.0;
        _infListView.minimumZoomScale = 0.5;
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
	self.title = @"Infinity tile view testing";
}

- ( void )viewWillAppear:(BOOL)animated {
	[ super viewWillAppear:animated ];
	_infListView.frame = self.view.bounds;
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

- ( void )willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    _infListView.frame = self.view.bounds;
}

- ( void )dealloc {
	[ _colors release ];
	[ _textColors release ];
	[ _infListView release ];
	[ super dealloc ];
}

@end
