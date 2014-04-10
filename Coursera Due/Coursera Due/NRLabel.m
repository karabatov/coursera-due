//
//  NRLabel.m
//  Coursera Due
//
//  Created by Yuri Karabatov on 01.04.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

#import "NRLabel.h"

@implementation NRLabel

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    UIEdgeInsets insets = self.edgeInsets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                    limitedToNumberOfLines:numberOfLines];

    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right) + 8;
    rect.size.height += (insets.top + insets.bottom);

    return rect;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if ( self.numberOfLines == 0 )
    {
        if ( self.preferredMaxLayoutWidth != self.frame.size.width )
        {
            self.preferredMaxLayoutWidth = self.frame.size.width;
            [self setNeedsUpdateConstraints];
        }
    }
}

- (CGSize)intrinsicContentSize
{
    CGSize s = [super intrinsicContentSize];

    if ( self.numberOfLines == 0 )
    {
        // found out that sometimes intrinsicContentSize is 1pt too short!
        s.height += 1;
    }

    return s;
}

@end
