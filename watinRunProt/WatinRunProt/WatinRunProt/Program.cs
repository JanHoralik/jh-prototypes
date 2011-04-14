using System;
using System.Threading;

using WatiN.Core;
using WatiN.Core.DialogHandlers;
using WatiN.Core.Exceptions;
using WatiN.Core.Interfaces;
using WatiN.Core.Logging;
using WatiN.Core.Comparers;
using WatiN.Core.UtilityClasses;
/*using NUnit.Framework;
using System.IO;
using System.Data.Odbc;
using WatiN.Core.Native.InternetExplorer;
using SHDocVw;*/


namespace WatinRunProt
{
    class Program
    {
        [STAThread]
        static void Main(string[] args)
        {
            IE  ie;

            string url = args[0];
            int scriptId = System.Int16.Parse(args[1]);

            switch (scriptId)
            {
                case 1:
                    {
                        ie = new IE(url);
                        ie.ShowWindow(WatiN.Core.Native.Windows.NativeMethods.WindowShowStyle.ShowMaximized);
                        Thread.Sleep(3000);
                        ie.ForceClose();
                    }; break;
                case 2:
                    {
                        Settings.HighLightElement = true;
                        Settings.AutoMoveMousePointerToTopLeft = false;
                        Settings.MakeNewIe8InstanceNoMerge = true;
                        Settings.AttachToBrowserTimeOut = 60;
                        Settings.WaitForCompleteTimeOut = 60;
                        Settings.WaitUntilExistsTimeOut = 300;
                        Settings.AutoCloseDialogs = true;
                        ie = new IE(url, false);
                        ie.ShowWindow(WatiN.Core.Native.Windows.NativeMethods.WindowShowStyle.ShowMaximized);
                        Thread.Sleep(3000);
                        ie.ForceClose();
                    }; break;
                case 3:
                    {
                        Settings.HighLightElement = true;
                        Settings.AutoMoveMousePointerToTopLeft = false;
                        Settings.MakeNewIe8InstanceNoMerge = true;
                        Settings.AttachToBrowserTimeOut = 60;
                        Settings.WaitForCompleteTimeOut = 60;
                        Settings.WaitUntilExistsTimeOut = 300;
                        Settings.AutoCloseDialogs = true;
                        ie = new IE(false);
                        ie.GoTo(url);
                        ie.ShowWindow(WatiN.Core.Native.Windows.NativeMethods.WindowShowStyle.ShowMaximized);
                        Thread.Sleep(3000);
                        ie.ForceClose();
                    }; break;
                case 4:
                    {
                        Settings.HighLightElement = true;
                        Settings.AutoMoveMousePointerToTopLeft = false;
                        Settings.MakeNewIe8InstanceNoMerge = true;
                        Settings.AttachToBrowserTimeOut = 60;
                        Settings.WaitForCompleteTimeOut = 60;
                        Settings.WaitUntilExistsTimeOut = 300;
                        Settings.AutoCloseDialogs = true;
                        ie = new IE(true);
                        ie.GoTo(url);
                        ie.ShowWindow(WatiN.Core.Native.Windows.NativeMethods.WindowShowStyle.ShowMaximized);
                        Thread.Sleep(3000);
                        ie.ForceClose();
                    }; break;
            }
            /*Settings.HighLightElement = true;
            Settings.AutoMoveMousePointerToTopLeft = false;
            Settings.MakeNewIe8InstanceNoMerge = true;
            //Settings.AttachToIETimeOut = 60;
            Settings.AutoCloseDialogs = true;
            Settings.WaitForCompleteTimeOut = 60;
            Settings.WaitUntilExistsTimeOut = 300;
            ie = new IE(true);
            ie.ShowWindow(WatiN.Core.Native.Windows.NativeMethods.WindowShowStyle.ShowMaximized);
            ie.AutoClose = true;
            Thread.Sleep(3000);*/
        }
    }
}
