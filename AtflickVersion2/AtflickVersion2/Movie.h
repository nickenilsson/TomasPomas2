//
//  Movie.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/3/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"

@interface Movie : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSArray *actors;


@end
