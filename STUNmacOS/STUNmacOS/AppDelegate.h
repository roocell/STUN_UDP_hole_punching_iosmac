//
//  AppDelegate.h
//  STUNmacOS
//
//  Created by michael russell on 2017-08-09.
//  Copyright © 2017 ThumbGenius Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "STUNClient.h"
#import "GCDAsyncUdpSocket.h"
#import "EndpointResolution.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, STUNClientDelegate>{
    STUNClient *stunClient;
    GCDAsyncUdpSocket *udpSocket;
    EndpointResolution* epr;
}
@property (retain, nonatomic) NSString* uuid;


@end

