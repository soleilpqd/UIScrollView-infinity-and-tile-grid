//
//  Earth360ViewController.m
//  myInfinityScroller
//
//  Created by soleilpqd on 10/14/12.
//  Copyright (c) 2012 Soleil. All rights reserved.
//

#import "Earth360ViewController.h"

@interface  Earth360ViewController () {
    NSInteger _numRows;
    NSInteger _numCols;
    CGSize _imageSize;
}
@end

@implementation Earth360ViewController

- ( UIView* )flexibleTileView:(FlexibleTileContainerView *)flexTileView viewForRow:(NSInteger)row andColumn:(NSInteger)col {
	UIImageView *imageView = ( UIImageView* )[ flexTileView viewForReuseWithKey:@"Default" ];
	if ( imageView == nil )
		imageView = [[ UIImageView alloc ] init ];
	imageView.contentMode = UIViewContentModeScaleToFill;
	if ( col >= _numCols ) col -= _numCols;
	if ( row < 0 ) {
		UIImage *image = [ UIImage imageWithContentsOfFile:[[ NSBundle mainBundle ].bundlePath stringByAppendingFormat:@"/images/Earth Map/%i_%i.jpg", abs(row) - 1, col ]];
		imageView.image = [ UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationDownMirrored ];
	} else {
		imageView.image = [ UIImage imageWithContentsOfFile:[[ NSBundle mainBundle ].bundlePath stringByAppendingFormat:@"/images/Earth Map/%i_%i.jpg", row, col ]];
	}
	return [ imageView autorelease ];
}

- ( CGFloat )flexibleTileView:(FlexibleTileContainerView *)flexTileView heightOfRow:(NSInteger)row {
    if ( row < 0 )
        row = abs(row) - 1;
    if ( row < _numRows - 1 ) {
		return flexTileView.cellSize.height;
	} else {
		return _imageSize.height - (( _numRows - 1 ) * flexTileView.cellSize.height );
	}
}

- ( CGFloat )flexibleTileView:(FlexibleTileContainerView *)flexTileView widthOfColumn:(NSInteger)col {
    if ( col >= _numCols ) col -= _numCols;
    if ( col < _numCols - 1 ) {
		return flexTileView.cellSize.width;
	} else {
		return _imageSize.width - (( _numCols - 1 ) * flexTileView.cellSize.width );
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _infListView = [[ InfinityTileView alloc ] initWithFrame:self.view.bounds
                                                    andDirection:kInf2D ];
        [ self.view addSubview:_infListView ];
        _infListView.dataSource = self;
        _infListView.delegate = self;
		NSDictionary *imageDic = [ NSDictionary dictionaryWithContentsOfFile:[[[ NSBundle mainBundle ] bundlePath ] stringByAppendingPathComponent:@"images/Earth Map/image.plist" ]];					  
		_imageSize = CGSizeMake([[ imageDic objectForKey:@"image_width" ] floatValue ],
								[[ imageDic objectForKey:@"image_height" ] floatValue ]);
		_numCols = [[ imageDic objectForKey:@"cols" ] integerValue ];
		_numRows = [[ imageDic objectForKey:@"rows" ] integerValue ];
		_infListView.backgroundView.cellSize = CGSizeMake([[ imageDic objectForKey:@"cell_width" ] floatValue ],
														  [[ imageDic objectForKey:@"cell_height" ] floatValue ]);
		_infListView.contentSize = _imageSize;
		_infListView.backgroundView.columnsMaxIndex = 2 * _numCols - 1;
		_infListView.backgroundView.rowsMaxIndex = _numRows - 1;
		_infListView.backgroundView.rowsMinIndex = - _infListView.backgroundView.rowsMaxIndex - 1;
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
	self.title = @"Earth 360";
	
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
	[ _infListView release ];
	[ super dealloc ];
}

@end
