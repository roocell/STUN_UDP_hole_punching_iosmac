//
//  TableViewController.h
//  STUNios
//
//  Created by michael russell on 2017-08-10.
//  Copyright © 2017 ThumbGenius Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UDPHolePuncher.h"
#import "EndpointResolution.h"

@interface TableViewController : UITableViewController
{
    UDPHolePuncher*  puncher;
    EndpointResolution* epr;
}

@end
