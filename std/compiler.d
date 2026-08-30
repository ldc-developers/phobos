// Written in the D programming language.

/**
 * Identify the compiler used and its various features.
 *
 * Copyright: Copyright The D Language Foundation 2000 - 2011.
 * License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   $(HTTP digitalmars.com, Walter Bright), Alex Rønne Petersen
 * Source:    $(PHOBOSSRC std/compiler.d)
 */
/*          Copyright The D Language Foundation 2000 - 2011.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module std.compiler;

immutable
{
    /// Vendor specific string naming the compiler, for example: "Digital Mars D".
    string name = __VENDOR__;

    /// Master list of D compiler vendors.
    enum Vendor
    {
        unknown = 0,     /// Compiler vendor could not be detected
        digitalMars = 1, /// Digital Mars D (DMD)
        gnu = 2,         /// GNU D Compiler (GDC)
        llvm = 3,        /// LLVM D Compiler (LDC)
        dotNET = 4,      /// D.NET
        sdc = 5,         /// Snazzy D Compiler (SDC)
    }

    /// Which vendor produced this compiler.
    version (StdDdoc)          Vendor vendor;
    else version (DigitalMars) Vendor vendor = Vendor.digitalMars;
    else version (GNU)         Vendor vendor = Vendor.gnu;
    else version (LDC)         Vendor vendor = Vendor.llvm;
    else version (D_NET)       Vendor vendor = Vendor.dotNET;
    else version (SDC)         Vendor vendor = Vendor.sdc;
    else                      Vendor vendor = Vendor.unknown;


version (LDC)
{
    // LDC has its own release versioning scheme, separate from the
    // DMD frontend version (__VERSION__). The "major.minor" string is
    // generated at build time into "ldccompilerversion.txt"
    // (see runtime/CMakeLists.txt) and string-imported here.
    private uint parseLDCVersionNumber() @safe
    {
        enum ver = import("ldccompilerversion.txt");
        uint major = 0;
        uint minor = 0;
        size_t i = 0;
        while (i < ver.length && ver[i] >= '0' && ver[i] <= '9')
            major = major * 10 + (ver[i++] - '0');
        if (i < ver.length && ver[i] == '.')
        {
            i++;
            while (i < ver.length && ver[i] >= '0' && ver[i] <= '9')
                minor = minor * 10 + (ver[i++] - '0');
        }
        return major * 1000 + minor;
    }
    private enum _ldcVersionNumber = parseLDCVersionNumber();

    /**
     * The vendor specific version number, as in
     * version_major.version_minor
     */
    uint version_major = _ldcVersionNumber / 1000;
    uint version_minor = _ldcVersionNumber % 1000;    /// ditto
}
else
{
    /**
     * The vendor specific version number, as in
     * version_major.version_minor
     */
    uint version_major = __VERSION__ / 1000;
    uint version_minor = __VERSION__ % 1000;    /// ditto
}


    /**
     * The version of the D Programming Language Specification
     * supported by the compiler.
     */
    uint D_major = 2;
    uint D_minor = 0;
}
