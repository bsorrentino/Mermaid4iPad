var e=globalThis,t={},s={},i=e.parcelRequire7292;null==i&&((i=function(e){if(e in t)return t[e].exports;if(e in s){var i=s[e];delete s[e];var n={id:e,exports:{}};return t[e]=n,i.call(n.exports,n,n.exports),n.exports}var a=Error("Cannot find module '"+e+"'");throw a.code="MODULE_NOT_FOUND",a}).register=function(e,t){s[e]=t},e.parcelRequire7292=i),i.register;var n=i("4jcZX"),a=i("2YFJl");class r extends HTMLElement{static get observedAttributes(){return["theme"]}attributeChangedCallback(e,t,s){console.debug("attributeChangedCallback",e,t,s),"theme"===e&&t!==s&&(this.#e(),this.#t())}constructor(){super(),this._content=null,this._activeClass=null,this._lastTransform=null;let e=this.attachShadow({mode:"open"}),t=document.createElement("style");t.textContent=`
    :host {
      display: block;
      width: 100%;
      height: 100%;
    }
    .h-full {
      height: 100%;
    }
    .w-full {
      width: 100%;
    }
    .flex {
      display: flex;
    }
    .items-center {
      align-items: center;
    }
    .justify-center {
      justify-content: center;
    }
    .bg-neutral {
      --tw-bg-opacity: 1;
      background-color: var(--fallback-n,oklch(var(--n)/var(--tw-bg-opacity)));
  }
    `,e.appendChild(t);let s=document.createElement("div");s.classList.add("h-full"),s.classList.add("w-full"),s.classList.add("flex"),s.classList.add("items-center"),s.classList.add("justify-center"),s.classList.add("bg-neutral"),s.classList.add("mermaid");let i=document.createElement("slot");i.name="error",s.appendChild(i),e.appendChild(s),this.#t()}get #s(){return Array.from(this.childNodes).filter(e=>e.nodeType===this.TEXT_NODE).map(e=>e.textContent?.trim()).join("")}get #i(){return this._content?this._activeClass?`
        ${this._content}
        classDef ${this._activeClass} fill:#f96
        `:this._content:this.#s}async #t(){if(!this.#i)return;let e=this.shadowRoot.querySelector(".mermaid");return(0,n.N).render("graph",this.#i).then(t=>{let{right:s,bottom:i}=e.getBoundingClientRect();console.debug("svgContainer",s,i);let n=t.svg.replace(/height="[\d\.]+"/,`height="${i}"`).replace(/width="[\d\.]+"/,`width="${s}"`);e.innerHTML=n}).then(()=>this.#n()).catch(e=>{console.error("RENDER ERROR",e);let t=this.shadowRoot.querySelector('slot[name="error"]');t&&(t.assignedElements()[0].textContent=e.message)})}#n(){let e=a.select(this.shadowRoot).select(".mermaid svg"),t=this;e.each(function(){let e=a.select(this);e.html("<g>"+e.html()+"</g>");let s=e.select("g"),i=a.zoom().on("zoom",e=>{s.attr("transform",e.transform),t._lastTransform=e.transform}),n=e.call(i);null!==t._lastTransform&&(s.attr("transform",t._lastTransform),n.call(i.transform,t._lastTransform))})}#a(e){let{detail:t}=e;this._content=t,this.#t()}#r(e){let{detail:t}=e;this._activeClass=t,this.#t()}#e(){console.debug("#init",this.attributes.theme),(0,n.N).initialize({logLevel:"none",startOnLoad:!1,theme:this.getAttribute("theme")??"dark",flowchart:{useMaxWidth:!1},sequence:{useMaxWidth:!1},gantt:{useMaxWidth:!1},journey:{useMaxWidth:!1},timeline:{useMaxWidth:!1},class:{useMaxWidth:!1},state:{useMaxWidth:!1},er:{useMaxWidth:!1},pie:{useMaxWidth:!1},quadrantChart:{useMaxWidth:!1},xyChart:{useMaxWidth:!1},requirement:{useMaxWidth:!1},mindmap:{useMaxWidth:!1},gitGraph:{useMaxWidth:!1},c4:{useMaxWidth:!1},sankey:{useMaxWidth:!1},block:{useMaxWidth:!1}})}#l=()=>this.#t();connectedCallback(){this.addEventListener("graph",this.#a),this.addEventListener("graph-active",this.#r),window.addEventListener("resize",this.#l)}disconnectedCallback(){this.removeEventListener("graph",this.#a),this.removeEventListener("graph-active",this.#r),window.removeEventListener("resize",this.#l)}}window.customElements.get("mermaid-preview")||window.customElements.define("mermaid-preview",r);
//# sourceMappingURL=index-light.a9bae24d.js.map
