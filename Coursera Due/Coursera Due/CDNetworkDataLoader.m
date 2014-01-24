//
//  CDNetworkDataLoader.m
//  Coursera Due
//
//  Created by Yuri Karabatov on 23.01.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

#import "CDNetworkDataLoader.h"
#import "CDOAuthConstants.h"
#import "AFOAuth2Client/AFOAuth2Client.h"
#import "MXLCalendarManager/MXLCalendarManager.h"
#import "Event.h"
#import "Course.h"

static CDNetworkDataLoader *sharedLoader = nil;

@interface CDNetworkDataLoader ()

@property (nonatomic, strong, readwrite) RKObjectManager *maestroManager;
@property (nonatomic, strong, readwrite) RKObjectManager *enrollmentManager;

@end

@implementation CDNetworkDataLoader

+ (instancetype)sharedLoader
{
    return sharedLoader;
}

+ (void)setSharedLoader:(CDNetworkDataLoader *)loader
{
    sharedLoader = loader;
}

- (id)initWithCoursera
{
    self = [super init];
    if (self) {

        // Setup new RKObjectManager for Courses and Topics

        NSURL *maestroBaseURL = [NSURL URLWithString:@"https://www.coursera.org"];
        RKObjectManager *maestroNewManager = [RKObjectManager managerWithBaseURL:maestroBaseURL];
        maestroNewManager.managedObjectStore = [RKManagedObjectStore defaultStore];

        // Entity mapping: Topic

        RKEntityMapping *topicMapping = [RKEntityMapping mappingForEntityForName:@"Topic"
                                                            inManagedObjectStore:[RKManagedObjectStore defaultStore]];
        topicMapping.forceCollectionMapping = YES;
        [topicMapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"id"];
        [topicMapping addAttributeMappingsFromDictionary:@{
                                                           @"(id).name": @"name",
                                                           @"(id).photo": @"photo",
                                                           @"(id).large_icon": @"largeIcon"
                                                           }];
        topicMapping.identificationAttributes = @[ @"id" ];

        RKResponseDescriptor *topicDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:topicMapping method:RKRequestMethodAny pathPattern:@"/maestro/api/topic/list2" keyPath:@"topics" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [maestroNewManager addResponseDescriptor:topicDescriptor];

        // Entity mapping: simple Topic

        RKEntityMapping *simpleTopicMapping = [RKEntityMapping mappingForEntityForName:@"Topic"
                                                                  inManagedObjectStore:[RKManagedObjectStore defaultStore]];
        [simpleTopicMapping addAttributeMappingsFromDictionary:@{
                                                                 @"topic_id": @"id",
                                                                 }];
        simpleTopicMapping.identificationAttributes = @[ @"id" ];

        // Entity mapping: Course

        RKEntityMapping *courseMapping = [RKEntityMapping mappingForEntityForName:@"Course"
                                                             inManagedObjectStore:[RKManagedObjectStore defaultStore]];
        [courseMapping addAttributeMappingsFromDictionary:@{
                                                            @"id": @"id",
                                                            @"home_link": @"homeLink",
                                                            }];
        courseMapping.identificationAttributes = @[ @"id" ];
        [courseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil
                                                                                      toKeyPath:@"topicId"
                                                                                    withMapping:simpleTopicMapping]];

        RKResponseDescriptor *courseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:courseMapping method:RKRequestMethodAny pathPattern:@"/maestro/api/topic/list2" keyPath:@"courses" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [maestroNewManager addResponseDescriptor:courseDescriptor];

        self.maestroManager = maestroNewManager;

        // Setup new RKObjectManager for Enrollments

        NSURL *enrollmentBaseURL = [NSURL URLWithString:@"https://api.coursera.org"];
        RKObjectManager *enrollmentNewManager = [RKObjectManager managerWithBaseURL:enrollmentBaseURL];
        enrollmentNewManager.managedObjectStore = [RKManagedObjectStore defaultStore];

        // Entity mapping: simple Topic 2

        RKEntityMapping *simpleTopicMapping2 = [RKEntityMapping mappingForEntityForName:@"Topic"
                                                                   inManagedObjectStore:[RKManagedObjectStore defaultStore]];
        [simpleTopicMapping2 addAttributeMappingsFromDictionary:@{
                                                                  @"courseId": @"id",
                                                                  }];
        simpleTopicMapping2.identificationAttributes = @[ @"id" ];


        // Entity mapping: simple Course

        RKEntityMapping *simpleCourseMapping = [RKEntityMapping mappingForEntityForName:@"Course"
                                                                   inManagedObjectStore:[RKManagedObjectStore defaultStore]];
        [simpleCourseMapping addAttributeMappingsFromDictionary:@{
                                                                  @"sessionId": @"id",
                                                                  }];
        simpleCourseMapping.identificationAttributes = @[ @"id" ];

        // Entity mapping: Enrollment

        RKEntityMapping *enrollmentMapping = [RKEntityMapping mappingForEntityForName:@"Enrollment"
                                                                 inManagedObjectStore:[RKManagedObjectStore defaultStore]];
        [enrollmentMapping addAttributeMappingsFromDictionary:@{
                                                                @"id": @"id",
                                                                @"isSigTrack": @"isSignatureTrack",
                                                                @"startDate": @"startDate",
                                                                @"endDate": @"endDate",
                                                                @"startStatus": @"startStatus"
                                                                }];
        enrollmentMapping.identificationAttributes = @[ @"id" ];
        [enrollmentMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil
                                                                                          toKeyPath:@"sessionId"
                                                                                        withMapping:simpleCourseMapping]];
        [enrollmentMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil
                                                                                          toKeyPath:@"courseId"
                                                                                        withMapping:simpleTopicMapping2]];

        RKResponseDescriptor *enrollmentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:enrollmentMapping method:RKRequestMethodAny pathPattern:@"/api/users/v1/me/enrollments" keyPath:@"enrollments" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [enrollmentNewManager addResponseDescriptor:enrollmentDescriptor];

        self.enrollmentManager = enrollmentNewManager;

        // Hydrate the Shared Loader

        if (nil == sharedLoader) {
            [CDNetworkDataLoader setSharedLoader:self];
        }
    }

    return self;
}

- (void)getMyEnrollments
{
    // Initialize OAuth2 client for testing purposes

    NSURL *url = [NSURL URLWithString:@"https://accounts.coursera.org"];
    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:kClientId secret:kClientSecret];

    void (^oauthSuccessBlock)(AFOAuthCredential*) = ^(AFOAuthCredential *credential) {
        NSLog(@"I have a token! %@", credential.accessToken);
        [AFOAuthCredential storeCredential:credential withIdentifier:oauthClient.serviceProviderIdentifier];

        // Setup authorization for Enrollments

        [self.enrollmentManager.HTTPClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", credential.accessToken]];

        // Perform request

        void (^oroSuccessBlock)(RKObjectRequestOperation*, RKMappingResult*) = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [self performSelectorInBackground:@selector(getDeadlines) withObject:nil];
        };
        [self.enrollmentManager getObjectsAtPath:@"/api/users/v1/me/enrollments"
                                      parameters:nil
                                         success:oroSuccessBlock
                                         failure:nil];
    };

    dispatch_queue_t gcdBackgroundQueue = dispatch_queue_create("GCDBkgrQueue", NULL);
    dispatch_async(gcdBackgroundQueue, ^(void){
        [oauthClient authenticateUsingOAuthWithPath:@"/oauth2/v1/token"
                                           username:kClientEmail
                                           password:kClientPassword
                                              scope:@"password"
                                            success:oauthSuccessBlock
                                            failure:^(NSError *error) {
                                                NSLog(@"Error: %@", error);
                                            }];
    });
}

- (void)getDeadlines
{
    // Example link: https://class.coursera.org/crypto-009/api/course/calendar
    // Example link: https://class.coursera.org/circuits-003/api/course/calendar

    NSManagedObjectContext *bgMOC = [[RKManagedObjectStore defaultStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:YES];
    NSFetchRequest *courseFetchRequest = [[NSFetchRequest alloc] init];
    [courseFetchRequest setEntity:
     [NSEntityDescription entityForName:@"Course" inManagedObjectContext:bgMOC]];
    [courseFetchRequest setPredicate: [NSPredicate predicateWithFormat: @"(homeLink != nil) && (sessionId) != nil"]];
    NSError *error;
    NSArray *coursesMatching = [bgMOC executeFetchRequest:courseFetchRequest error:&error];

    for (Course *course in coursesMatching) {
        NSLog(@"--------- In coursesMatching");
        NSURL *url = [[NSURL URLWithString:course.homeLink] URLByAppendingPathComponent:@"api/course/calendar"];
        NSLog(@"course homeLink: %@", course.homeLink);
        MXLCalendarManager *calendarManager = [[MXLCalendarManager alloc] init];
        [calendarManager scanICSFileAtRemoteURL:url withCompletionHandler:^(MXLCalendar *calendar, NSError *error) {
            if (!error) {
                //NSLog(@"Calendar event uid, summary: %@ — %@", event.eventUniqueID, event.eventSummary);

                // As in https://developer.apple.com/library/mac/documentation/cocoa/conceptual/CoreData/Articles/cdImporting.html

                // Get the events to parse in sorted order
                NSMutableArray *eventUIds = [[NSMutableArray alloc] init];
                for (MXLCalendarEvent *event in calendar.events) {
                    [eventUIds addObject:event.eventUniqueID];
                }
                NSArray *eventIds = [eventUIds sortedArrayUsingSelector:@selector(compare:)];

                NSSortDescriptor *sortDescriptor =
                [NSSortDescriptor sortDescriptorWithKey:@"eventUniqueID"
                                              ascending:YES
                                               selector:@selector(compare:)];
                NSArray *calendarEventsSorted = [calendar.events sortedArrayUsingDescriptors:@[sortDescriptor]];

                // create the fetch request to get all Events matching the IDs
                NSManagedObjectContext *aMOC = [[RKManagedObjectStore defaultStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:YES];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                [fetchRequest setEntity:
                 [NSEntityDescription entityForName:@"Event" inManagedObjectContext:aMOC]];
                [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"(id IN %@)", eventIds]];

                // Make sure the results are sorted as well.
                [fetchRequest setSortDescriptors:
                 @[ [[NSSortDescriptor alloc] initWithKey: @"id" ascending:YES] ]];
                // Execute the fetch.
                NSError *error;
                NSArray *eventsMatching = [aMOC executeFetchRequest:fetchRequest error:&error];

                int i = 0;
                int j = 0;

                while ((i < [eventIds count]) && (j <= [eventsMatching count])){

                    NSString *eventId = [eventIds objectAtIndex:i];

                    Event *newEvt = nil;

                    if ([eventsMatching count] != 0)
                        newEvt = [eventsMatching objectAtIndex:j];

                    if (![eventId isEqualToString:newEvt.id]){

                        //Insert new Employee entity into context
                        newEvt = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:aMOC];
                        newEvt.id = eventId;
                        MXLCalendarEvent *event = [calendarEventsSorted objectAtIndex:i];
                        newEvt.startDate = event.eventStartDate;
                        newEvt.endDate = event.eventEndDate;
                        newEvt.createDate = event.eventCreatedDate;
                        newEvt.lastModifiedDate = event.eventLastModifiedDate;
                        newEvt.eventSummary = event.eventSummary;
                        newEvt.eventDescription = event.eventDescription;
                        newEvt.eventStatus = event.eventStatus;

                        // Now set the proper Course ID
                        NSString *courseIdString = [[eventId componentsSeparatedByString:@"|"] objectAtIndex:0];
                        NSNumber *courseId = [NSNumber numberWithInteger:[courseIdString integerValue]];
                        NSFetchRequest *courseFetchRequest = [[NSFetchRequest alloc] init];
                        [courseFetchRequest setEntity:
                         [NSEntityDescription entityForName:@"Course" inManagedObjectContext:aMOC]];
                        [courseFetchRequest setPredicate: [NSPredicate predicateWithFormat: @"(id == %@)", courseId]];

                        // Make sure the results are sorted as well.
                        [courseFetchRequest setSortDescriptors:
                         @[ [[NSSortDescriptor alloc] initWithKey: @"id" ascending:YES] ]];
                        // Execute the fetch.
                        NSError *error;
                        NSArray *coursesMatching = [aMOC executeFetchRequest:courseFetchRequest error:&error];
                        for (Course *course in coursesMatching) {
                            if ([course.id isEqualToNumber:courseId]) {
                                newEvt.courseId = course;
                                break;
                            }
                        }
                        NSLog(@"newEvt = %@", newEvt);
                    }
                    else {
                        //We matched eventId to Event so the next iteration
                        //of this loop should check the next Event object
                        j++;
                    }
                    
                    //Set any attributes for event that change with each update
                    
                    i++;
                }

                [aMOC save:&error];
                [aMOC saveToPersistentStore:&error];
            }
        }];
    }
}

- (void)getDataInBackground
{
    // Get & parse Courses and Topics first
    dispatch_queue_t gcdBackgroundQueue = dispatch_queue_create("GCDBkgrQueue", NULL);
    dispatch_async(gcdBackgroundQueue, ^(void){
        void (^oroSuccessBlock)(RKObjectRequestOperation*, RKMappingResult*) = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            //NSLog(@"Mapping Result: %@", mappingResult.array);
            // Now get & parse Enrollments
            [self getMyEnrollments];
        };
        [self.maestroManager getObjectsAtPath:@"/maestro/api/topic/list2"
                                   parameters:nil
                                      success:oroSuccessBlock
                                      failure:nil];
    });
}

@end
