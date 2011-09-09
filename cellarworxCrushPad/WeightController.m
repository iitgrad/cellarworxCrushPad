//
//  WeightController.m
//  Crush
//
//  Created by Kevin McQuown on 8/13/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "WeightController.h"


@implementation WeightController

@synthesize theTextField;
@synthesize theFieldName;
@synthesize delegate;
@synthesize initialText;

- (id)initWithNibName:(NSString *)nibNameOrNil
			   bundle:(NSBundle *)nibBundleOrNil 
	  withInitialText:(NSString *)text 
			 forField:(NSString *)fn 
		 keyBoardType:(UIKeyboardType)kt
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		if ([[NSNull null] isEqual:text])
			self.initialText=[[NSString alloc] initWithString:@""];
		else
			self.initialText=[[NSString alloc] initWithString:text];
		self.theFieldName=[[NSString alloc] initWithString:fn];
		theKeyBoardType=kt;
    }
    return self;
}

-(void) commit
{
	[self.delegate TextEntered:self forField:self.theFieldName];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.theTextField.text=self.initialText;
	[self.theTextField setKeyboardType: theKeyBoardType];
	if (theKeyBoardType==UIKeyboardTypeNumberPad)
		[self.theTextField setClearsOnBeginEditing:YES];

	UIFont *theFont=[UIFont boldSystemFontOfSize:36];
	[theTextField setFont:theFont];
	[theTextField setMinimumFontSize:17.0];
	[theTextField setFrame:CGRectMake(60, 20, 200, 60)];
	
    [super viewDidLoad];
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[theTextField release];
	[theFieldName release];
	[initialText release];
    [super dealloc];
}


@end
