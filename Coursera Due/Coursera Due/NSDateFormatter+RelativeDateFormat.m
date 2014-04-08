//
//  NSDateFormatter+RelativeDateFormat.m
//  Coursera Due
//
//  Created by Yuri Karabatov on 08.04.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

#import "NSDateFormatter+RelativeDateFormat.h"

@implementation NSDateFormatter (RelativeDateFormat)

- (NSString *)relativeStringFromDateIfPossible:(NSDate *)date
{
    static NSDateFormatter *relativeFormatter;
    static NSDateFormatter *absoluteFormatter;

    if(!relativeFormatter) {
        const NSDateFormatterStyle arbitraryStyle = NSDateFormatterShortStyle;

        relativeFormatter = [[NSDateFormatter alloc] init];
        [relativeFormatter setDateStyle:arbitraryStyle];
        [relativeFormatter setTimeStyle:NSDateFormatterShortStyle];
        [relativeFormatter setDoesRelativeDateFormatting:YES];

        absoluteFormatter = [[NSDateFormatter alloc] init];
        [absoluteFormatter setDateStyle:arbitraryStyle];
        [absoluteFormatter setTimeStyle:NSDateFormatterShortStyle];
        [absoluteFormatter setDoesRelativeDateFormatting:NO];
    }

    NSLocale *const locale = [self locale];
    if([relativeFormatter locale] != locale) {
        [relativeFormatter setLocale:locale];
        [absoluteFormatter setLocale:locale];
    }

    NSCalendar *const calendar = [self calendar];
    if([relativeFormatter calendar] != calendar) {
        [relativeFormatter setCalendar:calendar];
        [absoluteFormatter setCalendar:calendar];
    }

    NSString *const maybeRelativeDateString = [relativeFormatter stringFromDate:date];
    const BOOL isRelativeDateString = ![maybeRelativeDateString isEqualToString:[absoluteFormatter stringFromDate:date]];

    if (isRelativeDateString) {
        return maybeRelativeDateString;
    }
    else {
        return [self stringFromDate:date];
    }
}
@end
