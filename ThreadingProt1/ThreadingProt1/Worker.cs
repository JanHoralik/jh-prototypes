using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace ThreadingProt1
{
    public class Worker
    {
        int _index;
        public Worker(int index) { _index = index; }
        public void Run()
        {
            Thread.Sleep(5000);
            System.Console.WriteLine("This is thread:"+_index.ToString());
        }
    }
}
