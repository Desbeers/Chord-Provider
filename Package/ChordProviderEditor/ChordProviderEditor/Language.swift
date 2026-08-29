//
//  Language.swift
//  ChordProviderEditor
//
//  © 2026 Nick Berendsen
//

/// A language available in the code editor.
public enum Language: String, CaseIterable {

    // swiftlint:disable identifier_name

    /// ABNF
    case abnf
    /// ActionScript
    case actionscript
    /// Ada
    case ada
    /// ANS Forth 94
    case ansforth94
    /// AsciiDoc
    case asciidoc
    /// ASP
    case asp
    /// Automake
    case automake
    /// AWK
    case awk
    /// BeanShell
    case bennugd
    /// BibTeX
    case bibtex
    /// Blueprint
    case blueprint
    /// Bluespec
    case bluespec
    /// Boo
    case boo
    /// C
    case c
    /// C#
    case cSharp
    /// ChordPro
    case chordpro
    /// C++
    case cpp
    /// CG
    case cg
    /// Changelog
    case changelog
    /// Changes
    case changes
    /// C++ header
    case cpphdr
    /// CMake
    case cmake
    /// C header
    case chdr
    /// COBOL
    case cobol
    /// Common Lisp
    case commonlisp
    /// CSS
    case css
    /// CSV
    case csv
    /// CUDA
    case cuda
    /// D
    case d
    /// Dart
    case dart
    /// DEF
    case def
    /// Desktop Entry
    case desktop
    /// Diff
    case diff
    /// DTL
    case dtl
    /// DocBook
    case docbook
    /// Docker
    case docker
    /// DOS batch
    case dosbatch
    /// DPatch
    case dpatch
    /// DTD
    case dtd
    /// Eiffel
    case eiffel
    /// ERB
    case erb
    /// ERB HTML
    case erbHtml
    /// ERB JavaScript
    case erbJs
    /// Erlang
    case erlang
    /// F#
    case fsharp
    /// FCL
    case fcl
    /// Fish
    case fish
    /// FreeMarker
    case ftl
    /// Forth
    case forth
    /// Fortran
    case fortran
    /// GAP
    case gap
    /// GDB log
    case gdbLog
    /// GDScript
    case gdscript
    /// Genie
    case genie
    /// Gettext translation
    case gettextTranslation
    /// Go
    case go
    /// Gradle
    case gradle
    /// Graphviz DOT
    case dot
    /// Groovy
    case groovy
    /// GTK-Doc
    case gtkDoc
    /// GTK RC
    case gtkrc
    /// Haddock
    case haddock
    /// Haskell
    case haskell
    /// Haxe
    case haxe
    /// HTML
    case html
    /// IDL
    case idl
    /// IDL Exelis
    case idlExelis
    /// ImageJ
    case imagej
    /// INI
    case ini
    /// J
    case j
    /// Jade
    case jade
    /// Java
    case java
    /// JavaScript
    case js
    /// JavaScript value
    case jsVal
    /// JavaScript expression
    case jsExpr
    /// JavaScript function
    case jsFn
    /// JavaScript literal
    case jsLit
    /// JavaScript module
    case jsMod
    /// JavaScript statement
    case jsSt
    /// JSDoc
    case jsdoc
    /// JSON
    case json
    /// JSX
    case jsx
    /// Julia
    case julia
    /// Kotlin
    case kotlin
    /// LaTeX
    case latex
    /// Lean
    case lean
    /// Less
    case less
    /// Lex
    case lex
    /// Libtool
    case libtool
    /// Literate Haskell
    case haskellLiterate
    /// LLVM
    case llvm
    /// Logcat
    case logcat
    /// Logtalk
    case logtalk
    /// Lua
    case lua
    /// M4
    case m4
    /// Makefile
    case makefile
    /// Mallard
    case mallard
    /// Markdown
    case markdown
    /// MATLAB
    case matlab
    /// Maxima
    case maxima
    /// MediaWiki
    case mediawiki
    /// Meson
    case meson
    /// Modelica
    case modelica
    /// MXML
    case mxml
    /// Nemerle
    case nemerle
    /// NetRexx
    case netrexx
    /// Nix
    case nix
    /// NSIS
    case nsis
    /// Objective-C
    case objc
    /// Objective-J
    case objj
    /// OCaml
    case ocaml
    /// OCL
    case ocl
    /// Octave
    case octave
    /// OOC
    case ooc
    /// OPAL
    case opal
    /// OpenCL GLSL
    case openclGlsl
    /// Pascal
    case pascal
    /// Perl
    case perl
    /// PHP
    case php
    /// Pig
    case pig
    /// pkg-config
    case pkgconfig
    /// Plain text
    case plain
    /// PowerShell
    case powershell
    /// Prolog
    case prolog
    /// Protocol Buffers
    case proto
    /// Puppet
    case puppet
    /// Python 3
    case python3
    /// Python
    case python
    /// R
    case r
    /// ReasonML
    case reasonml
    /// reStructuredText
    case rst
    /// RPM spec
    case rpmspec
    /// Ruby
    case ruby
    /// Rust
    case rust
    /// Scala
    case scala
    /// Scheme
    case scheme
    /// Scilab
    case scilab
    /// SCSS
    case scss
    /// Shell
    case sh
    /// Solidity
    case solidity
    /// SPARQL
    case sparql
    /// SPICE
    case spice
    /// SQL
    case sql
    /// Standard ML
    case sml
    /// Star
    case star
    /// Sweave
    case sweave
    /// Swift
    case swift
    /// SystemVerilog
    case systemverilog
    /// Tcl
    case tcl
    /// Tera
    case tera
    /// Terraform
    case terraform
    /// Texinfo
    case texinfo
    /// Thrift
    case thrift
    /// Todo.txt
    case todotxt
    /// TOML
    case toml
    /// Twig
    case twig
    /// txt2tags
    case t2t
    /// TypeScript
    case typescript
    /// TypeScript JavaScript expression
    case typescriptJsExpr
    /// TypeScript JavaScript function
    case typescriptJsFn
    /// TypeScript JavaScript literal
    case typescriptJsLit
    /// TypeScript JavaScript module
    case typescriptJsMod
    /// TypeScript JavaScript statement
    case typescriptJsSt
    /// TypeScript JSX
    case typescriptJsx
    /// TypeScript type expression
    case typescriptTypeExpr
    /// TypeScript type generic
    case typescriptTypeGen
    /// TypeScript type literal
    case typescriptTypeLit
    /// Vala
    case vala
    /// VB.NET
    case vbnet
    /// Verilog
    case verilog
    /// VHDL
    case vhdl
    /// XML
    case xml
    /// XSLT
    case xslt
    /// Yacc
    case yacc
    /// YAML
    case yaml
    /// YARA
    case yara

    // swiftlint:enable identifier_name

    /// The name of the language for the backend.
    var languageName: String {
        let camelCase = self.rawValue
        var dashedString = ""

        for (index, char) in camelCase.enumerated() {
            if index > 0, char.isUppercase {
                dashedString += "-\(char.lowercased())"
            } else {
                dashedString += String(char)
            }
        }

        return dashedString
    }
}
