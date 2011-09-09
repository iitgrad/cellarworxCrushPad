//
//  TextFieldController.m
//  CCC2
//
//  Created by Kevin McQuown on 5/17/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "TextFieldController.h"


@implementation TextFieldController

@synthesize theTextField;
@synthesize theFieldName;
@synthesize delegate;
@synthesize initialText;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withInitialText:(NSString *)text forField:(NSString *)fn  keyBoardType:(UIKeyboardType)kt{
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


//-(id) initWithInitialText:(NSString *)text forField:(NSString *)fieldName
//{
//
//	self = [super self];
//	return self;
//}

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

    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	UIFont *theFont=[UIFont boldSystemFontOfSize:24];
	[self.theTextField setFont:theFont];
	[self.theTextField setMinimumFontSize:24.0];
	[self.theTextField setFrame:CGRectMake(20, 20, 280, 50)];
	
}

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
    [initialText release];
    [theFieldName release];
    [super dealloc];
}


@end
