//
//  TokyoMapViewController.h
//  myInfinityScroller
//
//  Created by Soleil on 10/15/12.
//  Copyright (c) 2012 Soleil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TileScrollView.h"

@interface TokyoMapViewController : UIViewController <TileContainerDataSource> {
    IBOutlet TileScrollView *_tileView;
}

@end
