//
//  ViewController.h
//  STUNmacOS
//
//  Created by michael russell on 2017-08-09.
//  Copyright © 2017 ThumbGenius Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UDPHolePuncher.h"
#import "EndpointResolution.h"

@interface ViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>
{
    UDPHolePuncher*  puncher;
    EndpointResolution* epr;
}

@property (retain, nonatomic) IBOutlet NSTableView*  tableView;

@end

