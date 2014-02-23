using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Navigation;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Shell;
using Microsoft.Phone.Maps.Controls;
using System.Device.Location;

namespace MapTest
{
    public partial class LocationPage : PhoneApplicationPage
    {
        public static int thisSession = 0;
        Map MyMap = new Map();

        private const String server = "http://216.151.208.196/";
        
        private void GetFetch(object sender, DownloadStringCompletedEventArgs e)
        {
            LocationResult temp = GetLocation.ReadToObject(e.Result);
            GeoCoordinate thatPos = CoordinateTools.SimpleLocation(temp.Lat, temp.Lon);
            MainPage.ShowLocationOnTheMap(thatPos, MyMap);
        }

        public void FetchLocation(string id)
        {
            WebClient wc = new WebClient();
            wc.DownloadStringCompleted += new DownloadStringCompletedEventHandler(GetFetch);
            wc.DownloadStringAsync(new Uri(server + "/locate.php?id=" + id));
        }

        public LocationPage()
        {
            InitializeComponent();
            ContentPanel.Children.Add(MyMap);
            FetchLocation(thisSession.ToString());
        }
    }
}