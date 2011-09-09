//
//  DescriptionCell.h
//  CCC2
//
//  Created by Kevin McQuown on 5/18/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kDescriptionFontSize 12


@interface DescriptionCell : UITableViewCell  {

	IBOutlet UITextView *theDescription;
	
}

@property (nonatomic, retain) UITextView *theDescription;

@end
