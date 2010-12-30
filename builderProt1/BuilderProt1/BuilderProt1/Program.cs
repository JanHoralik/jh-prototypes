using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BulderProt1
{
    class Program
    {
        static void Main(string[] args)
        {
            IProjectTests test1 = new Builder().build("Siemens");
            IProjectTests test2 = new Builder().build("SEMC");

            test1.Run();
            test2.Run();

            System.Threading.Thread.Sleep(3000);
        }
    }
}
