    //
//  graphViewController.m
//  Crush
//
//  Created by Kevin McQuown on 8/3/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "graphViewController.h"
#import "graphView.h"
#import "plotUtilities.h"
#import "CrushHelper.h"

@implementation graphViewController
@synthesize graph;

#pragma mark  -
#pragma mark graphViewController delegate
-(BOOL) twoAxis{
	return NO;
}
-(NSUInteger)numberOfPlots {
	return 0;
}

-(void)loadView
{
	self.wantsFullScreenLayout=YES;
	graphView *view=[[graphView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	self.view=view;
	self.graph=view;
}

-(void) closeView
{
	[self.view removeFromSuperview];
}

#pragma mark -
#pragma mark view lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [graph setDelegate:self];
    [graph setDataSource:self];    
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	for (UIView *v in graph.subviews)
	{
		[v removeFromSuperview];
	}
}
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[graph setNeedsDisplay];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
