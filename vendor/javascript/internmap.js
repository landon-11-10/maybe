class InternMap extends Map{constructor(e,t=keyof){super();Object.defineProperties(this,{_intern:{value:new Map},_key:{value:t}});if(null!=e)for(const[t,n]of e)this.set(t,n)}get(e){return super.get(intern_get(this,e))}has(e){return super.has(intern_get(this,e))}set(e,t){return super.set(intern_set(this,e),t)}delete(e){return super.delete(intern_delete(this,e))}}class InternSet extends Set{constructor(e,t=keyof){super();Object.defineProperties(this,{_intern:{value:new Map},_key:{value:t}});if(null!=e)for(const t of e)this.add(t)}has(e){return super.has(intern_get(this,e))}add(e){return super.add(intern_set(this,e))}delete(e){return super.delete(intern_delete(this,e))}}function intern_get({_intern:e,_key:t},n){const r=t(n);return e.has(r)?e.get(r):n}function intern_set({_intern:e,_key:t},n){const r=t(n);if(e.has(r))return e.get(r);e.set(r,n);return n}function intern_delete({_intern:e,_key:t},n){const r=t(n);if(e.has(r)){n=e.get(r);e.delete(r)}return n}function keyof(e){return null!==e&&"object"===typeof e?e.valueOf():e}export{InternMap,InternSet};

