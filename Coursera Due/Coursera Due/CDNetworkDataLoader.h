//
//  CDNetworkDataLoader.h
//  Coursera Due
//
//  Created by Yuri Karabatov on 23.01.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

@import Foundation;

@interface CDNetworkDataLoader : NSObject

///---------------------------------------------
/// @name Configuring the Shared Loader Instance
///---------------------------------------------

/**
 Return the shared instance of the network loader

 @return The shared loader instance.
 */
+ (instancetype)sharedLoader;

/**
 Set the shared instance of the networkLoader

 @param loader The new shared loader instance.
 */
+ (void)setSharedLoader:(CDNetworkDataLoader *)loader;

- (id)initWithCoursera;
- (void)getDataInBackground;

@end
