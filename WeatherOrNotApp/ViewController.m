//
//  ViewController.m
//  WeatherOrNotApp
//
//  Created by Kevin Remigio on 4/22/16.
//  Copyright © 2016 Kevin Remigio. All rights reserved.
//

#import "ViewController.h"
#import "Weather.h"

@interface ViewController () {
    NSDictionary *jsonDictionary;
    NSString *stringURL;
    Weather *myWeather;
}
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Create manager and coder, set manager delegate
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.coder = [[CLGeocoder alloc] init];
    
    //Button that requests for location permission
    //Don't forget to stick this in your p_list
    //NSLocationWhenInUseUsageDescription - give a reason
    if([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]){//ios 8+
        [self.manager requestWhenInUseAuthorization];
    }
    
    //mapview delegate
    self.myMapView.delegate = self;
    
}

-(void) downloadWeather: (NSString*)searchZip {
    
    myWeather = [[Weather alloc]init];
    
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
                    
                    
                    //NSLog(@"lat:%@ long:%@",myWeather.latitude, myWeather.longitude);
                    //myWeather.main = [NSMutableDictionary dictionary];
                    
                    //NSLog(@"temperature:%@", temp);
                    for (NSDictionary *dict in [jsonDictionary objectForKey:@"weather"]) {
                        NSString *mainWeather = [dict objectForKey:@"main"];
                        NSString *weatherDescription = [dict objectForKey:@"description"];
                        
                        [myWeather.mainWeather addObject:mainWeather];
                        [myWeather.mainWeatherDescription addObject:weatherDescription];
                        
                        //myWeather.mainWeather = mainWeather;
                        //myWeather.mainWeatherDescription = weatherDescription;
                        
                        //[myWeather.main setObject:mainWeather forKey:weatherDescription];
                        
                        [myWeather.main setObject:weatherDescription forKey:mainWeather];
                        
                        //NSLog(@"weather:%@", myWeather.main);
                        
                    
                    }
                    //[self performSelectorOnMainThread:@selector(getCity) withObject:nil waitUntilDone:YES];
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
    //[self performSelectorOnMainThread:@selector(getCity) withObject:nil waitUntilDone:YES];
    [self getCity];
    NSString *mySearchZip = _zipCodeLabel.text;
    
    CLLocationDegrees lat = [myWeather.latitude doubleValue];
    CLLocationDegrees lng = [myWeather.longitude doubleValue];
    
    [self.myMapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat, lng), MKCoordinateSpanMake(1.0, 1.0))];
    
    NSString *fTemperature = [NSString stringWithFormat:@"%.0f",[self getFahrenheit:myWeather.temparature]];
    NSString *cTemperature = [NSString stringWithFormat:@"%.0f",[self getCelsius:myWeather.temparature]];
    
    NSString *fMinTemperature = [NSString stringWithFormat:@"%.0f",[self getFahrenheit:myWeather.minimumTemparature]];
    NSString *fMaxTemperature = [NSString stringWithFormat:@"%.0f",[self getFahrenheit:myWeather.maximumTemparature]];
    
    NSString *sunriseHoursString = [NSDateFormatter localizedStringFromDate:myWeather.sunrise dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    NSString *sunsetHoursString = [NSDateFormatter localizedStringFromDate:myWeather.sunset dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    
    
    _weatherInfoFirstLine.text = [NSString stringWithFormat:@"%@℉",fTemperature];
    _weatherInfoFourthLine.text = [NSString stringWithFormat:@"sunrise:%@ a.m. sunset:%@ p.m.", sunriseHoursString, sunsetHoursString];
    _weatherInfoThirdLine.text = [NSString stringWithFormat:@"pressure:%@hPa humidity:%@%% %@/%@℉",myWeather.pressure, myWeather.humidity, fMinTemperature, fMaxTemperature];
    _weatherInfoSecondLine.text = [NSString stringWithFormat:@"%@:%@",[myWeather.mainWeather firstObject], [myWeather.mainWeatherDescription firstObject]];
    _weatherInfoFifthLine.text = [NSString stringWithFormat:@"%@",myWeather.city];
}
- (IBAction)searchForWeather:(id)sender {
    NSString *mySearchZip = _zipCodeLabel.text;
    NSLog(@"%@",mySearchZip);
    _weatherInfoFifthLine.text = @"*";
    _weatherInfoFirstLine.text = @"**";
    _weatherInfoSecondLine.text = @"***";
    _weatherInfoThirdLine.text = @"****";
    _weatherInfoFourthLine.text = @"*****";
    stringURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?zip=%@,us&appid=9575400c8412cb658faf53b4a3f44f82", mySearchZip];
    [self downloadWeather:stringURL];
}
- (double) getFahrenheit: (NSString*)kelvin {
    double fahrenheit = [kelvin doubleValue];
    double constant = 459.67;
    double ratio = 9.0/5.0;
    fahrenheit = (fahrenheit * ratio) - constant;

    return fahrenheit;
}
- (double) getCelsius: (NSString*)kelvin {
    double celsius = [kelvin doubleValue];
    double constant = 273.15;
    celsius = celsius - constant;
    
    return celsius;
}
- (IBAction)getZipCode:(id)sender {
    [self.manager startUpdatingLocation];
}
-(void) getCity{
    CLLocationDegrees lat = [myWeather.latitude doubleValue];
    CLLocationDegrees lng = [myWeather.longitude doubleValue];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
    
    [self.coder reverseGeocodeLocation:location
                     completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                         
                         if(!error){
                             CLPlacemark *placeMark = [placemarks lastObject];
                             NSLog(@"%@",placeMark.postalCode);
                             NSLog(@"%@",placeMark.locality);
                             myWeather.city = placeMark.locality;

                            _weatherInfoFifthLine.text = [NSString stringWithFormat:@"%@,%@",myWeather.city, placeMark.administrativeArea];
                             
                         } else {
                             NSLog(@"Error");
                         }
                     }];

    
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.manager stopUpdatingLocation];
    
    CLLocation *myLocation = [locations lastObject];
    
    [self.coder reverseGeocodeLocation:myLocation
                     completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                         
                         if(!error){
                             CLPlacemark *placeMark = [placemarks lastObject];
                             NSLog(@"%@",placeMark.postalCode);
                             NSLog(@"%@",placeMark.locality);
                             
                             //whereField.text = placeMark.postalCode;
                             _zipCodeLabel.text = placeMark.postalCode;
                             
                             
                             
                         } else {
                             NSLog(@"Error");
                         }
                     }];
    
    
    
    
}
/*
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1;
    span.longitudeDelta = 0.1;
    
    
    MKCoordinateRegion region;
    region.center = coordinate;
    region.span = span;
    
    [self.myMapView setRegion:region];
    
    
    
}
 */

/*  -DATE PRINTING FORMATS-
 NSString *sunsetShortStyle = [NSDateFormatter localizedStringFromDate:sunset dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
 NSString *sunsetLongStyle = [NSDateFormatter localizedStringFromDate:sunset dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterFullStyle];
 NSString *sunsetNoStyle = [NSDateFormatter localizedStringFromDate:sunset dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterFullStyle];
 NSString *sunsetMediumStyle = [NSDateFormatter localizedStringFromDate:sunset dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterFullStyle];
 NSString *sunsetFullStyle = [NSDateFormatter localizedStringFromDate:sunset dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterFullStyle];
 
 NSLog(@"full style: %@",sunsetFullStyle);
 NSLog(@"short style: %@",sunsetShortStyle);
 NSLog(@"long style: %@", sunsetLongStyle);
 NSLog(@"no style: %@", sunsetNoStyle);
 NSLog(@"medium style: %@", sunsetMediumStyle);
 */

/*  -GCD FOR ANY OCCASSION-
                  NSLog(@"sunrise:%@ sunset:%@",sunrise, sunset);

                             dispatch_async(dispatch_get_main_queue(), ^{
                                 NSLog(@"inside dispatch async block main thread from main thread");
                                 myWeather.city = placeMark.locality;

                             });
 */
@end
