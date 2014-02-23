using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Threading.Tasks;

namespace MapTest
{
    class FetchLocation
    {
        /* Functions */
        public string replaceThisWhereThat(string sub, string big, string that)
        {
            for (int i = 0; i <= big.Length; i++)
                if (big.Substring(i, sub.Length) == sub)
                    big = big.Substring(0, i) + that + big.Substring(i + sub.Length, big.Length);
            return big;
        }

        public static double DateTimeToUnixTimestamp(DateTime dateTime)
        {
            return (dateTime - new DateTime(1970, 1, 1).ToLocalTime()).TotalSeconds;
        }

        public static List<FetchResult> ReadToObject(string json)
        {
            if (json == null || json == "" || json == "null") return null;
            Dictionary<string, FetchResult> deserializedEntries = new Dictionary<string, FetchResult>();
            deserializedEntries = JsonConvert.DeserializeObject<Dictionary<string, FetchResult>>(json);
            List<FetchResult> l = new List<FetchResult>();
            foreach (KeyValuePair<string, FetchResult> pair in deserializedEntries)
            {
                /* TODO : Update DB */
                int thisTime = Convert.ToInt32(DateTimeToUnixTimestamp(DateTime.Now));
                if (pair.Value.ExpiryTime * 60 + pair.Value.UnixTime > thisTime)
                    l.Add(pair.Value);
                //else l.Add(new FetchResult((int) DateTimeToUnixTimestamp(DateTime.Now), "Now"));
            }
            return l;
        }
    }

    class GetLocation
    {
        public static LocationResult ReadToObject(string json)
        {
            //LocationResult deserializedEntry = new LocationResult();
            string[] des = new string[10];
            //deserializedEntry = JsonConvert.DeserializeObject<LocationResult>(json);
            des = JsonConvert.DeserializeObject<string[]>(json);
            return new LocationResult(des[0], des[1], des[2]);
        }
    }
}
