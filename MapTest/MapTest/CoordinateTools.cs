using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Device.Location; // Provides the GeoCoordinate class.
using Windows.Devices.Geolocation; //Provides the Geocoordinate class.


namespace MapTest
{
    class CoordinateTools
    {
        private double Lat, Long;
        /** Default code from the web */
        public static GeoCoordinate ConvertGeocoordinate(Geocoordinate geocoordinate)
        {
            return new GeoCoordinate
                (
                geocoordinate.Latitude,
                geocoordinate.Longitude,
                geocoordinate.Altitude ?? Double.NaN,
                geocoordinate.Accuracy,
                geocoordinate.AltitudeAccuracy ?? Double.NaN,
                geocoordinate.Speed ?? Double.NaN,
                geocoordinate.Heading ?? Double.NaN
                );
        }

        public CoordinateTools(double Lat, double Long)
        {
            this.Lat = Lat;
            this.Long = Long;
        }

        public static GeoCoordinate SimpleLocation(double Lat, double Long)
        {
            return new GeoCoordinate (Lat, Long);
        }
    }
}
