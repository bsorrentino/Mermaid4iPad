var t=globalThis,e={},i={},s=t.parcelRequire7292;null==s&&((s=function(t){if(t in e)return e[t].exports;if(t in i){var s=i[t];delete i[t];var a={id:t,exports:{}};return e[t]=a,s.call(a.exports,a,a.exports),a.exports}var n=Error("Cannot find module '"+t+"'");throw n.code="MODULE_NOT_FOUND",n}).register=function(t,e){i[t]=e},t.parcelRequire7292=s),s.register;var a=s("4jcZX"),n=s("2YFJl");class r extends HTMLElement{static get observedAttributes(){return["theme"]}attributeChangedCallback(t,e,i){console.debug("attributeChangedCallback",t,e,i),"theme"===t&&e!==i&&(this.#t(),this.#e())}constructor(){super(),this._content=null,this._activeClass=null,this._lastTransform=null;let t=this.attachShadow({mode:"open"}),e=document.createElement("style");e.textContent=`
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
    `,t.appendChild(e);let i=document.createElement("div");i.classList.add("h-full"),i.classList.add("w-full"),i.classList.add("flex"),i.classList.add("items-center"),i.classList.add("justify-center"),i.classList.add("bg-neutral"),i.classList.add("mermaid"),t.appendChild(i),this.#e()}get #i(){return Array.from(this.childNodes).filter(t=>t.nodeType===this.TEXT_NODE).map(t=>t.textContent?.trim()).join("")}get #s(){return this._content?this._activeClass?`
        ${this._content}
        classDef ${this._activeClass} fill:#f96
        `:this._content:this.#i}async #e(){if(!this.#s)return;let t=this.shadowRoot.querySelector(".mermaid");return(0,a.N).render("graph",this.#s).then(e=>{let{right:i,bottom:s}=t.getBoundingClientRect();console.debug("svgContainer",i,s);let a=e.svg.replace(/height="[\d\.]+"/,`height="${s}"`).replace(/width="[\d\.]+"/,`width="${i}"`);t.innerHTML=a}).then(()=>this.#a()).catch(t=>console.error("RENDER ERROR",t))}#a(){let t=n.select(this.shadowRoot).select(".mermaid svg"),e=this;t.each(function(){let t=n.select(this);t.html("<g>"+t.html()+"</g>");let i=t.select("g"),s=n.zoom().on("zoom",t=>{i.attr("transform",t.transform),e._lastTransform=t.transform}),a=t.call(s);null!==e._lastTransform&&(i.attr("transform",e._lastTransform),a.call(s.transform,e._lastTransform))})}#n(t){let{detail:e}=t;this._content=e,this.#e()}#r(t){let{detail:e}=t;this._activeClass=e,this.#e()}#t(){console.debug("#init",this.attributes.theme),(0,a.N).initialize({logLevel:"none",startOnLoad:!1,theme:this.getAttribute("theme")??"dark",flowchart:{useMaxWidth:!1},sequence:{useMaxWidth:!1},gantt:{useMaxWidth:!1},journey:{useMaxWidth:!1},timeline:{useMaxWidth:!1},class:{useMaxWidth:!1},state:{useMaxWidth:!1},er:{useMaxWidth:!1},pie:{useMaxWidth:!1},quadrantChart:{useMaxWidth:!1},xyChart:{useMaxWidth:!1},requirement:{useMaxWidth:!1},mindmap:{useMaxWidth:!1},gitGraph:{useMaxWidth:!1},c4:{useMaxWidth:!1},sankey:{useMaxWidth:!1},block:{useMaxWidth:!1}})}#l=()=>this.#e();connectedCallback(){this.addEventListener("graph",this.#n),this.addEventListener("graph-active",this.#r),window.addEventListener("resize",this.#l)}disconnectedCallback(){this.removeEventListener("graph",this.#n),this.removeEventListener("graph-active",this.#r),window.removeEventListener("resize",this.#l)}}window.customElements.get("mermaid-preview")||window.customElements.define("mermaid-preview",r);
//# sourceMappingURL=index-light.28d93f85.js.map
