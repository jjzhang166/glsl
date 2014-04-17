#ifdef GL_ES
precision highp float;
//gyabo
#endif
uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;
uniform sampler2D backbuffer;

void update_pixel( void ) {
  
}

void main( void ) {
    vec2 pp = gl_FragCoord.xy / resolution;
    vec2 tx = 0.5*pp-0.5;
    //if(pp.y > 0.8) {
      vec2 position = gl_FragCoord.xy / resolution.xy;
      if( int(gl_FragCoord.x) > 0 && int(gl_FragCoord.y + sin( 8.7 * sin(time + gl_FragCoord.x * sin(time * 0.3) * 0.015)) * 150.0) == 600 - int(sin(time) * 30.0))  {
        vec4 v0 = texture2D( backbuffer, pp);
        gl_FragColor = vec4(1.0);
        return;
      }
      if( int(gl_FragCoord.x) > 0 && int(gl_FragCoord.y + sin(time + gl_FragCoord.x * 3.5) * 150.0) == 250 - int(sin(time) * 10.0))  {
        vec4 v0 = texture2D( backbuffer, pp);
        gl_FragColor = vec4(1.0);
        return;
      }
  
    //}
    //if(pp.y < 0.2) {
    //  gl_FragColor = vec4(0.0);
    //  return;
    //}
  
    //vec2 position = gl_FragCoord.xy / resolution.xy;
    vec4 v0 = texture2D( backbuffer, position);
    gl_FragColor = vec4(v0 + 0.01);
    gl_FragColor = vec4(0.2);
  
}
