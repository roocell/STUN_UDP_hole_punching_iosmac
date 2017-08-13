//
//  AppDelegate.m
//  STUNios
//
//  Created by michael russell on 2017-08-10.
//  Copyright © 2017 ThumbGenius Software. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize uuid = _uuid;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"STUNios"];
    if ([dict objectForKey:@"uuid"] == nil)
    {
        NSString* uuid = [[NSUUID UUID] UUIDString];
        dict = [NSDictionary dictionaryWithObjectsAndKeys:uuid, @"uuid", nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"STUNios"];
    }
    _uuid = [dict objectForKey:@"uuid"];
    epr=[[EndpointResolution alloc] init];

    
    // request public IP and Port through STUN
    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    stunClient = [[STUNClient alloc] init];
    [stunClient requestPublicIPandPortWithUDPSocket:udpSocket delegate:self];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -
#pragma mark STUNClientDelegate

// to do UI from appDel (need a view to work on)
- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

-(void)didReceivePublicIPandPort:(NSDictionary *) data{
    NSLog(@"Public IP=%@, public Port=%@, NAT is Symmetric: %@", [data objectForKey:publicIPKey],
          [data objectForKey:publicPortKey], [data objectForKey:isPortRandomization]);
        
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"result"
                                                message:[data description]
                                                preferredStyle:UIAlertControllerStyleAlert ];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here, eg dismiss the alertwindow
                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [myAlertController addAction: ok];
    [[self topMostController] presentViewController:myAlertController animated:YES completion:nil];

    
    [epr registerApp:_uuid _ip:[data objectForKey:publicIPKey] _port:[data objectForKey:publicPortKey]];
    
    [stunClient startSendIndicationMessage];
}

@end
