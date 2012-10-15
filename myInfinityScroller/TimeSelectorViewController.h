//
//  TimeSelectorViewController.h
//  myInfinityScroller
//
//  Created by Soleil on 10/15/12.
//  Copyright (c) 2012 Soleil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfinityTileView.h"

@interface TimeSelectorViewController : UIViewController <FlexibleTileDataSource, UIScrollViewDelegate> {
    IBOutlet UIView *_vwContainer;
    IBOutlet UIView *_vwHighlight;
}

@end
