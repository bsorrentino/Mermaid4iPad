//
//  File.swift
//  
//
//  Created by Bartolomeo Sorrentino on 21/08/23.
//

import Foundation


extension CodeWebView {
    
    public enum Mode: String {
        case abap = "abap"
        case abc = "abc"
        case actionscript = "actionscript"
        case ada = "ada"
        case alda = "alda"
        case apache_conf = "apache_conf"
        case apex = "apex"
        case applescript = "applescript"
        case aql = "aql"
        case asciidoc = "asciidoc"
        case asl = "asl"
        case assembly_x86 = "assembly_x86"
        case autohotkey = "autohotkey"
        case batchfile = "batchfile"
        case c9search = "c9search"
        case c_cpp = "c_cpp"
        case cirru = "cirru"
        case clojure = "clojure"
        case cobol = "cobol"
        case coffee = "coffee"
        case coldfusion = "coldfusion"
        case crystal = "crystal"
        case csharp = "csharp"
        case csound_document = "csound_document"
        case csound_orchestra = "csound_orchestra"
        case csound_score = "csound_score"
        case csp = "csp"
        case css = "css"
        case curly = "curly"
        case d = "d"
        case dart = "dart"
        case diff = "diff"
        case django = "django"
        case dockerfile = "dockerfile"
        case dot = "dot"
        case drools = "drools"
        case edifact = "edifact"
        case eiffel = "eiffel"
        case ejs = "ejs"
        case elixir = "elixir"
        case elm = "elm"
        case erlang = "erlang"
        case forth = "forth"
        case fortran = "fortran"
        case fsharp = "fsharp"
        case fsl = "fsl"
        case ftl = "ftl"
        case gcode = "gcode"
        case gherkin = "gherkin"
        case gitignore = "gitignore"
        case glsl = "glsl"
        case gobstones = "gobstones"
        case golang = "golang"
        case graphqlschema = "graphqlschema"
        case groovy = "groovy"
        case haml = "haml"
        case handlebars = "handlebars"
        case haskell = "haskell"
        case haskell_cabal = "haskell_cabal"
        case haxe = "haxe"
        case hjson = "hjson"
        case html = "html"
        case html_elixir = "html_elixir"
        case html_ruby = "html_ruby"
        case ini = "ini"
        case io = "io"
        case jack = "jack"
        case jade = "jade"
        case java = "java"
        case javascript = "javascript"
        case json = "json"
        case json5 = "json5"
        case jsoniq = "jsoniq"
        case jsp = "jsp"
        case jssm = "jssm"
        case jsx = "jsx"
        case julia = "julia"
        case kotlin = "kotlin"
        case latex = "latex"
        case less = "less"
        case liquid = "liquid"
        case lisp = "lisp"
        case livescript = "livescript"
        case logiql = "logiql"
        case logtalk = "logtalk"
        case lsl = "lsl"
        case lua = "lua"
        case luapage = "luapage"
        case lucene = "lucene"
        case makefile = "makefile"
        case markdown = "markdown"
        case mask = "mask"
        case matlab = "matlab"
        case maze = "maze"
        case mediawiki = "mediawiki"
        case mel = "mel"
        case mixal = "mixal"
        case mushcode = "mushcode"
        case mysql = "mysql"
        case nginx = "nginx"
        case nim = "nim"
        case nix = "nix"
        case nsis = "nsis"
        case nunjucks = "nunjucks"
        case objectivec = "objectivec"
        case ocaml = "ocaml"
        case pascal = "pascal"
        case perl = "perl"
        case perl6 = "perl6"
        case pgsql = "pgsql"
        case php = "php"
        case php_laravel_blade = "php_laravel_blade"
        case pig = "pig"
        case plain_text = "plain_text"
        case plantuml = "plantuml"
        case powershell = "powershell"
        case praat = "praat"
        case prisma = "prisma"
        case prolog = "prolog"
        case properties = "properties"
        case protobuf = "protobuf"
        case puppet = "puppet"
        case python = "python"
        case qml = "qml"
        case r = "r"
        case razor = "razor"
        case rdoc = "rdoc"
        case red = "red"
        case redshift = "redshift"
        case rhtml = "rhtml"
        case rst = "rst"
        case ruby = "ruby"
        case rust = "rust"
        case sass = "sass"
        case scad = "scad"
        case scala = "scala"
        case scheme = "scheme"
        case scss = "scss"
        case sh = "sh"
        case sjs = "sjs"
        case slim = "slim"
        case smarty = "smarty"
        case snippets = "snippets"
        case soy_template = "soy_template"
        case space = "space"
        case sparql = "sparql"
        case sql = "sql"
        case sqlserver = "sqlserver"
        case stylus = "stylus"
        case svg = "svg"
        case swift = "swift"
        case tcl = "tcl"
        case terraform = "terraform"
        case tex = "tex"
        case text = "text"
        case textile = "textile"
        case toml = "toml"
        case tsx = "tsx"
        case turtle = "turtle"
        case twig = "twig"
        case typescript = "typescript"
        case vala = "vala"
        case vbscript = "vbscript"
        case velocity = "velocity"
        case verilog = "verilog"
        case vhdl = "vhdl"
        case visualforce = "visualforce"
        case wollok = "wollok"
        case xml = "xml"
        case xquery = "xquery"
        case yaml = "yaml"
        case zeek = "zeek"
    }
    

}
