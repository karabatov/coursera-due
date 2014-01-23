//
//  Enrollment.h
//  Coursera Due
//
//  Created by Yuri Karabatov on 22.01.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course, Topic;

@interface Enrollment : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * isSignatureTrack;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSString * startStatus;
@property (nonatomic, retain) Course *sessionId;
@property (nonatomic, retain) Topic *courseId;

@end
