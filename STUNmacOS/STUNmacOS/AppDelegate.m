//
//  AppDelegate.m
//  STUNmacOS
//
//  Created by michael russell on 2017-08-09.
//  Copyright © 2017 ThumbGenius Software. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize uuid = _uuid;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSLog(@"applicationDidFinishLaunching");

    NSURL *path = [[self applicationDirectory] URLByAppendingPathComponent:@"STUNmacOS.txt"];
    NSDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfURL:path];
    if ([dict objectForKey:@"uuid"] == nil)
    {
        NSString* uuid = [[NSUUID UUID] UUIDString];
        dict = [NSDictionary dictionaryWithObjectsAndKeys:uuid, @"uuid", nil];
        if ([dict writeToURL:path atomically:YES] == NO)
        {
            NSLog(@"Error writing UUID file");
        }
    }
    _uuid = [dict objectForKey:@"uuid"];
    epr=[[EndpointResolution alloc] init];

    // request public IP and Port through STUN
    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    stunClient = [[STUNClient alloc] init];
    [stunClient requestPublicIPandPortWithUDPSocket:udpSocket delegate:self];

#if 0
    // launch NIB manually because on macos can't guarentee viewdidload will be called after this func
    NSStoryboard *mainStoryboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSWindowController *initialController = (NSWindowController *)[mainStoryboard instantiateControllerWithIdentifier:@"INIT_WINDOW_CONTROLLER"];
    [initialController.window makeKeyAndOrderFront:self];
    [initialController showWindow:self];
#endif
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
#if 0
-(void) registerApp: (NSString*) uuid _ip:(NSString*) ip _port:(NSString*) port
{
    
    NSString *urlstr=[NSString stringWithFormat:@"http://thumbgenius.dynalias.com/stun/stun.php?cmd=set&uuid=%@&ip=%@&port=%@",
                      [uuid stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],
                       [ip stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],
                        [port stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]
                         ];
    
    NSLog(@"%@", urlstr);
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlstr]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if (!error)
                {
                    NSError *JSONError = nil;
                    
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:0
                                                                                 error:&JSONError];
                    if (JSONError)
                    {
                        NSLog(@"Serialization error: %@", JSONError.localizedDescription);
                    }
                    else
                    {
                        NSLog(@"Response: %@", dictionary);
                        
                    }
                }
                else
                {
                    NSLog(@"Error: %@", error.localizedDescription);
                }
                
                
            }] resume];
    
}
#endif
- (NSURL*)applicationDirectory
{
    NSString* bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSFileManager*fm = [NSFileManager defaultManager];
    NSURL*    dirPath = nil;
    
    // Find the application support directory in the home directory.
    NSArray* appSupportDir = [fm URLsForDirectory:NSApplicationSupportDirectory
                                        inDomains:NSUserDomainMask];
    if ([appSupportDir count] > 0)
    {
        // Append the bundle ID to the URL for the
        // Application Support directory
        dirPath = [[appSupportDir objectAtIndex:0] URLByAppendingPathComponent:bundleID];
        
        // If the directory does not exist, this method creates it.
        // This method is only available in macOS 10.7 and iOS 5.0 or later.
        NSError*    theError = nil;
        if (![fm createDirectoryAtURL:dirPath withIntermediateDirectories:YES
                           attributes:nil error:&theError])
        {
            // Handle the error.
            
            return nil;
        }
    }
    
    return dirPath;
}

#pragma mark -
#pragma mark STUNClientDelegate

-(void)didReceivePublicIPandPort:(NSDictionary *) data{
    NSLog(@"Public IP=%@, public Port=%@, NAT is Symmetric: %@", [data objectForKey:publicIPKey],
          [data objectForKey:publicPortKey], [data objectForKey:isPortRandomization]);
#if 0
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"result"];
    [alert setInformativeText:[data description]];
    [alert addButtonWithTitle:@"Ok"];
    [alert runModal];
#endif
    
    [stunClient startSendIndicationMessage];

    
    [epr registerApp:_uuid _ip:[data objectForKey:publicIPKey] _port:[data objectForKey:publicPortKey]];
}

@end
