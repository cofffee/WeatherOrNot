//
//  Weather.m
//  WeatherOrNotApp
//
//  Created by Kevin Remigio on 4/22/16.
//  Copyright © 2016 Kevin Remigio. All rights reserved.
//

#import "Weather.h"

@implementation Weather
- (id)init
{
    if (self = [super init])
    {
        _main = [[NSMutableDictionary alloc]init];
        _mainWeather = [[NSMutableArray alloc]init];
        _mainWeatherDescription = [[NSMutableArray alloc]init];
    }
    return self;
}
@end
