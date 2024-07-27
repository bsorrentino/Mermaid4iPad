function e(e,l,t,a){Object.defineProperty(e,l,{get:t,set:a,enumerable:!0,configurable:!0})}var l=globalThis.parcelRequire7292,t=l.register;t("7IZkM",function(t,a){e(t.exports,"diagram",()=>h);var i=l("g9b1o"),n=l("2YFJl"),o=l("4LkSm"),r=l("4jcZX"),s=l("4FlE0");l("eJNXH"),l("gngdn"),l("2ujND"),l("i8Fxz"),l("hV1gR"),l("c0ySZ");let d=e=>(0,r.e).sanitizeText(e,(0,r.c)()),c={dividerMargin:10,padding:5,textHeight:10,curve:void 0},p=function(e,l,t,a){let i=Object.keys(e);(0,r.l).info("keys:",i),(0,r.l).info(e),i.forEach(function(i){var n,o;let s=e[i],c={shape:"rect",id:s.id,domId:s.domId,labelText:d(s.id),labelStyle:"",style:"fill: none; stroke: black",padding:(null==(n=(0,r.c)().flowchart)?void 0:n.padding)??(null==(o=(0,r.c)().class)?void 0:o.padding)};l.setNode(s.id,c),b(s.classes,l,t,a,s.id),(0,r.l).info("setNode",c)})},b=function(e,l,t,a,i){let n=Object.keys(e);(0,r.l).info("keys:",n),(0,r.l).info(e),n.filter(l=>e[l].parent==i).forEach(function(t){var n,o;let s=e[t],c=s.cssClasses.join(" "),p=(0,r.k)(s.styles),b=s.label??s.id,u={labelStyle:p.labelStyle,shape:"class_box",labelText:d(b),classData:s,rx:0,ry:0,class:c,style:p.style,id:s.id,domId:s.domId,tooltip:a.db.getTooltip(s.id,i)||"",haveCallback:s.haveCallback,link:s.link,width:"group"===s.type?500:void 0,type:s.type,padding:(null==(n=(0,r.c)().flowchart)?void 0:n.padding)??(null==(o=(0,r.c)().class)?void 0:o.padding)};l.setNode(s.id,u),i&&l.setParent(s.id,i),(0,r.l).info("setNode",u)})},u=function(e,l,t,a){(0,r.l).info(e),e.forEach(function(e,i){var o,s;let p={labelStyle:"",shape:"note",labelText:d(e.text),noteData:e,rx:0,ry:0,class:"",style:"",id:e.id,domId:e.id,tooltip:"",type:"note",padding:(null==(o=(0,r.c)().flowchart)?void 0:o.padding)??(null==(s=(0,r.c)().class)?void 0:s.padding)};if(l.setNode(e.id,p),(0,r.l).info("setNode",p),!e.class||!(e.class in a))return;let b=t+i,u={id:`edgeNote${b}`,classes:"relation",pattern:"dotted",arrowhead:"none",startLabelRight:"",endLabelLeft:"",arrowTypeStart:"none",arrowTypeEnd:"none",style:"fill:none",labelStyle:"",curve:(0,r.n)(c.curve,n.curveLinear)};l.setEdge(e.id,e.class,u,b)})},g=function(e,l){let t=(0,r.c)().flowchart,a=0;e.forEach(function(e){var i;a++;let o={classes:"relation",pattern:1==e.relation.lineType?"dashed":"solid",id:`id_${e.id1}_${e.id2}_${a}`,arrowhead:"arrow_open"===e.type?"none":"normal",startLabelRight:"none"===e.relationTitle1?"":e.relationTitle1,endLabelLeft:"none"===e.relationTitle2?"":e.relationTitle2,arrowTypeStart:y(e.relation.type1),arrowTypeEnd:y(e.relation.type2),style:"fill:none",labelStyle:"",curve:(0,r.n)(null==t?void 0:t.curve,n.curveLinear)};if((0,r.l).info(o,e),void 0!==e.style){let l=(0,r.k)(e.style);o.style=l.style,o.labelStyle=l.labelStyle}e.text=e.title,void 0===e.text?void 0!==e.style&&(o.arrowheadStyle="fill: #333"):(o.arrowheadStyle="fill: #333",o.labelpos="c",(null==(i=(0,r.c)().flowchart)?void 0:i.htmlLabels)??(0,r.c)().htmlLabels?(o.labelType="html",o.label='<span class="edgeLabel">'+e.text+"</span>"):(o.labelType="text",o.label=e.text.replace(r.e.lineBreakRegex,"\n"),void 0===e.style&&(o.style=o.style||"stroke: #333; stroke-width: 1.5px;fill:none"),o.labelStyle=o.labelStyle.replace("color:","fill:"))),l.setEdge(e.id1,e.id2,o,a)})},f=async function(e,l,t,a){let i;(0,r.l).info("Drawing class - ",l);let d=(0,r.c)().flowchart??(0,r.c)().class,c=(0,r.c)().securityLevel;(0,r.l).info("config:",d);let f=(null==d?void 0:d.nodeSpacing)??50,y=(null==d?void 0:d.rankSpacing)??50,h=new o.Graph({multigraph:!0,compound:!0}).setGraph({rankdir:a.db.getDirection(),nodesep:f,ranksep:y,marginx:8,marginy:8}).setDefaultEdgeLabel(function(){return{}}),v=a.db.getNamespaces(),w=a.db.getClasses(),x=a.db.getRelations(),k=a.db.getNotes();(0,r.l).info(x),p(v,h,l,a),b(w,h,l,a),g(x,h),u(k,h,x.length+1,w),"sandbox"===c&&(i=(0,n.select)("#i"+l));let m="sandbox"===c?(0,n.select)(i.nodes()[0].contentDocument.body):(0,n.select)("body"),T=m.select(`[id="${l}"]`),S=m.select("#"+l+" g");if(await (0,s.r)(S,h,["aggregation","extension","composition","dependency","lollipop"],"classDiagram",l),(0,r.u).insertTitle(T,"classTitleText",(null==d?void 0:d.titleTopMargin)??5,a.db.getDiagramTitle()),(0,r.o)(h,T,null==d?void 0:d.diagramPadding,null==d?void 0:d.useMaxWidth),!(null==d?void 0:d.htmlLabels)){let e="sandbox"===c?i.nodes()[0].contentDocument:document;for(let t of e.querySelectorAll('[id="'+l+'"] .edgeLabel .label')){let l=t.getBBox(),a=e.createElementNS("http://www.w3.org/2000/svg","rect");a.setAttribute("rx",0),a.setAttribute("ry",0),a.setAttribute("width",l.width),a.setAttribute("height",l.height),t.insertBefore(a,t.firstChild)}}};function y(e){let l;switch(e){case 0:l="aggregation";break;case 1:l="extension";break;case 2:l="composition";break;case 3:l="dependency";break;case 4:l="lollipop";break;default:l="none"}return l}let h={parser:i.p,db:i.d,renderer:{setConf:function(e){c={...c,...e}},draw:f},styles:i.s,init:e=>{e.class||(e.class={}),e.class.arrowMarkerAbsolute=e.arrowMarkerAbsolute,(0,i.d).clear()}}}),t("hNIl0",function(t,a){e(t.exports,"default",()=>n);var i=l("gbpSA"),n=function(e){return(0,i.default)(e,4)}});
//# sourceMappingURL=classDiagram-v2-a2b738ad.6fec89d7.js.map
