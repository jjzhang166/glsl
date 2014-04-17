#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
  vec2 pos = (gl_FragCoord.xy * 2.0 - resolution) / resolution.y ;
  
  vec3 camPos = vec3( 0.0, 0.0, 3.0 );
  vec3 camDir = vec3( 0.0, 0.0, -1.0 ) ;
  vec3 camUp = vec3( 0.0, 1.0, 0.0 ) ;
  vec3 camSide = cross( camDir, camUp ) ;
  float focus = 1.8 ;
    
  vec3 rayDir = normalize( camSide * pos.x + camUp * pos.y + camDir * focus );

  gl_FragColor = vec4( rayDir.xy * 2.0, -rayDir.z, 1.0 ) ;
}