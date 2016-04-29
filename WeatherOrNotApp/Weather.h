//
//  Weather.h
//  WeatherOrNotApp
//
//  Created by Kevin Remigio on 4/22/16.
//  Copyright © 2016 Kevin Remigio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject
@property (nonatomic, weak) NSString *longitude;
@property (nonatomic, weak) NSString *latitude;
@property (nonatomic, weak) NSString *city;

@property(nonatomic) NSMutableDictionary *main;
@property (nonatomic) NSMutableArray *mainWeather;
@property (nonatomic) NSMutableArray *mainWeatherDescription;
@property (nonatomic, weak) NSString *windSpeed;
@property (nonatomic, weak) NSString *windDegrees;
@property (nonatomic, weak) NSString *temparature;
@property (nonatomic, weak) NSString *pressure;
@property (nonatomic, weak) NSString *humidity;
@property (nonatomic, weak) NSString *minimumTemparature;
@property (nonatomic, weak) NSString *maximumTemparature;
@property (nonatomic, weak) NSDate *sunrise;
@property (nonatomic, weak) NSDate *sunset;



@end
