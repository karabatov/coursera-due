//
//  Course.h
//  Coursera Due
//
//  Created by Yuri Karabatov on 22.01.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Enrollment, Topic;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * homeLink;
@property (nonatomic, retain) Enrollment *sessionId;
@property (nonatomic, retain) Topic *topicId;

@end
