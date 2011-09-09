//
//  VineyardListController.m
//  Crush
//
//  Created by Kevin McQuown on 8/9/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCVineyardListController.h"
#import "CrushHelper.h"
#import "CCVineyardDetailController.h"

@implementation CCVineyardListController
@synthesize vydList, delegate, picker, theIndex;


-(id) initAsPicker:(BOOL)pick  withdbid:(NSString *)index;
{
	self=[super init];
	self.picker=pick;
	if (index!=nil)
		self.theIndex=[[NSString alloc] initWithString:index];
	else 
		self.theIndex=nil;
	vydList=[[NSMutableArray alloc] init];
	self.title=@"Vineyards";
	return self;
}

- (void) viewDidLoad
{
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[vydList removeAllObjects];
		[vydList addObjectsFromArray:[CrushHelper fetchLocations]];
//		dispatch_async(dispatch_get_main_queue(), ^{
			[self.tableView reloadData];
//		});
//	});		
	
}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated
{
	if (!picker)
	{
		UIBarButtonItem *add=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRecord)];
		self.navigationItem.rightBarButtonItem=add;		
	}
	[super viewWillAppear:YES];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!picker)
		return UITableViewCellEditingStyleDelete;
	else 
		return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[[vydList objectAtIndex:indexPath.row] remove];
//		dispatch_async(dispatch_get_main_queue(), ^{
			[vydList removeObjectAtIndex:indexPath.row];
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationMiddle];
//		});
//	});		
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [vydList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.textLabel.text=[[vydList objectAtIndex:indexPath.row] name];
	if (picker & [[[vydList objectAtIndex:indexPath.row] dbid] isEqualToString: self.theIndex])
		cell.accessoryType=UITableViewCellAccessoryCheckmark;
	else 
		cell.accessoryType=UITableViewCellAccessoryNone;
	
    return cell;
}

-(void)changeEditingModeTo:(BOOL)edit
{
	if (edit) {
		self.editing=YES;
		UIBarButtonItem *edit=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(setEditingOff)];
		self.navigationItem.rightBarButtonItem=edit;
		
//		CCVineyard *v=[[CCVineyard alloc] initWithName:@"New Vineyard" atLocation:<#(CLLocationCoordinate2D)loc#>];
//		[vydList insertObject:v atIndex:0];
		[self.tableView setEditing:YES];
	}
	else {
		UIBarButtonItem *edit=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(setEditingOff)];
		self.navigationItem.rightBarButtonItem=edit;
		[self.tableView setEditing:NO];
	}

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (picker)
	{
		[self.delegate pickedVineyard:self item:indexPath.row];
	}
	else {
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		CCVineyardDetailController *vineyardDetailController=[(CCVineyardDetailController *)[CCVineyardDetailController alloc] initWithVineyard:(CCVineyard *)[vydList objectAtIndex:indexPath.row]];
		vineyardDetailController.delegate=self;
		[self.navigationController pushViewController:vineyardDetailController animated:YES];
		[vineyardDetailController release];
	}

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}
- (void) saveVineyard:(CCVineyard *)theVineyard
{
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vineyardSaved:) name:@"vineyardSaved" object:theVineyard];
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[(CCVineyard *)theVineyard save];
		int position=0;
		for (int i=0;i<[vydList count];i++)
		{
			if ([[[vydList objectAtIndex:i] name] compare:[theVineyard name]]>=0)
			{
				position=i;
				break;
			}
		}
		[vydList insertObject:theVineyard atIndex:position];
//		dispatch_async(dispatch_get_main_queue(), ^{
			NSIndexPath *thePath=[NSIndexPath indexPathForRow:position inSection:0];
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:thePath] withRowAnimation:UITableViewRowAnimationMiddle];
//		});		
//	});	
}

-(void) addRecord
{
	CCVineyard *newVineyard=[[CCVineyard alloc] initWithName:@"NEW VINEYARD"];
	CCVineyardDetailController *controller=[[CCVineyardDetailController alloc] initWithVineyard:newVineyard];
	[newVineyard release];
	controller.delegate=self;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}
	 

-(BOOL)canAddRecords
{
	if (picker) {
		return NO;
	}
	return YES;
}
-(BOOL)tableIsEditable
{
	return NO;
}


- (void)dealloc {
    [vydList release];
    [theIndex release];
    [super dealloc];
}


@end

