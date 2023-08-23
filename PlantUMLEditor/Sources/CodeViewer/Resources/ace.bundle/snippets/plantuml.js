ace.define("ace/snippets/plantuml.snippets",["require","exports","module"],function(e,t,n){n.exports='\n# Boundaries\nsnippet start\n	@startuml ${1:diagram name}\n	$0\n	@enduml\n# Scale\nsnippet scale\n	scale ${1:1.5}\n	${2:scale 1.5 | scale 200 width | scale 100 height | scale [max] 200x100}\n# Title\nsnippet tt\n	title \n	${1:multi-line text}$0\n	end title\n# Caption\nsnippet cap\n	caption ${1:Figure x.x description...}\n	$0\n# Legend\nsnippet leg\n	legend,\n		$0\n	end legend\n# node under\nsnippet lnk\n	${1:objAlias} ${2:.}. ${3:noteAlias}\n	$0\n# Note with direction\nsnippet nta\n	note "${1:single-line note}" as ${2:noteAlias}\n	$0\n# Link\nsnippet nts\n	note ${1|left,right,top,bottom|} of ${2:objAlias}: ${3:single-line note}\n# Note multilines\nsnippet ntm\n	note ${1|left,right,top,bottom|} of ${2:objAlias}\n		$0\n	end note\n# Header\n# This may be used to provide a date/time stamp of when the diagram was authored/reviewed\nsnippet hd\n	header ${1:last-updated xx/xx/xxxx}\n	$0\n# Header multilines\nsnippet hdn\n	header\n	${1:last-updated xx/xx/xxxx}$0\n	end header\n# Footer      \nsnippet ft\n	footer ${1:authored by xxx}\n	$0\n# Footer multilines\nsnippet ftn\n	footer\n	${1:authored by xxx}$0",\n	end footer\n# Separator\nsnippet sep\n	newpage ${1:title text}\n	$0\n'}),ace.define("ace/snippets/plantuml",["require","exports","module","ace/snippets/plantuml.snippets"],function(e,t,n){"use strict";t.snippetText=e("./plantuml.snippets"),t.scope="plantuml"});                (function() {
                    ace.require(["ace/snippets/plantuml"], function(m) {
                        if (typeof module == "object" && typeof exports == "object" && module) {
                            module.exports = m;
                        }
                    });
                })();
            