using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace ThreadingProt1
{
    class Program
    {
        static void Main(string[] args)
        {
            Worker w1 = new Worker(1);
            Worker w2 = new Worker(2);
            ThreadStart job1 = new ThreadStart(w1.Run);
            ThreadStart job2 = new ThreadStart(w2.Run);
            Thread t1 = new Thread(job1);
            Thread t2 = new Thread(job2);
            t1.Start();
            t2.Start();
        }
    }
}
