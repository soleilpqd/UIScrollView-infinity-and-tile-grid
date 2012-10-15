//
//  MasterViewController.m
//  myInfinityScroller
//
//  Created by Soleil on 10/8/12.
//  Copyright (c) 2012 Soleil. All rights reserved.
//

#import "MasterViewController.h"
#import "Test1ViewController.h"
#import "Test2ViewController.h"
#import "TokyoMapViewController.h"
#import "TimeSelectorViewController.h"
#import "Earth360ViewController.h"

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.title = NSLocalizedString(@"Selet a huge image", @"Master");
    }
    return self;
}
							
- (void)dealloc
{
    [super dealloc];
}

- ( void )viewDidDisappear:(BOOL)animated {
    [ super viewDidDisappear:animated ];
    self.title = @"Back";
}

- ( void )viewWillAppear:(BOOL)animated {
    [ super viewWillAppear:animated ];
    self.title = @"Tiled view";
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- ( BOOL )shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch ( section ) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
    }
    return 0;
}

- ( NSString* )tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch ( section ) {
        case 0:
            return @"Testing";
            break;
        case 1:
            return @"Simple tile view example";
            break;
		case 2:
			return @"Infinity tile view example";
			break;
    }
    return nil;
}

- ( NSString* )tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	switch ( section ) {
        case 0:
            return @"Show multi-colors grid view";
            break;
        case 1:
            return @"Map images exported from openstreetmap.org";
            break;
		case 2:
			return @"Image found via Google Images";
			break;
    }
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch ( indexPath.section ) {
        case 0:
            switch ( indexPath.row ) {
                case 0:
                    cell.textLabel.text = @"Simple tile view";                    
                    break;
                case 1:
                    cell.textLabel.text = @"Infinity tile view";
                    break;
            }
            break;
        case 1:
            cell.textLabel.text = @"Tokyo tile map";
            break;
        case 2:
            switch ( indexPath.row ) {
                case 0:
                    cell.textLabel.text = @"Time selector";
                    break;
                case 1:
                    cell.textLabel.text = @"Earth 360";
                    break;
            }
            break;
    }
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ tableView deselectRowAtIndexPath:indexPath animated:YES ];
	switch ( indexPath.section ) {
		case 0:
			switch ( indexPath.row ) {
				case 0:
				{
					Test1ViewController *controller = [[ Test1ViewController alloc ] initWithNibName:@"Test1ViewController"
																							  bundle:nil ];
					[ self.navigationController pushViewController:controller animated:YES ];
					[ controller release ];
				}
					break;
				case 1:
				{
					Test2ViewController *controller = [[ Test2ViewController alloc ] initWithNibName:@"Test2ViewController"
																							  bundle:nil ];
					[ self.navigationController pushViewController:controller animated:YES ];
					[ controller release ];
				}
					break;
			}
			break;
		case 1:
        {
            TokyoMapViewController *controller = [[ TokyoMapViewController alloc ] initWithNibName:@"TokyoMapViewController"
                                                                                            bundle:nil ];
            [ self.navigationController pushViewController:controller animated:YES ];
            [ controller release ];
        }
			break;
		case 2:
            switch ( indexPath.row ) {
                case 0:
                {
                    TimeSelectorViewController *controller = [[ TimeSelectorViewController alloc ] initWithNibName:@"TimeSelectorViewController"
                                                                                                            bundle:nil ];
                    [ self.navigationController pushViewController:controller animated:YES ];
                    [ controller release ];
                }
                    break;
                case 1:
                {
                    Earth360ViewController *controller = [[ Earth360ViewController alloc ] initWithNibName:@"Earth360ViewController"
                                                                                                    bundle:nil ];
                    [ self.navigationController pushViewController:controller animated:YES ];
                    [ controller release ];
                }
                    break;
            }
			break;
	}
}

@end
