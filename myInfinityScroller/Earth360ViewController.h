//
//  Earth360ViewController.h
//  myInfinityScroller
//
//  Created by soleilpqd on 10/14/12.
//  Copyright (c) 2012 Soleil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfinityTileView.h"

@interface Earth360ViewController : UIViewController <FlexibleTileDataSource, UIScrollViewDelegate> {
	InfinityTileView *_infListView;
}

@end
