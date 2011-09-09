//
//  graphViewController.h
//  Crush
//
//  Created by Kevin McQuown on 8/3/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "plotRange.h"
#import "plotAttributes.h"
#import "graphView.h"

@interface graphViewController : UIViewController <graphViewDelegate, graphViewDataSource, UIGestureRecognizerDelegate> {
	
	graphView *graph;

}
@property (nonatomic, assign) graphView *graph;

@end
