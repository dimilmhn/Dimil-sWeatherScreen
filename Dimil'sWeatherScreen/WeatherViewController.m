//
//  ViewController.m
//  Dimil'sWeatherScreen
//
//  Created by Developer on 11/16/15.
//  Copyright (c) 2015 DTM. All rights reserved.
//
#define WeatherURL @"http://api.worldweatheronline.com/free/v1/weather.ashx?q=bangalore&format=json&num_of_days=5&key=329c87ezzdxyx73v8wahx9cm"

#import "NSString+Formatter.h"
#import "WeatherViewController.h"
#import "WeatherCollectionViewCell.h"
#import "WeatherDataBase.h"
@interface WeatherViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *weatherCollectionView;
@property (strong,nonatomic) NSMutableArray *weatherDataArray;
@property (strong,nonatomic) NSMutableArray *previousDataArray;
@property (strong,nonatomic)WeatherDataBase *dataBase;
@property (nonatomic, strong) NSURLSession *session;
//@property (nonatomic, strong) CCImageDownloader *imageDownloader;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataBase=[WeatherDataBase sharedDatabase];
    [self fetchSavedData];
    [self getWeatherData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collectionview Delegates / Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
 
    return CGSizeZero;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WeatherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"weatherCell"
                                                                               forIndexPath:indexPath];
    cell.currentIndex=indexPath;
    if(_weatherDataArray.count!=0)
    {
        if(indexPath.row<4)
        {
            cell.weatherDay.text=[_previousDataArray objectAtIndex:indexPath.row][@"day"];
            cell.weatherTemp.text=[_previousDataArray objectAtIndex:indexPath.row][@"temp"];
            cell.weatherIcon.image=[UIImage imageNamed:@"cloud.png"];
            cell.backgroundColor=[UIColor lightGrayColor];

        }
        else
        {
            cell.weatherDay.text=[[_weatherDataArray objectAtIndex:indexPath.row-4][@"date"] dateFormatterFromString];
            cell.weatherTemp.text=[_weatherDataArray objectAtIndex:indexPath.row-4][@"tempMaxC"];
            cell.backgroundColor=[UIColor grayColor];
            if([_weatherDataArray objectAtIndex:indexPath.row-4][@"imageIcon"])
            {
                UIImage *image = [UIImage imageWithData:[_weatherDataArray objectAtIndex:indexPath.row-4][@"imageIcon"]];
                cell.weatherIcon.image=image;
  
            }
            else
            {
                cell.iconURL=[[_weatherDataArray objectAtIndex:indexPath.row-4][@"weatherIconUrl"]objectAtIndex:0][@"value"];

                [cell downloadWeatherLogo];
            }
            
            
        }
    }
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize frame=collectionView.frame.size;
    return CGSizeMake(frame.width/3-9,frame.width/3-9);
}
- (UIEdgeInsets)collectionView:(UICollectionView *) collectionView
                        layout:(UICollectionViewLayout *) collectionViewLayout
        insetForSectionAtIndex:(NSInteger) section {
    
    return UIEdgeInsetsMake(5, 5, 2, 5); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *) collectionView
                   layout:(UICollectionViewLayout *) collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger) section {
    return 0.0;
}
/*
 - service request
 */

- (void)getWeatherData
{
    [_loader startAnimating];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config];
    NSURL *dataURL = [NSURL URLWithString:WeatherURL];
    
    [[_session dataTaskWithURL:dataURL completionHandler:^(NSData
                                                           *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            [_loader stopAnimating];

            [self handleResponseWithData:(NSData *)data ];
            
        } else
        {
            [self handleResponseWithError:(NSError *)error];
        }
    }] resume];
 
}
/*
 - handle responses
 */
- (void)handleResponseWithData:(NSData *)data
{
    NSError *error = nil;
   NSDictionary *dataDic= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    _weatherDataArray=dataDic[@"data"][@"weather"];
    [self createPreviousData:_weatherDataArray];
}

- (void)handleResponseWithError:(NSError *)error
{
}


/*
 - mock data
 */

- (void)createPreviousData:(NSMutableArray *)dataArray
{
    _previousDataArray=[NSMutableArray new];
        NSInteger day=[[[dataArray objectAtIndex:0][@"date"] dateFormatterFromString]integerValue];
    for (int i=0; i<4;i++ )
    {
        NSDictionary *mockData=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld", day-4+i], @"day",@"25",@"temp", nil];
        [_previousDataArray addObject:mockData];
    }
    [self.weatherCollectionView reloadData];
    
    [_dataBase deleteItems];
    _dataBase.weatherDataArray=[_weatherDataArray mutableCopy];
    _dataBase.previousDataArray=[_previousDataArray mutableCopy];
    [_dataBase savedataArray];
}
/*
 - fetch the data while screen loading,and reset after getting response
 */

- (void)fetchSavedData
{
    int i=0;
    self.previousDataArray=[[NSMutableArray alloc]init];
    self.weatherDataArray=[[NSMutableArray alloc]init];

    for (WeatherData *weatherData in [_dataBase fethTheDetail])
    {
        if(i<4)
        {
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:weatherData.day,@"day",weatherData.temp,@"temp",weatherData.icon,@"imageIcon", nil];
            [self.previousDataArray addObject:dic];
        }
        else
        {
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:weatherData.day,@"date",weatherData.temp,@"tempMaxC",weatherData.icon,@"imageIcon", nil];

            [self.weatherDataArray addObject:dic];
        }
        i++;
    }
    [_weatherCollectionView reloadData];

}
@end
