//
//  Test1ViewController.h
//  myInfinityScroller
//
//  Created by soleilpqd on 10/14/12.
//  Copyright (c) 2012 Soleil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TileScrollView.h"

@interface Test1ViewController : UIViewController <TileContainerDataSource, UIScrollViewDelegate> {
	IBOutlet TileScrollView *_tileScrollview;
}

@end
