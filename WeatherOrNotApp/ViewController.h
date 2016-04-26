//
//  ViewController.h
//  WeatherOrNotApp
//
//  Created by Kevin Remigio on 4/22/16.
//  Copyright © 2016 Kevin Remigio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *zipCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherInfoFirstLine;
@property (weak, nonatomic) IBOutlet UILabel *weatherInfoSecondLine;

- (IBAction)searchForWeather:(id)sender;

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) CLGeocoder *coder;

@end

