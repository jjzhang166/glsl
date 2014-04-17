#ifdef GL_ES
precision highp float;
#endif
 
uniform float time;

uniform vec2 mouse;
uniform vec2 resolution;
 
// These enable pan/zoom controls
uniform vec2 surfaceSize;
varying vec2 surfacePosition;

//uniform sampler2D backbuffer;

void main( void )
{
    // It's possible to use surfacePosition without looking at gl_FragCoord or resolution.
    // The framework takes care of the aspect ratio for you, and the surface moves
    // one-to-one pixel with the mouse at any zoom level.  @emackey
    vec2 vPanZoomCoord = surfacePosition * 10.0;

    float vLineWidth = surfaceSize.y * 20.0 / resolution.y;

    float fCentreDot = step( length(vPanZoomCoord / vLineWidth), 5.0);

    float fGridline = step(fract(vPanZoomCoord.x + vLineWidth * 0.5), vLineWidth);
	  fGridline += step(fract(vPanZoomCoord.y + vLineWidth * 0.5), vLineWidth);

    vec3 cFinal = vec3( fCentreDot, 0.0, fGridline );

/*    
    // 3d zoom changes with grid size
    float fZoom = surfaceSize.y;
   
    // 3d heading changes with dot horizontal position
    float fHeading = vPanZoomCoord.x;

    // 3d elevation changes with dot vertical postition
    float fElevation = vPanZoomCoord.y;
*/


	
    gl_FragColor = vec4( cFinal, 1.0 );
}
 