//
//  DescriptionController.m
//  CCC2
//
//  Created by Kevin McQuown on 5/20/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "DescriptionController.h"


@implementation DescriptionController
@synthesize theTextView;
@synthesize theText;
@synthesize delegate;
@synthesize fieldName;
@synthesize theBar;
@synthesize backButton;

-(id) initWithDescription:(NSString *)theDesc forField:(NSString *)fn
{
	self.fieldName=[[NSString alloc] initWithString:fn];
	if (theDesc == (NSString *)[NSNull null])
		self.theText=@"";
	else
		self.theText=[[NSString	alloc] initWithString:theDesc];
	return self;
}

- (void)doneEditing:(id) sender
{
	[theTextView resignFirstResponder];
	self.navigationItem.rightBarButtonItem=nil;
	self.navigationItem.leftBarButtonItem=nil;
	[delegate ChangedDescription:self newText:theTextView.text forField:self.fieldName];
	
}
- (void)cancelEditing:(id) sender
{
	self.navigationItem.rightBarButtonItem = nil;
	[theTextView resignFirstResponder];
	self.navigationItem.leftBarButtonItem=self.backButton;	
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneEditing:)]autorelease];
	self.backButton=self.navigationItem.leftBarButtonItem;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelEditing:)]autorelease];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.theTextView.text=self.theText;
    [super viewDidLoad];
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
    [theTextView release];
    [theBar release];
    [fieldName release];
    [theText release];
    [backButton release];
    
    [super dealloc];
}


@end
