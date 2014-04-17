// rotwang: mod*, smoothing, half-circle-fill

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 pos = mod(gl_FragCoord.xy, vec2(50.0, 50.0)) - vec2(25.0, 25.0);
      float dist_squared = dot(pos, pos);
	float d = smoothstep(400.0, 500.0, dist_squared);
	float k = step(floor(pos.y),0.5);
	vec3 clr = mix( vec3(k), vec3(0.5), d);
 gl_FragColor =  vec4(clr, 1.0);
       
}