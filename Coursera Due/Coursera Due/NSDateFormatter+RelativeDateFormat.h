//
//  NSDateFormatter+RelativeDateFormat.h
//  Coursera Due
//
//  Created by Yuri Karabatov on 08.04.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

@import Foundation;

@interface NSDateFormatter (RelativeDateFormat)

- (NSString *)relativeStringFromDateIfPossible:(NSDate *)date;

@end
