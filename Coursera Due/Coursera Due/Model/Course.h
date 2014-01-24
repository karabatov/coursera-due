//
//  Course.h
//  Coursera Due
//
//  Created by Yuri Karabatov on 25.01.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Enrollment, Event, Topic;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * homeLink;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSSet *eventId;
@property (nonatomic, retain) Enrollment *sessionId;
@property (nonatomic, retain) Topic *topicId;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addEventIdObject:(Event *)value;
- (void)removeEventIdObject:(Event *)value;
- (void)addEventId:(NSSet *)values;
- (void)removeEventId:(NSSet *)values;

@end
