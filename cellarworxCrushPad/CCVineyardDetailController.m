//
//  VineyardDetail.m
//  Crush
//
//  Created by Kevin McQuown on 8/9/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCVineyardDetailController.h"
#import "CCVineyard.h"
#import "CCVineyardController.h"

@implementation CCVineyardDetailController
@synthesize vineyard;
@synthesize theTable;
@synthesize delegate;

-(id) initWithVineyard:(CCVineyard *)v
{
	self=[super initWithNibName:@"CCVineyardDetailController" bundle:nil];
	vineyard=[[CCVineyard alloc] initWithVineyard:v];
    return self;
}	

-(void) TextEntered:(TextFieldController *)controller forField:(NSString *)fn
{
	if ([fn isEqualToString:@"vyd"])
		[self.vineyard setName:[controller.theTextField.text uppercaseString]];		
	if ([fn isEqualToString:@"gatecode"])
		[self.vineyard setGateCode:controller.theTextField.text];		
	[self.navigationController popViewControllerAnimated:YES];
	UIBarButtonItem	*saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem=saveButton;

	[self.theTable reloadData];
}

-(void) save
{
	[self.navigationController popViewControllerAnimated:YES];
	[self.delegate saveVineyard:vineyard];
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	NSArray *rowCounts=[[[NSArray alloc] initWithObjects:
						[[[NSNumber alloc] initWithInt:3] autorelease],
						[[[NSNumber alloc] initWithInt:3] autorelease],
						[[[NSNumber alloc] initWithInt:1] autorelease],
						nil] autorelease];
	return [[rowCounts objectAtIndex:section] intValue];
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	
	switch (indexPath.section) {
		case 0:
		{
			switch (indexPath.row) {
				case 0:
				{
					cell.textLabel.text=@"Name:";
					cell.detailTextLabel.text=vineyard.name;
					break;
				}
				case 1:
				{
					cell.textLabel.text=@"Organic:";
					if (vineyard.organic)
						cell.accessoryType=UITableViewCellAccessoryCheckmark;
					cell.detailTextLabel.text=@"";
					break;
				}
				case 2:
				{
					cell.textLabel.text=@"Biodynamic:";
					if (vineyard.biodynamic)
						cell.accessoryType=UITableViewCellAccessoryCheckmark;
					cell.detailTextLabel.text=@"";
					break;
				}
				break;
			}
			break;
		}
		case 1:
		{
			switch (indexPath.row) {
				case 0:
				{
					cell.textLabel.text=@"Location:";
					cell.detailTextLabel.text=[NSString stringWithFormat:@"%6.3f, %6.3f",vineyard.coordinate.latitude,vineyard.coordinate.longitude];
					break;
				}
				case 1:
				{
					cell.textLabel.text=@"Appellation:";
					cell.detailTextLabel.text=[NSString stringWithString:vineyard.appellation];
					cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
					break;
				}
				case 2:
				{
					cell.textLabel.text=@"Region:";
					cell.detailTextLabel.text=[NSString stringWithString:vineyard.region];
					cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
					break;
				}
			}	
			break;
		}
		case 2:
		{
			switch (indexPath.row) {
				case 0:
				{
					cell.textLabel.text=@"Gate Code:";
					cell.detailTextLabel.text=[NSString stringWithString:vineyard.gateCode];
					break;
				}
			}
		}
	}
    return cell;
}


-(void)setNewLocation:(CLLocationCoordinate2D)loc
{
	[vineyard setNewLocation:loc];
	UIBarButtonItem	*saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem=saveButton;

	[self.theTable reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	[self.theTable deselectRowAtIndexPath:indexPath animated:YES];
	ChecklistController *tc=nil;
	switch (indexPath.section) {
		case 0:
		{
			switch (indexPath.row) {
				case 0:
				{
					TextFieldController *controller=[[TextFieldController alloc] initWithNibName:@"TextFieldController"
																						  bundle:nil
																				 withInitialText:vineyard.name
																						forField:@"vyd"
																					keyBoardType:UIKeyboardTypeDefault];
					controller.delegate=self;
					[self.navigationController pushViewController:controller animated:YES];
					[controller release];
				}
				case 1:
				{
					if (vineyard.organic)
						vineyard.organic=NO;
					else 
						vineyard.organic=YES;
					[self.theTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
					UIBarButtonItem	*saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
					self.navigationItem.rightBarButtonItem=saveButton;
					break;
				}
				case 2:
				{
					if (vineyard.biodynamic)
						vineyard.biodynamic=NO;
					else 
						vineyard.biodynamic=YES;
					[self.theTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
					UIBarButtonItem	*saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
					self.navigationItem.rightBarButtonItem=saveButton;
					break;
				}
					break;
			}
			break;
		}
		case 1:
		{
			switch (indexPath.row) {
				case 0:
				{
					CCVineyardController *vc=[[CCVineyardController alloc] 
											  initWithVineyards:[NSArray arrayWithObjects:vineyard,nil] centerVineyard:vineyard];
					vc.hidesBottomBarWhenPushed=YES;
					vc.delegate=self;
					[self.navigationController pushViewController:vc animated:YES];
					[vc release];
					break;
				}
				case 1:
				{
//					ChecklistController *theController = [[ChecklistController alloc] initWithList:[CrushHelper fetchList:@"APPELLATION"
//																												fromTable:@""]
//																					  withListName:@"APPELLATION"
//																					   withChecked:vineyard.appellation];
					tc = [[ChecklistController alloc] initWithListName:@"APPELLATION" withChecked:vineyard.appellation];
					tc.delegate=self;
					[self.navigationController pushViewController:tc animated:YES];
					[tc release];
					break;
				}
				case 2:
				{
					tc = [[ChecklistController alloc] initWithListName:@"REGIONCODE" withChecked:vineyard.region];
					tc.delegate=self;
					[self.navigationController pushViewController:tc animated:YES];
					[tc release];
					break;
					
				}
			}	
			break;
		}
		case 2:
		{
			switch (indexPath.row) {
				case 0:
				{
					TextFieldController *controller=[[TextFieldController alloc] initWithNibName:@"TextFieldController"
																						  bundle:nil
																				 withInitialText:vineyard.gateCode
																						forField:@"gatecode"
																					keyBoardType:UIKeyboardTypeDefault];
					controller.delegate=self;
					[self.navigationController pushViewController:controller animated:YES];
					[controller release];
				}
			}
		}
	}
//	[tc release];
}

-(void) PositionChecked:(ChecklistController *)controller checkedItem:(NSString *)item
{
	UIBarButtonItem	*saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem=saveButton;
	
	if ([controller.checkListName isEqualToString:@"APPELLATION"]) {
		[vineyard setAppellation:item];
	} else if ([controller.checkListName isEqualToString:@"REGIONCODE"]) {
		[vineyard setRegion:item];
	}
	
	[self.navigationController popViewControllerAnimated:YES];
	[self.theTable reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [vineyard release];
	[theTable release];
    [super dealloc];
}


@end

