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
    vec2 fUVCoord = gl_FragCoord.xy / resolution;
    vec2 vPanZoomCoord = fUVCoord * surfaceSize + surfacePosition;

    vec2 vLineWidth = surfaceSize * 2.0 / resolution;
	
    float fCentreDot = step( length(vPanZoomCoord / vLineWidth), 5.0);
	
    float fGridline = step(fract(vPanZoomCoord.x + vLineWidth.x * 0.5), vLineWidth.x);
	  fGridline += step(fract(vPanZoomCoord.y + vLineWidth.y * 0.5), vLineWidth.y);
	
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
 