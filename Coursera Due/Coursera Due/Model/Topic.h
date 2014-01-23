//
//  Topic.h
//  Coursera Due
//
//  Created by Yuri Karabatov on 22.01.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course, Enrollment;

@interface Topic : NSManagedObject

@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSString * largeIcon;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Enrollment *courseId;
@property (nonatomic, retain) NSSet *topicId;
@end

@interface Topic (CoreDataGeneratedAccessors)

- (void)addTopicIdObject:(Course *)value;
- (void)removeTopicIdObject:(Course *)value;
- (void)addTopicId:(NSSet *)values;
- (void)removeTopicId:(NSSet *)values;

@end
