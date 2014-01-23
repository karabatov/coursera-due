//
//  CDAppDelegate.m
//  Coursera Due
//
//  Created by Yuri Karabatov on 22.01.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

#import "CDAppDelegate.h"
#import "AFOAuth2Client/AFOAuth2Client.h"
#import "CDOAuthConstants.h"
#import "CDNetworkDataLoader.h"

@implementation CDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure RestKit Logging
    
    //RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    // Initialize Managed Object Store

    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Model" ofType:@"momd"]];
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];

    // Initialize Persistent Store

    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"CourseraDue.sqlite"];
    NSError *error;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    [managedObjectStore createManagedObjectContexts];
    [RKManagedObjectStore setDefaultStore:managedObjectStore];

    // Initialize Network Data Loader

    CDNetworkDataLoader *networkDataLoader = [[CDNetworkDataLoader alloc] initWithCoursera];
    [CDNetworkDataLoader setSharedLoader:networkDataLoader];

    // Get data

    [[CDNetworkDataLoader sharedLoader] getPublicCourses];
    [[CDNetworkDataLoader sharedLoader] getMyEnrollments];
    [[CDNetworkDataLoader sharedLoader] getDeadlines];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
