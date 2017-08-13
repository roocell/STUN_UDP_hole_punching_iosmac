//
//  AppDelegate.h
//  STUNios
//
//  Created by michael russell on 2017-08-10.
//  Copyright © 2017 ThumbGenius Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STUNClient.h"
#import "GCDAsyncUdpSocket.h"
#import "EndpointResolution.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, STUNClientDelegate>
{
    STUNClient *stunClient;
    GCDAsyncUdpSocket *udpSocket;
    EndpointResolution* epr;
}
@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) NSString* uuid;


@end

