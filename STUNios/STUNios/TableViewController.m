//
//  TableViewController.m
//  STUNios
//
//  Created by michael russell on 2017-08-10.
//  Copyright © 2017 ThumbGenius Software. All rights reserved.
//

#import "TableViewController.h"
#import "AppDelegate.h"

@interface TableViewController ()

@end

@implementation TableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    puncher = [[UDPHolePuncher alloc] init];
    
    epr=[[EndpointResolution alloc] init];

    [epr fetchEndpoints:^(NSMutableArray* data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [epr.data count];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    NSDictionary* endpoint = [epr.data objectAtIndex:[indexPath row]];
    
    NSLog(@"Poke Hole to %@ ", [endpoint objectForKey:@"uuid"]);
    
    // let's make sure port is a real number because we've got it from json
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *port = [f numberFromString:[endpoint objectForKey:@"port"]];
    if (port == nil) NSLog(@"ERROR - port is not a number %@", [endpoint objectForKey:@"port"]);
    
    [puncher startUDPHolePunch:[endpoint objectForKey:@"ip"] _port:port];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ENDPOINT_CELL" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDictionary* ep=[epr.data objectAtIndex:[indexPath row]];
    NSLog(@"%@", [ep objectForKey:@"uuid"]);
    cell.textLabel.text = [ep objectForKey:@"uuid"];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;

    return cell;
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
