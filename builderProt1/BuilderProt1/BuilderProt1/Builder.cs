using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BulderProt1
{
    class Builder
    {
        public IProjectTests build(string project)
        {
            switch (project)
            {
                case "Siemens": return new SiemensPerfTests(); break;
                case "SEMC": return new SEMCPerfTests(); break;
                default: throw new Exception();
            }
        }
    }
}
