//
//  CCPinController.m
//  Untitled
//
//  Created by Kevin McQuown on 8/7/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCPinController.h"
#import "cellarworxAppDelegate.h"


@implementation CCPinController
@synthesize pinCode;
@synthesize delegate;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	number=0;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void) buttonHit:(id)sender
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSUInteger secret=kSecretPin;
	UIButton *theButton=(UIButton *)sender;
	NSString *buttonName=[theButton titleForState:UIControlStateNormal];
	number=number*10+[buttonName intValue];
	if (number==secret) {
		[ap setStaff:YES];
		[self.delegate secretPicked];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"staffStatusChanged" object:nil];
	}
	
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
	[pinCode release];
    [super dealloc];
}


@end
