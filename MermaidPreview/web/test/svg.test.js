




import { test, expect, mock } from "bun:test";

test("sequence ", () => {
    const svg = 
        `<svg aria-roledescription="sequence" role="graphics-document document" viewBox="-50 -50 484 403"
            style="max-width: 484px;" xmlns="http://www.w3.org/2000/svg" width="100%" id="graph">
        </svg>`
 
        svg.match( )
    expect( svg.match( /width="[\d\.%]+"/) ).not.toBeNull()
    expect( svg.match( /height="[\d\.%]+"/) ).toBeNull()
});