using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTest
{
    public class FetchResult : INotifyPropertyChanged
    {
        [JsonProperty(PropertyName = "0")]
        public string Num { get; set; }
        [JsonProperty(PropertyName = "1")]
        public int UnixTime { get; set; }
        [JsonProperty(PropertyName = "2")]
        public int ExpiryTime { get; set; }
        [JsonProperty(PropertyName = "3")]
        public string Comment { get; set; }
        [JsonProperty(PropertyName = "4")]
        public string Id { get; set; }

        public FetchResult(int time, string comment)
        {
            this.UnixTime = time;
            this.Comment = comment;
            this.Num = "da";
            this.ExpiryTime = 0;
            this.Id = "da";
        }


        public event PropertyChangedEventHandler PropertyChanged;
        protected virtual void OnPropertyChanged(string propertyName)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null) handler(this, new PropertyChangedEventArgs(propertyName));
        }
    }

    public class LocationResult
    {
        public double Lat { get; set; }
        public double Lon { get; set; }
        public string Comment { get; set; }
        public LocationResult(string a, string b, string c)
        {
            Lat = Convert.ToDouble(a);
            Lon = Convert.ToDouble(b);
            Comment = c;
        }
    }
}
