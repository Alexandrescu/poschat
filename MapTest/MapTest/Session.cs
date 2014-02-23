using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Runtime.Serialization.Json;
using System.Device.Location;
using System.Windows.Controls;
using System.Diagnostics;

namespace MapTest
{
    public class Session
    {
        private const String server = "http://216.151.208.196/";
        public string num;
        private MainPage parent;

        public Session(String num, MainPage parent)
        {
            this.num = num;
            this.parent = parent;
        }

        public void Fetch(string target)
        {
            WebClient wc = new WebClient();
            wc.DownloadStringCompleted += new DownloadStringCompletedEventHandler(GetFetch);
            wc.DownloadStringAsync(new Uri(server + "/fetch.php?target=" + target));
        }

        private void GetFetch(object sender, DownloadStringCompletedEventArgs e)
        {
            parent.DataContext = FetchLocation.ReadToObject(e.Result);
        }

    }
}
