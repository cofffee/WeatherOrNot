//
//  TodayViewController.m
//  WeatherOrNotExt
//
//  Created by Kevin Remigio on 4/26/16.
//  Copyright © 2016 Kevin Remigio. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "Weather.h"

@interface TodayViewController () <NCWidgetProviding> {
    NSDictionary *jsonDictionary;
    NSString *stringURL;
    //Weather *myWeather;
}

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //myWeather = [[Weather alloc]init];
    
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}
-(void) downloadWeather: (NSString*)searchZip {
    
    NSURL *url = [NSURL URLWithString:searchZip];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            NSHTTPURLResponse *resp = (NSHTTPURLResponse*) response;
            if (resp.statusCode == 200) {
                NSError *errorJSON;
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errorJSON];
                if (!errorJSON) {
                    //This is where the magic happens
                    jsonDictionary = [[NSDictionary alloc] initWithDictionary:dataDictionary];
                    
                    //NSLog(@"%@", stringURL);
                    //NSLog(@"%@",jsonDictionary);
                    NSString *lat = [[jsonDictionary objectForKey:@"coord"] objectForKey:@"lat"];
                    NSString *lon = [[jsonDictionary objectForKey:@"coord"] objectForKey:@"lon"];
                    NSString *temp= [[jsonDictionary objectForKey:@"main"] objectForKey:@"temp"];
                    NSString *pressure = [[jsonDictionary objectForKey:@"main"] objectForKey:@"pressure"];
                    NSString *humidity = [[jsonDictionary objectForKey:@"main"] objectForKey:@"humidity"];
                    NSString *minTemp = [[jsonDictionary objectForKey:@"main"] objectForKey:@"temp_min"];
                    NSString *maxTemp = [[jsonDictionary objectForKey:@"main"] objectForKey:@"temp_max"];
                    
                    NSString *stringSunrise = [[jsonDictionary objectForKey:@"sys"] objectForKey:@"sunrise"];
                    NSDate *sunrise = [NSDate dateWithTimeIntervalSince1970: [stringSunrise doubleValue]];
                    NSString *stringSunset = [[jsonDictionary objectForKey:@"sys"] objectForKey:@"sunset"];
                    NSDate *sunset = [NSDate dateWithTimeIntervalSince1970: [stringSunset doubleValue]];
                    
                    NSString *windSpeed = [[jsonDictionary objectForKey:@"wind"] objectForKey:@"speed"];
                    NSString *windDegrees = [[jsonDictionary objectForKey:@"wind"] objectForKey:@"degrees"];
/*
                    myWeather.latitude = lat;
                    myWeather.longitude = lon;
                    myWeather.windSpeed = windSpeed;
                    myWeather.windDegrees = windDegrees;
                    myWeather.temparature = temp;
                    myWeather.pressure = pressure;
                    myWeather.humidity = humidity;
                    myWeather.minimumTemparature = minTemp;
                    myWeather.maximumTemparature = maxTemp;
                    myWeather.sunrise = sunrise;
                    myWeather.sunset = sunset;
*/
                    
                    //NSLog(@"lat:%@ long:%@",myWeather.latitude, myWeather.longitude);
                    
                    //NSLog(@"temperature:%@", temp);
                    for (NSDictionary *dict in [jsonDictionary objectForKey:@"weather"]) {
                        NSString *mainWeather = [dict objectForKey:@"main"];
                        NSString *weatherDescription = [dict objectForKey:@"description"];
                        //NSString *lon = [dict objectForKey:@"lon"];
                        NSLog(@"main weather:%@ description:%@",mainWeather, weatherDescription);
                        //                        NSLog(@"%@",pokemonName);
                        //[myPokemonArray addObject:pokemonName];
                        
                    }
                    //[self setLabels];
                    [self performSelectorOnMainThread:@selector(setLabels) withObject:nil waitUntilDone:YES];
                    //NSLog(@"%@", jsonDictionary);
                } else {
                    //alert error with json data
                    [self brokenJSONDataAlert];
                }
            } else {
                //alert status code not 200
                [self brokenWebPageAlert];
            }
        } else {
            //alert error with the session
            [self brokenSessionAlert];
        }
    }];
    
    [dataTask resume];
    //nextURL = [jsonDictionary objectForKey:@"next"];
    
    
}
-(void) brokenJSONDataAlert {
    NSLog(@"Broken JSON!");
}
-(void) brokenWebPageAlert {
    NSLog(@"Broken Webpage!");
}
-(void) brokenSessionAlert {
    NSLog(@"Broken Session!");
}
- (void)setLabels {
    NSString *mySearchZip = _zipCodeLabel.text;
    
//    CLLocationDegrees lat = [myWeather.latitude doubleValue];
//    CLLocationDegrees lng = [myWeather.longitude doubleValue];
//    
//    [self.myMapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat, lng), MKCoordinateSpanMake(0.1, 0.1))];
//    
//    NSString *fTemperature = [NSString stringWithFormat:@"%f",[self getFahrenheit:myWeather.temparature]];
//    NSString *cTemperature = [NSString stringWithFormat:@"%f",[self getCelsius:myWeather.temparature]];
 /*
    _weatherInfoFirstLine.text = [NSString stringWithFormat:@"%@ temp:%@ pressure:%@ humidity:%@",mySearchZip,  myWeather.temparature, myWeather.pressure, myWeather.humidity];
    
    NSString *sunriseHoursString = [NSDateFormatter localizedStringFromDate:myWeather.sunrise dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    NSString *sunsetHoursString = [NSDateFormatter localizedStringFromDate:myWeather.sunset dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    
    _weatherInfoSecondLine.text = [NSString stringWithFormat:@"sunrise:%@ sunset:%@", sunriseHoursString, sunsetHoursString];
  */
    _weatherInfoFirstLine.text = [NSString stringWithFormat:@"%@",_zipCodeLabel.text];
}

- (IBAction)searchWeather:(id)sender {
    NSLog(@"hello dear");
    [self downloadWeather:_zipCodeLabel.text];
}
@end
