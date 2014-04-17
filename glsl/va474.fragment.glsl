// By @paulofalcao
//
// Blobs

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
 {

   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);
   
   vec2 circle_center = vec2(0.0, 0.0);
   float circle_radius = 0.2;

   if( (p.x*p.x + p.y*p.y) > (circle_radius * circle_radius) )
      gl_FragColor = vec4(0.0,1.0,0.0,1.0);
   else
      gl_FragColor = vec4(0.0,0.0,0.0,1.0);
}