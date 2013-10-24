//
//  MovieDAO.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/14/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "MovieDAO.h"
#import "Movie.h"

@implementation MovieDAO

+(NSMutableArray *) getHeadliningMovies
{
    NSMutableArray *movies = [NSMutableArray arrayWithCapacity:3];
    
    Movie *movie2 = [[Movie alloc]init];
    movie2.imageName = @"banner-2-movies.png";
    movie2.title = @"The Avengers";
    movie2.imageNameSmall = @"cover-3.jpg";
    movie2.description = @"Nick Fury of S.H.I.E.L.D. assembles a team of superhumans to save the planet from Loki and his army.";
    [movies addObject:movie2];
    
    Movie *movie3 = [[Movie alloc]init];
    movie3.imageNameSmall = @"cover-5.jpg";
    movie3.imageName = @"banner-3-movies.jpg";
    movie3.title = @"42";
    movie3.description = @"The life story of Jackie Robinson and his history-making signing with the Brooklyn Dodgers under the guidance of team executive Branch Rickey.";
    [movies addObject:movie3];
    
    Movie *movie4 = [[Movie alloc] init];
    movie4.imageNameSmall = @"cover-6.jpg";
    movie4.title = @"The conjuring";
    movie4.imageName = @"banner-4-movies.jpg";
    movie4.description = @"Paranormal investigators Ed and Lorraine Warren work to help a family terrorized by a dark presence in their farmhouse.";
    [movies addObject:movie4];

    
    Movie *movie5 = [[Movie alloc] init];
    movie5.imageNameSmall = @"cover-7.jpg";
    movie5.title = @"Gangster squad";
    movie5.imageName = @"banner-5-movies.jpg";
    movie5.description = @"Los Angeles, 1949: A secret crew of police officers led by two determined sergeants work together in an effort to take down the ruthless mob king Mickey Cohen who runs the city.";
    [movies addObject:movie5];

    
    return movies;
}

+(NSMutableArray *) getMoviesTest
{
    NSMutableArray *movies = [NSMutableArray arrayWithCapacity:4];
    movies = [self getHeadliningMovies];
    [movies addObjectsFromArray:[self getHeadliningMovies]];
    [movies addObjectsFromArray:[self getHeadliningMovies]];
    [movies addObjectsFromArray:[self getHeadliningMovies]];
    [movies addObjectsFromArray:[self getHeadliningMovies]];
    [movies addObjectsFromArray:[self getHeadliningMovies]];

    return movies;
}

+(NSMutableArray *) getRelatedMovies:(Movie *) movie
{
    NSMutableArray *movies = [NSMutableArray arrayWithCapacity:4];
    movies = [self getHeadliningMovies];
    
    return movies;
}



@end
