//
//  Enrollment.h
//  Coursera Due
//
//  Created by Yuri Karabatov on 02.02.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course, Topic;

@interface Enrollment : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * isSignatureTrack;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * startStatus;
@property (nonatomic, retain) Topic *courseId;
@property (nonatomic, retain) Course *sessionId;

@end
