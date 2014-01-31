//
//  Event.h
//  Coursera Due
//
//  Created by Yuri Karabatov on 31.01.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSString * eventStatus;
@property (nonatomic, retain) NSString * eventSummary;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSDate * lastModifiedDate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * isHardDeadline;
@property (nonatomic, retain) Course *courseId;

@end
