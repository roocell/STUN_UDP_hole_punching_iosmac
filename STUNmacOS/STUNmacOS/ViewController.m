//
//  ViewController.m
//  STUNmacOS
//
//  Created by michael russell on 2017-08-09.
//  Copyright © 2017 ThumbGenius Software. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@implementation ViewController
@synthesize tableView=_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    puncher = [[UDPHolePuncher alloc] init];
    epr=[[EndpointResolution alloc] init];

    // hack to delay table refresh for app start
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // call fetch with callback func
        [epr fetchEndpoints:^(NSMutableArray* data) {
            [self.tableView reloadData];
            
#if 0
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            // dispatch table reload
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                dispatch_apply([_data count], queue, ^(size_t i) {
                    [_tableView reloadData];
                });
            });
#endif
        }];
       
        

        
    });
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSLog(@"%lu", [epr.data count]);
    return [epr.data count];
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    NSLog(@"loading table");
    // Retrieve to get the @"MyView" from the pool or,
    // if no version is available in the pool, load the Interface Builder version
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"ENDPOINT_CELL" owner:self];
    
    // Set the stringValue of the cell's text field to the nameArray value at row
    
    NSDictionary* ep=[epr.data objectAtIndex:row];
    NSLog(@"%@", [ep objectForKey:@"uuid"]);
    result.textField.stringValue = [ep objectForKey:@"uuid"];
    
    // Return the result
    return result;
    
}

-(BOOL) tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    NSDictionary* endpoint = [epr.data objectAtIndex:row];
    
    NSLog(@"Poke Hole to %@", [endpoint objectForKey:@"uuid"]);

    // let's make sure port is a real number because we've got it from json
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *port = [f numberFromString:[endpoint objectForKey:@"port"]];
    if (port == nil) NSLog(@"ERROR - port is not a number %@", [endpoint objectForKey:@"port"]);

    [puncher startUDPHolePunch:[endpoint objectForKey:@"ip"] _port:port];

    return TRUE;
}
@end
