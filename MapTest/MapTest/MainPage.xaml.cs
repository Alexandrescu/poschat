using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Navigation;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Shell;
using MapTest.Resources;
using Microsoft.Phone.Maps.Controls;
using System.Device.Location; // Provides the GeoCoordinate class.
using Windows.Devices.Geolocation; //Provides the Geocoordinate class.
using System.Windows.Media;
using System.Windows.Shapes;
using System.Runtime.Serialization.Json;
using System.IO;
using System.Text;

namespace MapTest
{
 
    public partial class MainPage : PhoneApplicationPage
    {
        protected override void OnBackKeyPress(System.ComponentModel.CancelEventArgs e)
        {
            Application.Current.Terminate();
        }

        Map MyMap = new Map();

        private void ShowMyLocation(Action<GeoCoordinate, Map> callFunc)
        {
            /*
            Geolocator myGeolocator = new Geolocator();
            Geoposition myGeoposition = await myGeolocator.GetGeopositionAsync();
            Geocoordinate myGeocoordinate = myGeoposition.Coordinate;
            GeoCoordinate myGeoCoordinate =
                CoordinateTools.ConvertGeocoordinate(myGeocoordinate);*/
            GeoCoordinate myGeoCoordinate =
                CoordinateTools.SimpleLocation(51.5119099, -0.103172);

            lat = myGeoCoordinate.Latitude;
            lon = myGeoCoordinate.Longitude;
            notSet = false;
            callFunc(myGeoCoordinate, this.MyMap);
        }

        public static void ShowLocationOnTheMap(GeoCoordinate position, Map MyMap)
        {
           
            MyMap.Center = position;
            MyMap.ZoomLevel = 13;

            Ellipse myCircle = new Ellipse();
            myCircle.Fill = new SolidColorBrush(Colors.Blue);
            myCircle.Height = 20;
            myCircle.Width = 20;
            myCircle.Opacity = 50;

            MapOverlay myLocationOverlay = new MapOverlay();
            myLocationOverlay.Content = myCircle;
            myLocationOverlay.PositionOrigin = new Point(0.5, 0.5);
            myLocationOverlay.GeoCoordinate = position;

            MapLayer myLocationLayer = new MapLayer();
            myLocationLayer.Add(myLocationOverlay);


            MyMap.Layers.Add(myLocationLayer);
        }


        private void InitTimeSelector(int n)
        {
            for (int i = 1; i <= n; i++)
                TimeSelector.Items.Add(i);
        }

        private const String server = "http://216.151.208.196/";

        public void PostIt(object sender, DownloadStringCompletedEventArgs e)
        {

            console.Text = "Shared!";
        }
        private bool notSet = true;
        double lat, lon;
        private void ShareLocation(object sender, RoutedEventArgs e)
        {
            if (notSet == true) console.Text = "Location not yet found";
            else
            {
                WebClient wc = new WebClient();
                wc.DownloadStringCompleted += new DownloadStringCompletedEventHandler(PostIt);
                wc.DownloadStringAsync(new Uri(server + "/post.php?target=" + this.Friend.Text + "&source=" + me.num + "&lat=" + lat + "&lon=" + lon + "&expiry=" + this.TimeSelector.SelectedItem.ToString() + "&comment=" + this.Comment.Text));
            }
        }

        Session me;
        public MainPage()
        {
            InitializeComponent();

            ContentPanel.Children.Add(MyMap);

            InitTimeSelector(20);

            me = new Session((String)Application.Current.Resources["num"], this);
            me.Fetch(me.num);

            ShowMyLocation(ShowLocationOnTheMap);
        }
        private void Refresh(object sender, RoutedEventArgs e)
        {
            this.DataContext = null;
            me.Fetch(me.num);
            
        }
        private void Button_Click(object sender, RoutedEventArgs e)
        {
            Button b = (Button)sender;
            int fr = Convert.ToInt32(b.Content);
            console.Text = fr.ToString();
            LocationPage.thisSession = fr;
            NavigationService.Navigate(new Uri("/Location.xaml", UriKind.Relative));
            
        }

        private void Comment_GotFocus(object sender, RoutedEventArgs e)
        {
            this.Comment.Text = "";
        }

        private void Friend_GotFocus(object sender, RoutedEventArgs e)
        {
            this.Friend.Text = "";
        }
    }
}