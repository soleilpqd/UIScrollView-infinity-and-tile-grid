//
//  TokyoMapViewController.m
//  myInfinityScroller
//
//  Created by Soleil on 10/15/12.
//  Copyright (c) 2012 Soleil. All rights reserved.
//

#import "TokyoMapViewController.h"

@interface TokyoMapViewController ()
{
    NSInteger _numCols;
    NSInteger _numRows;
}

@end

@implementation TokyoMapViewController

#pragma mark - Tile view delegate

- ( UIView* )tileContainerView:(TileContainerView *)tileView viewForRow:(NSInteger)row andColumn:(NSInteger)col {
    static NSString *key = @"Default";
    UIImageView *imageView = ( UIImageView* )[ tileView viewForReuseWithKey:key ];
	if ( imageView == nil )
		imageView = [[ UIImageView alloc ] init ];
	imageView.image = [ UIImage imageWithContentsOfFile:[[ NSBundle mainBundle ].bundlePath stringByAppendingFormat:@"/images/tokyomap/%i_%i.jpg", row, col ]];
	return [ imageView autorelease ];
}

#pragma mark - Life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *imageDic = [ NSDictionary dictionaryWithContentsOfFile:[[[ NSBundle mainBundle ] bundlePath ] stringByAppendingPathComponent:@"images/tokyomap/image.plist" ]];
    _tileView.contentSize = CGSizeMake([[ imageDic objectForKey:@"image_width" ] floatValue ],
                            [[ imageDic objectForKey:@"image_height" ] floatValue ]);
    _numCols = [[ imageDic objectForKey:@"cols" ] integerValue ];
    _numRows = [[ imageDic objectForKey:@"rows" ] integerValue ];
    _tileView.tileView.cellSize = CGSizeMake([[ imageDic objectForKey:@"cell_width" ] floatValue ],
                                             [[ imageDic objectForKey:@"cell_height" ] floatValue ]);
    _tileView.tileView.delegate = self;
    self.title = @"Tokyo map";
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
    [ _tileView release ];
    [ super dealloc ];
}

@end
