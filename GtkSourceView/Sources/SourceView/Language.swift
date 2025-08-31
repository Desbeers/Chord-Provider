//
//  Language.swift
//  CodeEditor
//
//  Created by david-swift on 28.11.23.
//

/// A language available in the code editor.
public enum Language: String, CaseIterable {

    // swiftlint:disable missing_docs identifier_name

    case abnf
    case actionscript
    case ada
    case ansforth94
    case asciidoc
    case asp
    case automake
    case awk
    case bennugd
    case bibtex
    case blueprint
    case bluespec
    case boo
    case c
    case cSharp
    case chordpro
    case cpp
    case cg
    case changelog
    case changes
    case cpphdr
    case cmake
    case chdr
    case cobol
    case commonlisp
    case css
    case csv
    case cuda
    case d
    case dart
    case def
    case desktop
    case diff
    case dtl
    case docbook
    case docker
    case dosbatch
    case dpatch
    case dtd
    case eiffel
    case erb
    case erbHtml
    case erbJs
    case erlang
    case fsharp
    case fcl
    case fish
    case ftl
    case forth
    case fortran
    case gap
    case gdbLog
    case gdscript
    case genie
    case gettextTranslation
    case go
    case gradle
    case dot
    case groovy
    case gtkDoc
    case gtkrc
    case haddock
    case haskell
    case haxe
    case html
    case idl
    case idlExelis
    case imagej
    case ini
    case j
    case jade
    case java
    case js
    case jsVal
    case jsExpr
    case jsFn
    case jsLit
    case jsMod
    case jsSt
    case jsdoc
    case json
    case jsx
    case julia
    case kotlin
    case latex
    case lean
    case less
    case lex
    case libtool
    case haskellLiterate
    case llvm
    case logcat
    case logtalk
    case lua
    case m4
    case makefile
    case mallard
    case markdown
    case matlab
    case maxima
    case mediawiki
    case meson
    case modelica
    case mxml
    case nemerle
    case netrexx
    case nix
    case nsis
    case objc
    case objj
    case ocaml
    case ocl
    case octave
    case ooc
    case opal
    case openclGlsl
    case pascal
    case perl
    case php
    case pig
    case pkgconfig
    case plain
    case powershell
    case prolog
    case proto
    case puppet
    case python3
    case python
    case r
    case reasonml
    case rst
    case rpmspec
    case ruby
    case rust
    case scala
    case scheme
    case scilab
    case scss
    case sh
    case solidity
    case sparql
    case spice
    case sql
    case sml
    case star
    case sweave
    case swift
    case systemverilog
    case tcl
    case tera
    case terraform
    case texinfo
    case thrift
    case todotxt
    case toml
    case twig
    case t2t
    case typescript
    case typescriptJsExpr
    case typescriptJsFn
    case typescriptJsLit
    case typescriptJsMod
    case typescriptJsSt
    case typescriptJsx
    case typescriptTypeExpr
    case typescriptTypeGen
    case typescriptTypeLit
    case vala
    case vbnet
    case verilog
    case vhdl
    case xml
    case xslt
    case yacc
    case yaml
    case yara

    // swiftlint:enable missing_docs identifier_name

    /// The name of the language for the backend.
    var languageName: String {
        let camelCase = self.rawValue
        var dashedString = ""

        for (index, char) in camelCase.enumerated() {
            if index > 0 && char.isUppercase {
                dashedString += "-\(char.lowercased())"
            } else {
                dashedString += String(char)
            }
        }

        return dashedString
    }
}
